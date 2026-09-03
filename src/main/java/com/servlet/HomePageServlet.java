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
import java.util.Base64;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/homepage")
public class HomePageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageSlug = request.getParameter("slug");
        pageSlug = (pageSlug == null || pageSlug.trim().isEmpty()) ? "home" : pageSlug.trim();

        PageBean pageBean = new PageBean();
        List<PageBean> pagesList = new ArrayList<>();
        List<Map<String, Object>> newsList = new ArrayList<>();
        List<Map<String, Object>> latestNewsList = new ArrayList<>();
        List<Map<String, Object>> eventList = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection("SRS")) {

            if (conn != null) {

                // 1. Navigation Pages
                String navSql = "SELECT id, title, slug, parent_id FROM pages ORDER BY id ASC";
                try (PreparedStatement psNav = conn.prepareStatement(navSql);
                     ResultSet rsNav = psNav.executeQuery()) {

                    Map<Long, PageBean> pageMap = new LinkedHashMap<>();
                    Map<Long, Long> parentChildRelationships = new LinkedHashMap<>();

                    while (rsNav.next()) {
                        long id = rsNav.getLong("id");
                        PageBean page = new PageBean();
                        page.setId(id);
                        page.setTitle(rsNav.getString("title"));
                        page.setSlug(rsNav.getString("slug"));
                        page.setChildren(new ArrayList<>());

                        pageMap.put(id, page);

                        long parentId = rsNav.getLong("parent_id");
                        if (!rsNav.wasNull()) {
                            parentChildRelationships.put(id, parentId);
                        } else {
                            pagesList.add(page);
                        }
                    }

                    for (Map.Entry<Long, Long> entry : parentChildRelationships.entrySet()) {
                        PageBean childBean = pageMap.get(entry.getKey());
                        PageBean parentBean = pageMap.get(entry.getValue());
                        if (parentBean != null && childBean != null) {
                            parentBean.getChildren().add(childBean);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // 2. Selected Page Target
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

                    if (pageBean.getId() == null && !"home".equalsIgnoreCase(pageSlug)) {
                        psPage.setString(1, "home");
                        try (ResultSet rsHome = psPage.executeQuery()) {
                            if (rsHome.next()) {
                                pageBean.setId(rsHome.getLong("id"));
                                pageBean.setTitle(rsHome.getString("title"));
                                pageBean.setSlug(rsHome.getString("slug"));
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // 3. Sections & Images Mapping
                if (pageBean.getId() != null) {
                    String sectionAndImageSql =
                            "SELECT s.id AS sec_id, s.page_id, s.section_type, s.sequence_order AS sec_seq, " +
                            "s.title AS sec_title, s.content, img.id AS img_id, img.image_type, " +
                            "img.alt_text, img.sequence_order AS img_seq, img.Heading1 AS img_h1, img.Heading2 AS img_h2 " +
                            "FROM sections s LEFT JOIN section_images img ON s.id = img.section_id " +
                            "WHERE s.page_id = ? ORDER BY s.sequence_order ASC, img.sequence_order ASC";

                    Map<Long, Section> sectionMap = new LinkedHashMap<>();

                    try (PreparedStatement psSec = conn.prepareStatement(sectionAndImageSql)) {
                        psSec.setLong(1, pageBean.getId());

                        try (ResultSet rs = psSec.executeQuery()) {
                            while (rs.next()) {
                                long sectionId = rs.getLong("sec_id");
                                Section section = sectionMap.get(sectionId);

                                if (section == null) {
                                    section = new Section();
                                    section.setId(sectionId);
                                    section.setPageId(rs.getLong("page_id"));

                                    String sectionType = rs.getString("section_type");
                                    if (sectionType != null) {
                                        sectionType = sectionType.trim().toUpperCase();
                                    }

                                    section.setSectionType(sectionType);
                                    section.setSequenceOrder(rs.getInt("sec_seq"));
                                    section.setTitle(rs.getString("sec_title"));
                                    section.setContent(rs.getString("content"));
                                    section.setImages(new ArrayList<>());

                                    sectionMap.put(sectionId, section);
                                }

                                long imageId = rs.getLong("img_id");
                                boolean isImageNull = rs.wasNull();

                                if (!isImageNull && imageId > 0) {
                                    SectionImage image = new SectionImage();
                                    image.setId(imageId);
                                    image.setSectionId(sectionId);
                                    image.setImageType(rs.getString("image_type"));
                                    image.setAltText(rs.getString("alt_text"));
                                    image.setSequenceOrder(rs.getInt("img_seq"));
                                    image.setHeading1(rs.getString("img_h1"));
                                    image.setHeading2(rs.getString("img_h2"));

                                    section.getImages().add(image);
                                }
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    pageBean.setSections(new ArrayList<>(sectionMap.values()));
                }

                // 4. Latest News (Updated for LONGBLOB)
                String latestNewsSql = "SELECT id, event_name, description, image, created_at " +
                                       "FROM latest_news ORDER BY created_at DESC LIMIT 5";

                try (PreparedStatement psLatestNews = conn.prepareStatement(latestNewsSql);
                     ResultSet rsLatestNews = psLatestNews.executeQuery()) {

                    while (rsLatestNews.next()) {
                        Map<String, Object> news = new HashMap<>();
                        news.put("id", rsLatestNews.getInt("id"));
                        news.put("event_name", rsLatestNews.getString("event_name"));
                        news.put("title", rsLatestNews.getString("event_name"));
                        news.put("description", rsLatestNews.getString("description"));

                        // Read binary stream and encode to Base64
                        byte[] imgBytes = rsLatestNews.getBytes("image");
                        if (imgBytes != null && imgBytes.length > 0) {
                            String base64Image = Base64.getEncoder().encodeToString(imgBytes);
                            news.put("image", "data:image/jpeg;base64," + base64Image);
                        } else {
                            news.put("image", null);
                        }

                        news.put("created_at", rsLatestNews.getTimestamp("created_at"));

                        latestNewsList.add(news);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                if (!latestNewsList.isEmpty()) {
                    newsList.addAll(latestNewsList);
                }

                // 5. Events
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
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("pageData", pageBean);
        request.setAttribute("pagesList", pagesList);
        request.setAttribute("newsList", newsList);
        request.setAttribute("latestNewsList", latestNewsList);
        request.setAttribute("eventList", eventList);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/Home.jsp");
        dispatcher.forward(request, response);
    }
}