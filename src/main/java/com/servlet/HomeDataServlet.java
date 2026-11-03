package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Old address of the home page data. It read latest_news and the old "events" table for ALL websites
 * (no site filter). News and events now come from /homepage, filtered by the site column
 * (latest_news.site, upcoming_events.site), so this address just sends visitors there.
 */
@WebServlet("/HomeDataServlet")
public class HomeDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Object base = request.getAttribute(com.site.SiteConfig.ATTR_SITE_BASE);
        response.sendRedirect((base != null ? base : request.getContextPath()) + "/homepage");
    }
}
