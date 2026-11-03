package com.servlet;

import com.bean.DBUtil;
import com.bean.PageBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/navigation")
public class NavigationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // =====================================================
        // FINAL ROOT NAVIGATION LIST
        // Maintains database ID order
        // =====================================================
        List<PageBean> rootPages = new ArrayList<>();

        // =====================================================
        // ALL PAGES
        // Key   = Page ID
        // Value = PageBean
        //
        // LinkedHashMap preserves database ID insertion order.
        // =====================================================
        Map<Long, PageBean> pageMap = new LinkedHashMap<>();

        // =====================================================
        // CHILD -> PARENT RELATIONSHIP
        //
        // Key   = Child ID
        // Value = Parent ID
        //
        // LinkedHashMap preserves child database ID order.
        // =====================================================
        Map<Long, Long> parentChildRelationships =
                new LinkedHashMap<>();

        /*
         * =====================================================
         * FETCH ALL PAGES
         *
         * IMPORTANT:
         * ORDER BY id ASC means:
         *
         * 1, 2, 3, 4, 5, 6...
         *
         * This determines the navigation sequence.
         * =====================================================
         */
        String query =
                "SELECT id, title, slug, parent_id " +
                "FROM pages " +
                "ORDER BY id ASC";

        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            /*
             * =================================================
             * PASS 1
             *
             * Create every PageBean first.
             *
             * At the same time:
             * - Store all pages in pageMap
             * - Store root pages in rootPages
             * - Store child-parent relationships
             * =================================================
             */
            while (rs.next()) {

                long pageId = rs.getLong("id");

                PageBean page = new PageBean();

                page.setId(pageId);
                page.setTitle(rs.getString("title"));
                page.setSlug(rs.getString("slug"));

                // Every page gets its own children list
                page.setChildren(new ArrayList<>());

                // Store page using its ID
                pageMap.put(pageId, page);

                /*
                 * Check parent_id
                 */
                long parentId = rs.getLong("parent_id");

                if (rs.wasNull()) {

                    /*
                     * This is a ROOT / TOP-LEVEL page.
                     *
                     * Because the SQL is ORDER BY id ASC,
                     * rootPages will also remain in ID order.
                     */
                    rootPages.add(page);

                } else {

                    /*
                     * This is a child page.
                     *
                     * Store:
                     *
                     * child ID -> parent ID
                     */
                    parentChildRelationships.put(
                            pageId,
                            parentId
                    );
                }
            }

            /*
             * =================================================
             * PASS 2
             *
             * Attach every child to its parent.
             *
             * parentChildRelationships is a LinkedHashMap,
             * so children are processed in database ID order.
             * =================================================
             */
            for (Map.Entry<Long, Long> entry
                    : parentChildRelationships.entrySet()) {

                Long childId = entry.getKey();
                Long parentId = entry.getValue();

                PageBean childBean = pageMap.get(childId);
                PageBean parentBean = pageMap.get(parentId);

                if (parentBean != null && childBean != null) {

                    /*
                     * Add child to parent's ArrayList.
                     *
                     * Therefore children also follow
                     * database ID order.
                     */
                    parentBean.getChildren().add(childBean);
                }
            }

        } catch (SQLException e) {

            System.err.println(
                    "Database error while fetching navigation pages:"
            );

            e.printStackTrace();

        } catch (Exception e) {

            e.printStackTrace();
        }

        /*
         * =====================================================
         * SEND NAVIGATION TO JSP
         * =====================================================
         */
        request.setAttribute("pagesList", rootPages);

        /*
         * Forward to index.jsp
         */
        request.getRequestDispatcher("/index.jsp")
               .forward(request, response);
    }
}