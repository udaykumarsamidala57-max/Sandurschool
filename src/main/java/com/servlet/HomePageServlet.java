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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/homepage")
public class HomePageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // =====================================================
        // 1. GET PAGE SLUG
        // =====================================================

        String pageSlug = request.getParameter("slug");

        if (pageSlug == null || pageSlug.trim().isEmpty()) {
            pageSlug = "home";
        } else {
            pageSlug = pageSlug.trim();
        }


        // =====================================================
        // 2. CREATE BEANS / LISTS
        // =====================================================

        PageBean pageBean = new PageBean();

        List<PageBean> pagesList = new ArrayList<>();

        List<Map<String, Object>> newsList =
                new ArrayList<>();

        List<Map<String, Object>> eventList =
                new ArrayList<>();


        // =====================================================
        // DATABASE CONNECTION
        // =====================================================

        try (Connection conn =
                     DBUtil.getConnection("SRS")) {


            // =================================================
            // 3. LOAD ALL PAGES FOR NAVIGATION
            // =================================================

            String navSql =
                    "SELECT id, title, slug " +
                    "FROM pages " +
                    "ORDER BY title ASC";

            try (PreparedStatement psNav =
                         conn.prepareStatement(navSql);
                 ResultSet rsNav =
                         psNav.executeQuery()) {

                while (rsNav.next()) {

                    PageBean navPage =
                            new PageBean();

                    navPage.setId(
                            rsNav.getLong("id")
                    );

                    navPage.setTitle(
                            rsNav.getString("title")
                    );

                    navPage.setSlug(
                            rsNav.getString("slug")
                    );

                    pagesList.add(navPage);
                }
            }


            // =================================================
            // 4. LOAD SELECTED PAGE
            // =================================================

            String pageSql =
                    "SELECT id, title, slug " +
                    "FROM pages " +
                    "WHERE slug = ?";

            try (PreparedStatement psPage =
                         conn.prepareStatement(pageSql)) {

                psPage.setString(1, pageSlug);

                try (ResultSet rsPage =
                             psPage.executeQuery()) {

                    if (rsPage.next()) {

                        pageBean.setId(
                                rsPage.getLong("id")
                        );

                        pageBean.setTitle(
                                rsPage.getString("title")
                        );

                        pageBean.setSlug(
                                rsPage.getString("slug")
                        );
                    }
                }


                // =================================================
                // FALLBACK TO HOME
                // =================================================

                if (pageBean.getId() == null
                        && !"home".equalsIgnoreCase(pageSlug)) {

                    psPage.setString(1, "home");

                    try (ResultSet rsHome =
                                 psPage.executeQuery()) {

                        if (rsHome.next()) {

                            pageBean.setId(
                                    rsHome.getLong("id")
                            );

                            pageBean.setTitle(
                                    rsHome.getString("title")
                            );

                            pageBean.setSlug(
                                    rsHome.getString("slug")
                            );
                        }
                    }
                }
            }


            // =================================================
            // 5. LOAD SECTIONS + IMAGES
            // =================================================

            if (pageBean.getId() != null) {

                String sectionAndImageSql =

                        "SELECT " +

                        "s.id AS sec_id, " +
                        "s.page_id, " +
                        "s.section_type, " +
                        "s.sequence_order AS sec_seq, " +
                        "s.title AS sec_title, " +
                        "s.content, " +

                        "img.id AS img_id, " +
                        "img.image_type, " +
                        "img.alt_text, " +
                        "img.sequence_order AS img_seq " +

                        "FROM sections s " +

                        "LEFT JOIN section_images img " +
                        "ON s.id = img.section_id " +

                        "WHERE s.page_id = ? " +

                        "ORDER BY " +
                        "s.sequence_order ASC, " +
                        "img.sequence_order ASC";


                Map<Long, Section> sectionMap =
                        new LinkedHashMap<>();


                try (PreparedStatement psSec =
                             conn.prepareStatement(
                                     sectionAndImageSql)) {

                    psSec.setLong(
                            1,
                            pageBean.getId()
                    );


                    try (ResultSet rs =
                                 psSec.executeQuery()) {


                        while (rs.next()) {

                            // =====================================
                            // SECTION ID
                            // =====================================

                            long sectionId =
                                    rs.getLong("sec_id");


                            // =====================================
                            // CHECK WHETHER SECTION ALREADY EXISTS
                            // =====================================

                            Section section =
                                    sectionMap.get(sectionId);


                            // =====================================
                            // CREATE SECTION
                            // =====================================

                            if (section == null) {

                                section =
                                        new Section();


                                section.setId(
                                        sectionId
                                );


                                section.setPageId(
                                        rs.getLong("page_id")
                                );


                                // -----------------------------
                                // SECTION TYPE
                                // -----------------------------

                                String sectionType =
                                        rs.getString(
                                                "section_type"
                                        );

                                if (sectionType != null) {

                                    sectionType =
                                            sectionType
                                                    .trim()
                                                    .toUpperCase();
                                }

                                section.setSectionType(
                                        sectionType
                                );


                                // -----------------------------
                                // SEQUENCE
                                // -----------------------------

                                section.setSequenceOrder(
                                        rs.getInt(
                                                "sec_seq"
                                        )
                                );


                                // -----------------------------
                                // TITLE
                                // -----------------------------

                                section.setTitle(
                                        rs.getString(
                                                "sec_title"
                                        )
                                );


                                // -----------------------------
                                // CONTENT
                                // -----------------------------

                                section.setContent(
                                        rs.getString(
                                                "content"
                                        )
                                );


                                // -----------------------------
                                // STORE SECTION
                                // -----------------------------

                                sectionMap.put(
                                        sectionId,
                                        section
                                );
                            }


                            // =====================================
                            // IMAGE
                            // =====================================

                            long imageId =
                                    rs.getLong("img_id");


                            // LEFT JOIN means image may be NULL

                            if (!rs.wasNull()) {

                                SectionImage image =
                                        new SectionImage();


                                image.setId(
                                        imageId
                                );


                                image.setSectionId(
                                        sectionId
                                );


                                image.setImageType(
                                        rs.getString(
                                                "image_type"
                                        )
                                );


                                image.setAltText(
                                        rs.getString(
                                                "alt_text"
                                        )
                                );


                                image.setSequenceOrder(
                                        rs.getInt(
                                                "img_seq"
                                        )
                                );


                                // Add image to section

                                section.getImages()
                                       .add(image);
                            }
                        }
                    }
                }


                // =============================================
                // PUT SECTIONS INTO PAGE BEAN
                // =============================================

                pageBean.setSections(
                        new ArrayList<>(
                                sectionMap.values()
                        )
                );
            }


            // =================================================
            // 6. LOAD NEWS
            // =================================================

            try {

                String newsSql =
                        "SELECT title, description, image, link " +
                        "FROM news " +
                        "ORDER BY id DESC " +
                        "LIMIT 5";


                try (PreparedStatement psNews =
                             conn.prepareStatement(newsSql);
                     ResultSet rsNews =
                             psNews.executeQuery()) {


                    while (rsNews.next()) {

                        Map<String, Object> news =
                                new HashMap<>();


                        news.put(
                                "title",
                                rsNews.getString("title")
                        );


                        news.put(
                                "description",
                                rsNews.getString("description")
                        );


                        news.put(
                                "image",
                                rsNews.getString("image")
                        );


                        news.put(
                                "link",
                                rsNews.getString("link")
                        );


                        newsList.add(news);
                    }
                }

            } catch (Exception ignored) {

                // News table may not exist
            }


            // =================================================
            // 7. LOAD EVENTS
            // =================================================

            try {

                String eventSql =
                        "SELECT title, description, event_date " +
                        "FROM events " +
                        "ORDER BY event_date ASC " +
                        "LIMIT 5";


                try (PreparedStatement psEv =
                             conn.prepareStatement(eventSql);
                     ResultSet rsEv =
                             psEv.executeQuery()) {


                    while (rsEv.next()) {

                        Map<String, Object> event =
                                new HashMap<>();


                        event.put(
                                "title",
                                rsEv.getString("title")
                        );


                        event.put(
                                "description",
                                rsEv.getString("description")
                        );


                        event.put(
                                "event_date",
                                rsEv.getTimestamp(
                                        "event_date"
                                )
                        );


                        eventList.add(event);
                    }
                }

            } catch (Exception ignored) {

                // Events table may not exist
            }


        } catch (Exception e) {

            e.printStackTrace();

        }


        // =====================================================
        // 8. REQUEST ATTRIBUTES
        // =====================================================

        request.setAttribute(
                "pageData",
                pageBean
        );


        request.setAttribute(
                "pagesList",
                pagesList
        );


        request.setAttribute(
                "newsList",
                newsList
        );


        request.setAttribute(
                "eventList",
                eventList
        );


        // =====================================================
        // 9. FORWARD TO JSP
        // =====================================================

        RequestDispatcher dispatcher =
                request.getRequestDispatcher(
                        "/Home.jsp"
                );


        dispatcher.forward(
                request,
                response
        );
    }
}