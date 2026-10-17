package com.servlet;

import com.bean.DBUtil;
import com.bean.PhotoStore;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
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
        boolean news = "news".equalsIgnoreCase(request.getParameter("type"));

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

        if (!PhotoStore.enabled()) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                    "Bucket settings are missing on this server (BUCKET, ACCESS_KEY_ID, SECRET_ACCESS_KEY, ENDPOINT, REGION).");
            return;
        }

        String sql = news
                ? "SELECT file_key FROM latest_news WHERE id = ?"
                : "SELECT file_key FROM section_images WHERE id = ?";

        String key = null;
        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found.");
                    return;
                }
                key = rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Could not read the photo's location: " + e.getMessage());
            return;
        }

        if (key == null || key.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "This photo is not in the bucket yet. Run /admin/move-photos in the admin.");
            return;
        }

        response.setHeader("Cache-Control", "private, max-age=2400");
        response.sendRedirect(PhotoStore.url(key.trim()));
    }
}
