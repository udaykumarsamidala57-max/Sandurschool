package com.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Locale;

import com.site.Site;
import com.site.SiteConfig;

/**
 * Opens a connection to a site's database.
 * Credentials come only from environment variables, named by the site's db key,
 * e.g. SRS -> SRS_DB_URL, SRS_DB_USER, SRS_DB_PASSWORD.
 * All websites currently share the SRS database (sites.properties: <site>.db=SRS)
 * and are kept apart by the "site" column.
 * The db key must belong to a site listed in WEB-INF/sites.properties.
 */
public class DBUtil {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    /** @param branch db key or admin branch name, e.g. "SRS", "Sanpoly" (case-insensitive) */
    public static Connection getConnection(String branch) throws SQLException {
        if (branch == null || branch.trim().isEmpty()) {
            throw new SQLException("No branch/site given");
        }
        // A site key or admin branch ("srs", "Sanpoly") maps to that site's database;
        // a database key ("SRS") is also accepted.
        Site site = SiteConfig.resolve(branch);
        String key = site != null ? site.getDbKey() : branch.trim().toUpperCase(Locale.ROOT);
        if (!key.matches("[A-Z0-9_]+") || !SiteConfig.isKnownDbKey(key)) {
            throw new SQLException("Invalid Branch: " + branch);
        }

        String url = System.getenv(key + "_DB_URL");
        String user = System.getenv(key + "_DB_USER");
        String password = System.getenv(key + "_DB_PASSWORD");

        if (isBlank(url) || isBlank(user) || isBlank(password)) {
            throw new SQLException("Missing required environment variables: "
                    + key + "_DB_URL, " + key + "_DB_USER and " + key + "_DB_PASSWORD");
        }
        return DriverManager.getConnection(url, user, password);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
