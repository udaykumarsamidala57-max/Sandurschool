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
    private static final int BUFFER_SIZE = 8192; // 8KB buffer size for streaming

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
            imageId = Long.parseLong(imageIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Image ID format.");
            return;
        }

        // 2. Query data and image length for accurate Content-Length response header
        String sql = "SELECT image_data, image_type, OCTET_LENGTH(image_data) AS image_size " +
                     "FROM section_images WHERE id = ?";

        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, imageId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    long imageSize = rs.getLong("image_size");

                    if (rs.wasNull() || imageSize <= 0) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image content is empty.");
                        return;
                    }

                    String contentType = rs.getString("image_type");
                    if (contentType == null || contentType.trim().isEmpty()) {
                        contentType = "image/jpeg"; // Standard fallback content-type
                    }

                    try (InputStream inputStream = rs.getBinaryStream("image_data")) {
                        if (inputStream == null) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image content stream unavailable.");
                            return;
                        }

                        // Set headers prior to opening response output stream
                        response.setContentType(contentType);
                        response.setContentLengthLong(imageSize);
                        response.setHeader("Cache-Control", "public, max-age=86400"); // 24 Hours Browser Caching

                        // Stream binary data to client output stream
                        OutputStream outputStream = response.getOutputStream();
                        byte[] buffer = new byte[BUFFER_SIZE];
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