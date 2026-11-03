package com.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static final String URL = System.getenv("SRS_DB_URL");
    private static final String USER = System.getenv("SRS_DB_USER");
    private static final String PASSWORD = System.getenv("SRS_DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection(String branch) throws SQLException {
        if (!"SRS".equalsIgnoreCase(branch)) {
            throw new SQLException("Invalid Branch: " + branch);
        }

        if (isBlank(URL) || isBlank(USER) || isBlank(PASSWORD)) {
            throw new SQLException("Missing required environment variables: SRS_DB_URL, SRS_DB_USER, and SRS_DB_PASSWORD");
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
