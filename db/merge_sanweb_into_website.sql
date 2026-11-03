-- =====================================================================
-- Merge the Sanpoly website database (SanWeb) into the SRS database (website)
-- Both schemas must be on the SAME MySQL server.
--
-- BEFORE RUNNING
--   1. Back up `website`  (Workbench: Server > Data Export > website > Dump Structure and Data)
--   2. Workbench: Edit > Preferences > SQL Editor > "DBMS connection read timeout" = 600
--      (photos are ~70 MB, the copy can take a minute)
--   3. Stop Tomcat (or make sure nobody edits pages while this runs)
--
-- RUN: open this file in Workbench and execute everything (lightning icon).
--      Read the result grids at the end.
--
-- SAFE TO RE-RUN: the merge stops if Sanpoly pages are already in `website`.
-- SanWeb is only read, never changed - it stays as your backup.
-- =====================================================================

USE website;

DROP PROCEDURE IF EXISTS merge_prepare_schema;
DROP PROCEDURE IF EXISTS merge_sanweb;

DELIMITER $$

-- ---------------------------------------------------------------------
-- Step 1: one database for many websites -> every content row has a site
-- (DDL is done first because MySQL cannot roll back ALTER TABLE)
-- ---------------------------------------------------------------------
CREATE PROCEDURE merge_prepare_schema()
BEGIN
    -- site column on content tables (pages / latest_news / upcoming_events may already have it)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = 'website' AND table_name = 'pages' AND column_name = 'site') THEN
        ALTER TABLE pages ADD COLUMN site VARCHAR(20) NOT NULL DEFAULT 'srs', ADD INDEX idx_pages_site (site);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = 'website' AND table_name = 'latest_news' AND column_name = 'site') THEN
        ALTER TABLE latest_news ADD COLUMN site VARCHAR(20) NOT NULL DEFAULT 'srs', ADD INDEX idx_news_site (site);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = 'website' AND table_name = 'upcoming_events' AND column_name = 'site') THEN
        ALTER TABLE upcoming_events ADD COLUMN site VARCHAR(20) NOT NULL DEFAULT 'srs', ADD INDEX idx_upev_site (site);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = 'website' AND table_name = 'alumni_registrations' AND column_name = 'site') THEN
        ALTER TABLE alumni_registrations ADD COLUMN site VARCHAR(20) NOT NULL DEFAULT 'srs', ADD INDEX idx_alumni_site (site);
    END IF;

    -- a page slug (e.g. 'home') must be unique per website, not across all websites
    IF EXISTS (SELECT 1 FROM information_schema.statistics
               WHERE table_schema = 'website' AND table_name = 'pages' AND index_name = 'slug') THEN
        ALTER TABLE pages DROP INDEX slug;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics
                   WHERE table_schema = 'website' AND table_name = 'pages' AND index_name = 'uq_pages_site_slug') THEN
        ALTER TABLE pages ADD UNIQUE KEY uq_pages_site_slug (site, slug);
    END IF;

    -- an alumni e-mail must be unique per website
    IF EXISTS (SELECT 1 FROM information_schema.statistics
               WHERE table_schema = 'website' AND table_name = 'alumni_registrations' AND index_name = 'uq_alumni_email') THEN
        ALTER TABLE alumni_registrations DROP INDEX uq_alumni_email;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics
                   WHERE table_schema = 'website' AND table_name = 'alumni_registrations' AND index_name = 'uq_alumni_site_email') THEN
        ALTER TABLE alumni_registrations ADD UNIQUE KEY uq_alumni_site_email (site, email);
    END IF;

    -- SanWeb allows section text up to 5000 characters, website only 4500: widen (never shortens data)
    IF (SELECT character_maximum_length FROM information_schema.columns
        WHERE table_schema = 'website' AND table_name = 'sections' AND column_name = 'content') < 5000 THEN
        ALTER TABLE sections MODIFY content VARCHAR(5000) DEFAULT NULL;
    END IF;

    -- photos moved to the bucket keep only their place here
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = 'website' AND table_name = 'section_images' AND column_name = 'file_key') THEN
        ALTER TABLE section_images ADD COLUMN file_key VARCHAR(300) NULL;
    END IF;
END$$

-- ---------------------------------------------------------------------
-- Step 2: copy Sanpoly pages, sections and photos with new ids (one transaction)
-- ---------------------------------------------------------------------
CREATE PROCEDURE merge_sanweb()
BEGIN
    DECLARE p_off BIGINT;
    DECLARE s_off BIGINT;
    DECLARE i_off BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF EXISTS (SELECT 1 FROM website.pages WHERE site = 'sanpoly') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sanpoly pages are already in website - merge was done before. Nothing changed.';
    END IF;

    START TRANSACTION;

    -- new id = old SanWeb id + offset, so links between pages, sections and photos stay correct
    SELECT COALESCE(MAX(id), 0) INTO p_off FROM website.pages FOR UPDATE;
    SELECT COALESCE(MAX(id), 0) INTO s_off FROM website.sections FOR UPDATE;
    SELECT COALESCE(MAX(id), 0) INTO i_off FROM website.section_images FOR UPDATE;

    -- pages (parents linked afterwards, because a child may come before its parent)
    INSERT INTO website.pages (id, parent_id, title, slug, created_at, site)
    SELECT o.id + p_off, NULL, o.title, o.slug, o.created_at, 'sanpoly'
    FROM SanWeb.pages o;

    UPDATE website.pages w
    JOIN SanWeb.pages o      ON w.id = o.id + p_off
    JOIN SanWeb.pages parent ON parent.id = o.parent_id
    SET w.parent_id = o.parent_id + p_off
    WHERE w.site = 'sanpoly' AND w.id > p_off;

    -- sections of existing Sanpoly pages (sections whose page was deleted are skipped)
    INSERT INTO website.sections (id, page_id, section_type, sequence_order, title, content)
    SELECT o.id + s_off, o.page_id + p_off, o.section_type, o.sequence_order, o.title, o.content
    FROM SanWeb.sections o
    JOIN SanWeb.pages pg ON pg.id = o.page_id;

    -- photos of those sections
    INSERT INTO website.section_images
        (id, section_id, image_data, image_type, alt_text, sequence_order, created_at, Heading1, Heading2, file_key)
    SELECT o.id + i_off, o.section_id + s_off, o.image_data, o.image_type, o.alt_text, o.sequence_order,
           o.created_at, o.Heading1, o.Heading2, NULL
    FROM SanWeb.section_images o
    JOIN SanWeb.sections sc ON sc.id = o.section_id
    JOIN SanWeb.pages pg    ON pg.id = sc.page_id;

    COMMIT;

    SELECT p_off AS page_id_offset, s_off AS section_id_offset, i_off AS image_id_offset;
END$$

DELIMITER ;

SET @old_safe := @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

CALL merge_prepare_schema();
CALL merge_sanweb();

SET SQL_SAFE_UPDATES = @old_safe;

-- ---------------------------------------------------------------------
-- Step 3: check. "copied" must equal "in SanWeb (usable)".
-- ---------------------------------------------------------------------
SELECT 'pages' AS what,
       (SELECT COUNT(*) FROM SanWeb.pages) AS in_sanweb_usable,
       (SELECT COUNT(*) FROM website.pages WHERE site = 'sanpoly') AS copied
UNION ALL
SELECT 'sections',
       (SELECT COUNT(*) FROM SanWeb.sections o JOIN SanWeb.pages p ON p.id = o.page_id),
       (SELECT COUNT(*) FROM website.sections s JOIN website.pages p ON p.id = s.page_id WHERE p.site = 'sanpoly')
UNION ALL
SELECT 'photos',
       (SELECT COUNT(*) FROM SanWeb.section_images o JOIN SanWeb.sections s ON s.id = o.section_id
                                                     JOIN SanWeb.pages p ON p.id = s.page_id),
       (SELECT COUNT(*) FROM website.section_images i JOIN website.sections s ON s.id = i.section_id
                                                      JOIN website.pages p ON p.id = s.page_id WHERE p.site = 'sanpoly')
UNION ALL
SELECT 'sections skipped (page deleted in SanWeb)',
       (SELECT COUNT(*) FROM SanWeb.sections o LEFT JOIN SanWeb.pages p ON p.id = o.page_id WHERE p.id IS NULL),
       0;

SELECT site, COUNT(*) AS pages FROM website.pages GROUP BY site;

DROP PROCEDURE IF EXISTS merge_prepare_schema;
DROP PROCEDURE IF EXISTS merge_sanweb;
