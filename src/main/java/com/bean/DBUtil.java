package com.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static final String USER = "root";
    private static final String PASSWORD = "aGqMEJvhAhoDWKXRPxxdYJXMNlbFmhBr"; // Add your Railway DB password here if required

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection(String branch) throws SQLException {
        String url;

        if ("SRS".equalsIgnoreCase(branch)) {
            url = "jdbc:mysql://altaria.proxy.rlwy.net:54307/website"
                    + "?useSSL=false"
                    + "&allowPublicKeyRetrieval=true"
                    + "&serverTimezone=UTC"
                    + "&tcpKeepAlive=true";
        } else {
            throw new SQLException("Invalid Branch: " + branch);
        }

        return DriverManager.getConnection(url, USER, PASSWORD);
    }
}