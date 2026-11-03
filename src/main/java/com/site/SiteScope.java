package com.site;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

/**
 * All websites share one database. Every page, news item and event row has a
 * {@code site} column ('srs', 'sanpoly', ...). Sections and photos belong to a
 * site through their page. These checks stop one site's admin from reading or
 * changing another site's rows by changing an id in the URL.
 */
public final class SiteScope {

    private SiteScope() { }

    /** Site key ('srs', 'sanpoly') for an admin user's branch, or null if unknown. */
    public static String siteOf(String branch) {
        Site s = SiteConfig.resolve(branch);
        return s == null ? null : s.getKey();
    }

    public static boolean pageInSite(Connection conn, long pageId, String site) throws SQLException {
        return exists(conn, "SELECT 1 FROM pages WHERE id = ? AND site = ?", pageId, site);
    }

    public static boolean sectionInSite(Connection conn, long sectionId, String site) throws SQLException {
        return exists(conn,
                "SELECT 1 FROM sections s JOIN pages p ON p.id = s.page_id WHERE s.id = ? AND p.site = ?",
                sectionId, site);
    }

    public static boolean imageInSite(Connection conn, long imageId, String site) throws SQLException {
        return exists(conn,
                "SELECT 1 FROM section_images i JOIN sections s ON s.id = i.section_id "
              + "JOIN pages p ON p.id = s.page_id WHERE i.id = ? AND p.site = ?",
                imageId, site);
    }

    public static boolean rowInSite(Connection conn, String table, long id, String site) throws SQLException {
        if (!"latest_news".equals(table) && !"upcoming_events".equals(table)) {
            throw new IllegalArgumentException("Unsupported table");
        }
        return exists(conn, "SELECT 1 FROM " + table + " WHERE id = ? AND site = ?", id, site);
    }

    /**
     * Checks every id parameter the page builder uses: id / pageId / parentId (pages),
     * sectionId (sections), imageId (photos). Missing or blank parameters are ignored;
     * a value that is not a number, or belongs to another site, fails the check.
     */
    public static boolean pageBuilderParamsAllowed(Connection conn, HttpServletRequest req, String site)
            throws SQLException {
        if (site == null) return false;
        for (String p : new String[] {"id", "pageId", "parentId"}) {
            Long v = idParam(req, p);
            if (v == null) { if (blank(req.getParameter(p))) continue; return false; }
            if (!pageInSite(conn, v, site)) return false;
        }
        Long sec = idParam(req, "sectionId");
        if (sec == null) { if (!blank(req.getParameter("sectionId"))) return false; }
        else if (!sectionInSite(conn, sec, site)) return false;

        Long img = idParam(req, "imageId");
        if (img == null) { if (!blank(req.getParameter("imageId"))) return false; }
        else if (!imageInSite(conn, img, site)) return false;
        return true;
    }

    private static Long idParam(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        if (blank(v)) return null;
        try {
            return Long.parseLong(v.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static boolean blank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static boolean exists(Connection conn, String sql, long id, String site) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.setString(2, site);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
