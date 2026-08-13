package com.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.bean.DBUtil;

@WebServlet("/HomeDataServlet")
public class HomeDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Session Check (Fixed variable names from req/resp -> request/response)
        HttpSession sess = request.getSession(false);
        if (sess == null || sess.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String branch = (String) sess.getAttribute("branch");
        String role = (String) sess.getAttribute("role");

        // 2. Authorization Check
        if (!isAuthorized(role)) {
            response.setContentType("text/html");
            response.getWriter().println("<h3 style='color:red;'>Access Denied</h3>");
            return;
        }

        List<Map<String, Object>> newsList = new ArrayList<>();
        List<Map<String, Object>> eventList = new ArrayList<>();

        String sqlNews = "SELECT id, title, description, image, link, created_at FROM latest_news ORDER BY created_at DESC LIMIT 5";
        String sqlEvents = "SELECT id, event_date, title, description, icon, created_at FROM events ORDER BY event_date DESC LIMIT 5";

        // 3. Modern Try-With-Resources (Automatically handles closing con, ps, and rs)
        try (Connection con = DBUtil.getConnection(branch)) {

            // ---- Fetch latest_news ----
            try (PreparedStatement psNews = con.prepareStatement(sqlNews);
                 ResultSet rsNews = psNews.executeQuery()) {

                while (rsNews.next()) {
                    Map<String, Object> news = new HashMap<>();
                    news.put("id", rsNews.getInt("id"));
                    news.put("title", rsNews.getString("title"));
                    news.put("description", rsNews.getString("description"));
                    news.put("image", rsNews.getString("image"));
                    news.put("link", rsNews.getString("link"));
                    news.put("created_at", rsNews.getTimestamp("created_at"));
                    newsList.add(news);
                }
            }

            // ---- Fetch events ----
            try (PreparedStatement psEvents = con.prepareStatement(sqlEvents);
                 ResultSet rsEvents = psEvents.executeQuery()) {

                while (rsEvents.next()) {
                    Map<String, Object> event = new HashMap<>();
                    event.put("id", rsEvents.getInt("id"));
                    event.put("event_date", rsEvents.getDate("event_date"));
                    event.put("title", rsEvents.getString("title"));
                    event.put("description", rsEvents.getString("description"));
                    event.put("icon", rsEvents.getString("icon"));
                    event.put("created_at", rsEvents.getTimestamp("created_at"));
                    eventList.add(event);
                }
            }

            // Set attributes and forward
            request.setAttribute("newsList", newsList);
            request.setAttribute("eventList", eventList);

            RequestDispatcher rd = request.getRequestDispatcher("Home.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error loading home page data: " + e.getMessage());
        }
    }

    // 4. Added missing authorization helper method
    private boolean isAuthorized(String role) {
        if (role == null) return false;
        // Adjust authorized roles to fit your application's logic
        return role.equalsIgnoreCase("ADMIN") || role.equalsIgnoreCase("USER");
    }
}