package com.servlet;

import com.bean.DBUtil;
import com.bean.PageBean;
import com.bean.PageBean.Section;
import com.bean.PageBean.SectionImage;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/homepage")
public class HomePageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 1. Get dynamic page slug from request parameter (e.g., /homepage?slug=about-us)
        String pageSlug = request.getParameter("slug");
        
        // Fallback to "home" if no slug parameter is passed
        if (pageSlug == null || pageSlug.trim().isEmpty()) {
            pageSlug = "home";
        }

        PageBean pageBean = new PageBean();
        List<PageBean> pagesList = new ArrayList<>();
        List<Map<String, Object>> newsList = new ArrayList<>();
        List<Map<String, Object>> eventList = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection("SRS")) {
            
            // 2. Fetch Navigation Header Pages (Populates pagesList for header navigation)
            String navSql = "SELECT id, title, slug FROM pages ORDER BY title ASC";
            try (PreparedStatement psNav = conn.prepareStatement(navSql);
                 ResultSet rsNav = psNav.executeQuery()) {
                while (rsNav.next()) {
                    PageBean navPage = new PageBean();
                    navPage.setId(rsNav.getLong("id"));
                    navPage.setTitle(rsNav.getString("title"));
                    navPage.setSlug(rsNav.getString("slug"));
                    pagesList.add(navPage);
                }
            }

            // 3. Fetch Selected Dynamic Page Data
            String pageSql = "SELECT id, title, slug FROM pages WHERE slug = ?";
            try (PreparedStatement psPage = conn.prepareStatement(pageSql)) {
                psPage.setString(1, pageSlug);
                try (ResultSet rsPage = psPage.executeQuery()) {
                    if (rsPage.next()) {
                        pageBean.setId(rsPage.getLong("id"));
                        pageBean.setTitle(rsPage.getString("title"));
                        pageBean.setSlug(rsPage.getString("slug"));
                    }
                }
            }

            // 4. Fetch Sections for the Selected Page
            if (pageBean.getId() != null) {
                String sectionSql = "SELECT id, page_id, section_type, sequence_order, title, content " +
                                    "FROM sections WHERE page_id = ? ORDER BY sequence_order ASC";
                
                try (PreparedStatement psSec = conn.prepareStatement(sectionSql)) {
                    psSec.setLong(1, pageBean.getId());
                    try (ResultSet rsSec = psSec.executeQuery()) {
                        while (rsSec.next()) {
                            Section section = new Section();
                            section.setId(rsSec.getLong("id"));
                            section.setPageId(rsSec.getLong("page_id"));
                            section.setSectionType(rsSec.getString("section_type"));
                            section.setSequenceOrder(rsSec.getInt("sequence_order"));
                            section.setTitle(rsSec.getString("title"));
                            section.setContent(rsSec.getString("content"));
                            
                            // 5. Fetch Image metadata for Section
                            String imgSql = "SELECT id, section_id, image_type, alt_text, sequence_order " +
                                            "FROM section_images WHERE section_id = ? ORDER BY sequence_order ASC";
                            try (PreparedStatement psImg = conn.prepareStatement(imgSql)) {
                                psImg.setLong(1, section.getId());
                                try (ResultSet rsImg = psImg.executeQuery()) {
                                    while (rsImg.next()) {
                                        SectionImage img = new SectionImage();
                                        img.setId(rsImg.getLong("id"));
                                        img.setSectionId(rsImg.getLong("section_id"));
                                        img.setImageType(rsImg.getString("image_type"));
                                        img.setAltText(rsImg.getString("alt_text"));
                                        img.setSequenceOrder(rsImg.getInt("sequence_order"));
                                        
                                        section.getImages().add(img);
                                    }
                                }
                            }
                            pageBean.getSections().add(section);
                        }
                    }
                }
            }

            // 6. Fetch News Items
            try {
                String newsSql = "SELECT title, description, image, link FROM news ORDER BY id DESC LIMIT 5";
                try (PreparedStatement psNews = conn.prepareStatement(newsSql);
                     ResultSet rsNews = psNews.executeQuery()) {
                    while (rsNews.next()) {
                        Map<String, Object> news = new HashMap<>();
                        news.put("title", rsNews.getString("title"));
                        news.put("description", rsNews.getString("description"));
                        news.put("image", rsNews.getString("image"));
                        news.put("link", rsNews.getString("link"));
                        newsList.add(news);
                    }
                }
            } catch (Exception ignored) {}

            // 7. Fetch Events Items
            try {
                String eventSql = "SELECT title, description, event_date FROM events ORDER BY event_date ASC LIMIT 5";
                try (PreparedStatement psEv = conn.prepareStatement(eventSql);
                     ResultSet rsEv = psEv.executeQuery()) {
                    while (rsEv.next()) {
                        Map<String, Object> event = new HashMap<>();
                        event.put("title", rsEv.getString("title"));
                        event.put("description", rsEv.getString("description"));
                        event.put("event_date", rsEv.getTimestamp("event_date"));
                        eventList.add(event);
                    }
                }
            } catch (Exception ignored) {}

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set request attributes for JSP rendering
        request.setAttribute("pageData", pageBean);
        request.setAttribute("pagesList", pagesList); // Navigation menu list
        request.setAttribute("newsList", newsList);
        request.setAttribute("eventList", eventList);

        // Forward to Home.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/Home.jsp");
        dispatcher.forward(request, response);
    }
}