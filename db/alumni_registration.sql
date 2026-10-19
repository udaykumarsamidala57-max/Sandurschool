-- =========================================================
-- ALUMNI REGISTRATION  (Sandur Residential School)
-- Matches the paper "Alumni Registration Form".
-- Run once on the SRS database (Railway MySQL, schema `website`).
-- =========================================================

-- ---------- 1. Table ----------
CREATE TABLE IF NOT EXISTS alumni_registrations (
    id                        BIGINT        NOT NULL AUTO_INCREMENT,
    full_name                 VARCHAR(150)  NOT NULL,                 -- Name
    date_of_birth             DATE          NOT NULL,                 -- Date of Birth
    study_from_year           SMALLINT      NOT NULL,                 -- Years of Study: From
    study_to_year             SMALLINT      NOT NULL,                 -- Years of Study: To
    passing_year_x            SMALLINT      NULL,                     -- Year of Passing: X Class
    passing_year_xii          SMALLINT      NULL,                     -- Year of Passing: XII / PUC
    additional_qualification  VARCHAR(255)  NULL,                     -- Additional Qualification
    occupation                VARCHAR(150)  NULL,                     -- Occupation
    organization_place        VARCHAR(255)  NULL,                     -- Name of your organization & Place
    mailing_address           TEXT          NOT NULL,                 -- Mailing Address
    contact_number            VARCHAR(20)   NOT NULL,                 -- Contact Number
    email                     VARCHAR(150)  NOT NULL,                 -- Email ID
    additional_info           TEXT          NULL,                     -- Any Additional Information
    signature_name            VARCHAR(150)  NOT NULL,                 -- Signature (typed full name)
    declaration_date          DATE          NOT NULL,                 -- Date (day of registration)
    status                    ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    ip_address                VARCHAR(45)   NULL,
    created_at                TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                TIMESTAMP     NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_alumni_email (email),
    KEY idx_alumni_batch (passing_year_x, passing_year_xii),
    KEY idx_alumni_status (status),
    CONSTRAINT chk_alumni_years CHECK (study_to_year >= study_from_year)
) ENGINE = InnoDB;   -- uses the database's own character set, same as the procedure


-- ---------- 2. Stored procedure: enroll one alumnus ----------
-- Checks the data, refuses a second registration with the same email,
-- saves the row and returns the new id in p_id.
-- Errors are raised as SQLSTATE '45000' with a readable message.

DROP PROCEDURE IF EXISTS sp_enroll_alumni;

DELIMITER $$

CREATE PROCEDURE sp_enroll_alumni (
    IN  p_full_name                VARCHAR(150),
    IN  p_date_of_birth            DATE,
    IN  p_study_from_year          SMALLINT,
    IN  p_study_to_year            SMALLINT,
    IN  p_passing_year_x           SMALLINT,
    IN  p_passing_year_xii         SMALLINT,
    IN  p_additional_qualification VARCHAR(255),
    IN  p_occupation               VARCHAR(150),
    IN  p_organization_place       VARCHAR(255),
    IN  p_mailing_address          TEXT,
    IN  p_contact_number           VARCHAR(20),
    IN  p_email                    VARCHAR(150),
    IN  p_additional_info          TEXT,
    IN  p_signature_name           VARCHAR(150),
    IN  p_ip_address               VARCHAR(45),
    OUT p_id                       BIGINT
)
BEGIN
    DECLARE v_email VARCHAR(150);
    DECLARE v_year  SMALLINT;

    SET v_email = LOWER(TRIM(p_email));
    SET v_year  = YEAR(CURDATE());

    -- required fields
    IF p_full_name IS NULL OR TRIM(p_full_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter your name.';
    END IF;
    IF p_date_of_birth IS NULL OR p_date_of_birth >= CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter a valid date of birth.';
    END IF;
    IF p_mailing_address IS NULL OR TRIM(p_mailing_address) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter your mailing address.';
    END IF;
    IF p_contact_number IS NULL OR TRIM(p_contact_number) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter your contact number.';
    END IF;
    IF v_email IS NULL OR v_email NOT LIKE '%_@_%._%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter a valid email address.';
    END IF;
    IF p_signature_name IS NULL OR TRIM(p_signature_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please type your full name as your signature.';
    END IF;

    -- years (school founded 1959)
    IF p_study_from_year IS NULL OR p_study_to_year IS NULL
       OR p_study_from_year < 1959 OR p_study_to_year > v_year
       OR p_study_to_year < p_study_from_year THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please check your years of study (From must not be after To).';
    END IF;
    IF p_passing_year_x IS NOT NULL AND (p_passing_year_x < 1959 OR p_passing_year_x > v_year) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please check the year of passing for X Class.';
    END IF;
    IF p_passing_year_xii IS NOT NULL AND (p_passing_year_xii < 1959 OR p_passing_year_xii > v_year) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please check the year of passing for XII / PUC.';
    END IF;
    IF YEAR(p_date_of_birth) >= p_study_from_year THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date of birth must be before your years of study.';
    END IF;

    -- one registration per email
    IF EXISTS (SELECT 1 FROM alumni_registrations WHERE email = v_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This email address is already registered with the Alumni Association.';
    END IF;

    INSERT INTO alumni_registrations (
        full_name, date_of_birth, study_from_year, study_to_year,
        passing_year_x, passing_year_xii, additional_qualification,
        occupation, organization_place, mailing_address,
        contact_number, email, additional_info,
        signature_name, declaration_date, ip_address
    ) VALUES (
        TRIM(p_full_name), p_date_of_birth, p_study_from_year, p_study_to_year,
        p_passing_year_x, p_passing_year_xii, NULLIF(TRIM(p_additional_qualification), ''),
        NULLIF(TRIM(p_occupation), ''), NULLIF(TRIM(p_organization_place), ''), TRIM(p_mailing_address),
        TRIM(p_contact_number), v_email, NULLIF(TRIM(p_additional_info), ''),
        TRIM(p_signature_name), CURDATE(), p_ip_address
    );

    SET p_id = LAST_INSERT_ID();
END$$

DELIMITER ;


-- ---------- 3. Handy queries for the office ----------
-- All registrations, newest first:
--   SELECT id, full_name, passing_year_x, passing_year_xii, occupation, contact_number, email, status, created_at
--   FROM alumni_registrations ORDER BY created_at DESC;
--
-- One batch (e.g. X Class of 1998):
--   SELECT full_name, email, contact_number FROM alumni_registrations WHERE passing_year_x = 1998 ORDER BY full_name;
--
-- Approve a registration:
--   UPDATE alumni_registrations SET status = 'APPROVED' WHERE id = 1;
