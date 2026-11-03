package com.site;

import java.io.IOException;
import java.util.Locale;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Routes public URLs by site prefix:
 *   /srs/homepage      -> /homepage with the SRS site (SRS database)
 *   /sanpoly/homepage  -> /homepage with the Sanpoly site (SANPOLY database)
 *   /                  -> redirect to the default site
 *   /admin/...         -> switched off: website content is managed in PInventory
 * Old unprefixed URLs (/homepage, /imageStream ...) still work and use the default site.
 */
@WebFilter(urlPatterns = "/*")
public class SiteFilter implements Filter {

    @Override
    public void init(FilterConfig cfg) throws ServletException {
        try {
            SiteConfig.load(cfg.getServletContext());
        } catch (IOException e) {
            throw new ServletException("Could not load site configuration", e);
        }
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String ctx = request.getContextPath();
        // Decoded, container-normalised path inside the web app.
        String path = request.getServletPath() + (request.getPathInfo() == null ? "" : request.getPathInfo());
        if (path.isEmpty()) path = "/";

        // School's own domain (e.g. www.sanpoly.edu.in): that school's site, with clean URLs (no /sanpoly/ prefix).
        Site hostSite = SiteConfig.byHost(request.getServerName());

        // Root -> default public site
        if ("/".equals(path) && hostSite != null) {
            request.setAttribute(SiteConfig.ATTR_SITE, hostSite);
            request.setAttribute(SiteConfig.ATTR_SITE_BASE, ctx);
            request.getRequestDispatcher("/homepage").forward(request, response);
            return;
        }
        if ("/".equals(path)) {
            response.sendRedirect(ctx + "/" + SiteConfig.defaultSite().getKey() + "/");
            return;
        }

        // Website content is managed ONLY in PInventory (Office Central > Website).
        // The old admin pages of this project are switched off.
        if ("/admin".equals(path) || path.startsWith("/admin/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Website editing has moved to PInventory (Office Central).");
            return;
        }

        // Site prefix: /{site}/rest
        int slash = path.indexOf('/', 1);
        String first = (slash < 0 ? path.substring(1) : path.substring(1, slash)).toLowerCase(Locale.ROOT);
        Site site = SiteConfig.byKey(first);

        if (site != null) {
            if (slash < 0) {                       // "/srs" -> "/srs/"
                response.sendRedirect(ctx + path + "/");
                return;
            }
            String rest = path.substring(slash);   // starts with "/"
            if ("/".equals(rest)) rest = "/homepage";

            if (!isSafeForward(rest)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            request.setAttribute(SiteConfig.ATTR_SITE, site);
            request.setAttribute(SiteConfig.ATTR_SITE_BASE, ctx + "/" + site.getKey());
            // Request parameters (query string and form fields) are kept across the forward.
            request.getRequestDispatcher(rest).forward(request, response);
            return;
        }

        // Unprefixed URL or static file: the school's own domain decides; otherwise the default site
        if (hostSite != null) {
            request.setAttribute(SiteConfig.ATTR_SITE, hostSite);
            request.setAttribute(SiteConfig.ATTR_SITE_BASE, ctx);
            chain.doFilter(req, res);
            return;
        }
        Site def = SiteConfig.defaultSite();
        request.setAttribute(SiteConfig.ATTR_SITE, def);
        request.setAttribute(SiteConfig.ATTR_SITE_BASE, ctx + "/" + def.getKey());
        chain.doFilter(req, res);
    }

    /** Never forward into protected folders, admin pages or traversal paths. */
    private static boolean isSafeForward(String rest) {
        String r = rest.toLowerCase(Locale.ROOT);
        return !r.contains("..")
                && !r.contains("\\")
                && !r.contains(";")
                && !r.startsWith("/web-inf")
                && !r.startsWith("/meta-inf")
                && !r.startsWith("/admin");
    }

    @Override
    public void destroy() { }
}
