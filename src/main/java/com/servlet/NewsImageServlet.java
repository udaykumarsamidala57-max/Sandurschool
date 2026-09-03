package com.servlet;

import com.bean.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;

@WebServlet("/newsImageStream")
public class NewsImageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String newsIdParam = request.getParameter("id");
        if (newsIdParam == null || newsIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing news ID");
            return;
        }

        String sql = "SELECT image FROM latest_news WHERE id = ?";

        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(newsIdParam.trim()));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    
                    // 1. TRY AS BLOB FIRST
                    Blob blob = null;
                    try {
                        blob = rs.getBlob("image");
                    } catch (Exception e) {
                        // Not a blob, fallback to String
                    }

                    if (blob != null && blob.length() > 0) {
                        response.setContentType("image/jpeg");
                        response.setContentLengthLong(blob.length());
                        try (InputStream in = blob.getBinaryStream();
                             OutputStream out = response.getOutputStream()) {
                            byte[] buffer = new byte[8192];
                            int bytesRead;
                            while ((bytesRead = in.read(buffer)) != -1) {
                                out.write(buffer, 0, bytesRead);
                            }
                            out.flush();
                        }
                        return;
                    }

                    // 2. TRY AS STRING (PATH OR BASE64)
                    String rawImage = rs.getString("image");
                    if (rawImage == null || rawImage.trim().isEmpty()) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found in DB.");
                        return;
                    }

                    rawImage = rawImage.trim();

                    // If string is Base64 formatted
                    if (rawImage.startsWith("data:image")) {
                        String base64Data = rawImage.substring(rawImage.indexOf(",") + 1);
                        byte[] imageBytes = Base64.getDecoder().decode(base64Data);
                        response.setContentType("image/jpeg");
                        response.setContentLength(imageBytes.length);
                        response.getOutputStream().write(imageBytes);
                        return;
                    }

                    // Clean path leading slashes
                    String cleanPath = rawImage.startsWith("/") ? rawImage.substring(1) : rawImage;

                    // Try web application real path
                    String realPath = getServletContext().getRealPath("/" + cleanPath);
                    File file = null;
                    
                    if (realPath != null) {
                        file = new File(realPath);
                    }

                    if (file == null || !file.exists()) {
                        file = new File(rawImage); // Try direct file path
                    }

                    if (file.exists() && file.isFile()) {
                        String mimeType = getServletContext().getMimeType(file.getName());
                        response.setContentType(mimeType != null ? mimeType : "image/jpeg");
                        response.setContentLengthLong(file.length());

                        try (FileInputStream in = new FileInputStream(file);
                             OutputStream out = response.getOutputStream()) {
                            byte[] buffer = new byte[8192];
                            int bytesRead;
                            while ((bytesRead = in.read(buffer)) != -1) {
                                out.write(buffer, 0, bytesRead);
                            }
                            out.flush();
                        }
                    } else {
                        System.err.println("NewsImageServlet: File not found at path -> " + rawImage);
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on disk");
                    }

                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "News record not found.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error rendering image.");
        }
    }
}