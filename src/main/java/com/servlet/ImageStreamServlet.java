package com.servlet;

import com.bean.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/imageStream")
public class ImageStreamServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Parameter Validation
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

        // 2. Database Query & Binary Streaming (Public Access)
        String sql = "SELECT image_data, image_type FROM section_images WHERE id = ?";

        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, imageId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String contentType = rs.getString("image_type");
                    if (contentType == null || contentType.trim().isEmpty()) {
                        contentType = "image/jpeg";
                    }

                    try (InputStream inputStream = rs.getBinaryStream("image_data")) {
                        if (inputStream == null) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image content is empty.");
                            return;
                        }

                        // Set headers before writing to stream
                        response.setContentType(contentType);
                        response.setHeader("Cache-Control", "public, max-age=86400"); // 24 hours browser caching

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
}