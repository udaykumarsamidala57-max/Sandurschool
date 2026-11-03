package com.servlet;

import com.bean.DBUtil;
import com.bean.PhotoStore;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Shows a photo from the Railway bucket.
 *   imageStream?id=12            -> section photo (section_images)
 *   imageStream?type=news&id=12  -> news photo (latest_news)
 * MySQL only stores where the photo is (file_key); the picture itself is in the bucket.
 * The browser is sent to a short-lived signed link for the photo.
 */
@WebServlet("/imageStream")
public class ImageStreamServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String type = request.getParameter("type");
        boolean news = "news".equalsIgnoreCase(type);
        boolean event = "event".equalsIgnoreCase(type);

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image ID is required.");
            return;
        }

        long id;
        try {
            id = Long.parseLong(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid image ID format.");
            return;
        }

        String table = news ? "latest_news" : event ? "upcoming_events" : "section_images";
        String blobColumn = news ? null : event ? "image_blob" : "image_data";
        String typeColumn = news || event ? null : "image_type";

        try (Connection conn = DBUtil.getConnection("SRS")) {
            boolean hasKey = PhotoStore.hasColumn(conn, table, "file_key");
            boolean hasBlob = blobColumn != null && PhotoStore.hasColumn(conn, table, blobColumn);
            boolean hasType = typeColumn != null && PhotoStore.hasColumn(conn, table, typeColumn);
            if (news && !hasKey) {
                request.getRequestDispatcher("/newsImageStream?id=" + id).forward(request, response);
                return;
            }

            StringBuilder sql = new StringBuilder("SELECT ");
            if (hasKey) sql.append("file_key"); else sql.append("NULL AS file_key");
            if (hasBlob) sql.append(", ").append(blobColumn);
            if (hasType) sql.append(", ").append(typeColumn);
            sql.append(" FROM ").append(table).append(" WHERE id = ?");

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                ps.setLong(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
                        return;
                    }

                    String key = rs.getString("file_key");
                    if (key != null && !key.trim().isEmpty()) {
                        key = key.trim();
                        if (!PhotoStore.isSrsKey(key)) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
                            return;
                        }
                        if (!PhotoStore.enabled()) {
                            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                                    "Bucket settings are missing on this server.");
                            return;
                        }
                        response.setHeader("Cache-Control", "private, max-age=2400");
                        response.sendRedirect(PhotoStore.url(key));
                        return;
                    }

                    if (news) {
                        request.getRequestDispatcher("/newsImageStream?id=" + id).forward(request, response);
                        return;
                    }
                    if (!hasBlob) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
                        return;
                    }

                    byte[] bytes = rs.getBytes(blobColumn);
                    if (bytes == null || bytes.length == 0) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
                        return;
                    }
                    String contentType = hasType ? rs.getString(typeColumn) : null;
                    contentType = PhotoStore.sniff(bytes, contentType);
                    if (contentType == null || !contentType.matches("(?i)(image|video)/[a-z0-9.+-]+")) {
                        contentType = "application/octet-stream";
                    }
                    response.setContentType(contentType);
                    response.setContentLength(bytes.length);
                    response.setHeader("Cache-Control", "public, max-age=3600");
                    try (OutputStream out = response.getOutputStream()) {
                        out.write(bytes);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not load the image.");
            }
        }
    }
}
