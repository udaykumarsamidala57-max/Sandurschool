package com.servlet;

import com.bean.DBUtil;
import com.bean.PageBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/navigation")
public class NavigationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        List<PageBean> pagesList = new ArrayList<>();

        // Fetch parent pages and their child pages ordered logically
        String query = 
            "SELECT " +
            "  p.id AS parent_id, p.title AS parent_title, p.slug AS parent_slug, " +
            "  c.id AS child_id, c.title AS child_title, c.slug AS child_slug " +
            "FROM pages p " +
            "LEFT JOIN pages c ON c.parent_id = p.id " +
            "WHERE p.parent_id IS NULL " +
            "ORDER BY p.title ASC, c.title ASC";

        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            Map<Long, PageBean> parentMap = new LinkedHashMap<>();

            while (rs.next()) {
                long parentId = rs.getLong("parent_id");
                PageBean parentPage = parentMap.get(parentId);

                if (parentPage == null) {
                    parentPage = new PageBean();
                    parentPage.setId(parentId);
                    parentPage.setTitle(rs.getString("parent_title"));
                    parentPage.setSlug(rs.getString("parent_slug"));
                    parentPage.setChildren(new ArrayList<>());
                    parentMap.put(parentId, parentPage);
                }

                // Attach child page if present
                long childId = rs.getLong("child_id");
                if (!rs.wasNull()) {
                    PageBean childPage = new PageBean();
                    childPage.setId(childId);
                    childPage.setTitle(rs.getString("child_title"));
                    childPage.setSlug(rs.getString("child_slug"));
                    
                    parentPage.getChildren().add(childPage);
                }
            }

            pagesList.addAll(parentMap.values());

        } catch (SQLException e) {
            System.err.println("Database error while fetching navigation pages:");
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set the structured list attribute for JSP consumption
        request.setAttribute("pagesList", pagesList);

        // Forward to target page
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}