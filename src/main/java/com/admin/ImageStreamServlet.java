package com.admin;

import com.bean.DBUtil;
import com.bean.PhotoStore;
import com.bean.PhotoUpload;
import com.site.SiteScope;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/admin/imageStream")
public class ImageStreamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Session Check
        HttpSession sess = request.getSession(false);
        if (sess == null || sess.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) sess.getAttribute("role");
        String branch = (String) sess.getAttribute("branch");

        // 2. Authorization Check
        if (!isAuthorized(role)) {
            response.setContentType("text/html");
            response.getWriter().println("<h3 style='color:red;'>Access Denied</h3>");
            return;
        }
        
        // 3. Parameter Validation
        String imageIdParam = request.getParameter("id");
        if (imageIdParam == null || imageIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image ID parameter is missing.");
            return;
        }

        long imageId;
        try {
            imageId = Long.parseLong(imageIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Image ID format.");
            return;
        }

        // 4. Database Query & Binary Streaming
        String sql = "SELECT image_data, image_type FROM section_images WHERE id = ?";

        try (Connection conn = DBUtil.getConnection(branch);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (!SiteScope.imageInSite(conn, imageId, SiteScope.siteOf(branch))) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
                return;
            }

            // photo kept in the bucket: send the browser to its link
            String bucketKey = PhotoUpload.keyOf(conn, "section_images", imageId);
            if (bucketKey != null && PhotoStore.enabled()) {
                response.setHeader("Cache-Control", "private, max-age=2400");
                response.sendRedirect(PhotoStore.url(bucketKey));
                return;
            }

            stmt.setLong(1, imageId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String contentType = rs.getString("image_type");
                    if (contentType == null || contentType.trim().isEmpty()) {
                        contentType = "image/jpeg";
                    }

                    try (InputStream inputStream = rs.getBinaryStream("image_data")) {
                        if (inputStream == null) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image BLOB is empty.");
                            return;
                        }

                        // Set headers before writing to the stream
                        response.setContentType(contentType);
                        response.setHeader("Cache-Control", "public, max-age=86400"); // 24 hours caching

                        OutputStream outputStream = response.getOutputStream();
                        byte[] buffer = new byte[8192];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }
                        outputStream.flush();
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving image.");
            }
        }
    }

    // 5. Authorization Helper Method
    private boolean isAuthorized(String role) {
        if (role == null) {
            return false;
        }
        // Customize allowed roles based on your application's access control rules
        return role.equalsIgnoreCase("ADMIN") || role.equalsIgnoreCase("USER");
    }
}
