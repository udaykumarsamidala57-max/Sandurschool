package com.servlet;

import com.bean.DBUtil;
import com.bean.PhotoStore;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/imageStream")
public class ImageStreamServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int BUFFER_SIZE = 8192;

    /** while the file_key column does not exist yet (before the move), skip the bucket check; re-check every 10 minutes */
    private static volatile long skipKeyUntil = 0;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String imageIdParam = request.getParameter("id");
        String type = request.getParameter("type");

        if (imageIdParam == null || imageIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image ID is required.");
            return;
        }

        long imageId;
        try {
            imageId = Long.parseLong(imageIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid image ID format.");
            return;
        }

        boolean news = "news".equalsIgnoreCase(type);

        try (Connection conn = DBUtil.getConnection("SRS")) {

            // 1) photo already moved to the bucket? send the browser there
            if (PhotoStore.enabled() && System.currentTimeMillis() > skipKeyUntil) {
                String key = null;
                try (PreparedStatement kp = conn.prepareStatement(news
                        ? "SELECT file_key FROM latest_news WHERE id = ?"
                        : "SELECT file_key FROM section_images WHERE id = ?")) {
                    kp.setLong(1, imageId);
                    try (ResultSet kr = kp.executeQuery()) {
                        if (kr.next()) key = kr.getString(1);
                    }
                } catch (SQLException noColumnYet) {
                    skipKeyUntil = System.currentTimeMillis() + 10L * 60L * 1000L;
                }
                if (key != null && !key.trim().isEmpty()) {
                    response.setHeader("Cache-Control", "private, max-age=2400");
                    response.sendRedirect(PhotoStore.url(key.trim()));
                    return;
                }
            }

            // 2) otherwise read it from MySQL as before
            // Standardized 'img_blob' alias to prevent ResultSet column reading mismatch
            String sql;
            if (news) {
                sql = "SELECT image AS img_blob, 'image/jpeg' AS image_type, OCTET_LENGTH(image) AS image_size " +
                      "FROM latest_news WHERE id = ?";
            } else {
                sql = "SELECT image_data AS img_blob, image_type, OCTET_LENGTH(image_data) AS image_size " +
                      "FROM section_images WHERE id = ?";
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, imageId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
                    return;
                }

                long imageSize = rs.getLong("image_size");
                if (rs.wasNull() || imageSize <= 0) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image BLOB content is empty.");
                    return;
                }

                String contentType = rs.getString("image_type");
                if (contentType == null || contentType.trim().isEmpty()) {
                    contentType = "image/jpeg";
                } else {
                    contentType = contentType.trim();
                }

                try (InputStream inputStream = rs.getBinaryStream("img_blob")) {
                    if (inputStream == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image binary stream null.");
                        return;
                    }

                    if (!response.isCommitted()) {
                        response.reset();
                        response.setContentType(contentType);
                        response.setContentLengthLong(imageSize);
                        response.setHeader("Cache-Control", "public, max-age=86400");
                        response.setHeader("Pragma", "cache");
                        response.setDateHeader("Expires", System.currentTimeMillis() + 86400000L);
                    }

                    try (OutputStream outputStream = response.getOutputStream()) {
                        byte[] buffer = new byte[BUFFER_SIZE];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }
                        outputStream.flush();
                    }
                }
            }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error streaming image data.");
            }
        }
    }
}