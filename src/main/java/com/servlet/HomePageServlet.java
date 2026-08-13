package com.servlet;

import com.bean.PageBean;
import com.bean.PageBean.Section;
import com.bean.PageBean.SectionImage;
import com.bean.DBUtil;

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
        PageBean pageBean = new PageBean();
        String pageSlug = "home";

        List<Map<String, Object>> newsList = new ArrayList<>();
        List<Map<String, Object>> eventList = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection("SRS")) {
            
            // 1. Fetch Page Data
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

            // 2. Fetch Sections for the Page
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
                            
                            // 3. Fetch Image metadata for Section
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

            // 4. Fetch News (Fallback safe fetch)
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
            } catch (Exception e) {
                // Ignore if table does not exist yet
            }

            // 5. Fetch Events (Fallback safe fetch)
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
            } catch (Exception e) {
                // Ignore if table does not exist yet
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Pass attributes to JSP
        request.setAttribute("pageData", pageBean);
        request.setAttribute("newsList", newsList);
        request.setAttribute("eventList", eventList);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/Home.jsp");
        dispatcher.forward(request, response);
    }
}