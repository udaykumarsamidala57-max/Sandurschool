package com.servlet;

import com.bean.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/navigation")
public class NavigationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, String>> pageList = new ArrayList<>();
        String query = "SELECT id, title, slug FROM pages ORDER BY title ASC";

        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, String> page = new HashMap<>();
                page.put("id", String.valueOf(rs.getLong("id")));
                page.put("title", rs.getString("title"));
                page.put("slug", rs.getString("slug"));
                pageList.add(page);
            }

        } catch (SQLException e) {
            System.err.println("Database error while fetching navigation pages:");
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set the list attribute for JSP consumption
        request.setAttribute("pagesList", pageList);

        // Forward to your main target page
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}