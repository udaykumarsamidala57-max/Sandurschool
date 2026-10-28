package com.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil2 {

    private static final String URL = System.getenv("HR_DB_URL");
    private static final String USER = System.getenv("HR_DB_USER");
    private static final String PASSWORD = System.getenv("HR_DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (isBlank(URL) || isBlank(USER) || isBlank(PASSWORD)) {
            throw new SQLException("Missing required environment variables: HR_DB_URL, HR_DB_USER, and HR_DB_PASSWORD");
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
