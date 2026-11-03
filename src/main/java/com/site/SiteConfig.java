package com.site;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

/**
 * Registry of public sites. Loaded once from /WEB-INF/sites.properties by {@link SiteFilter}.
 * The URL prefix decides the site, and the site decides the database.
 */
public final class SiteConfig {

    public static final String ATTR_SITE = "site";
    public static final String ATTR_SITE_BASE = "siteBase";

    private static volatile Map<String, Site> sites = Collections.emptyMap();
    private static volatile Site defaultSite;
    /** Domain name (lower case, no port) -> site, e.g. "www.sanpoly.edu.in" -> sanpoly. */
    private static volatile Map<String, Site> byDomain = Collections.emptyMap();

    /**
     * Domains of a site: Railway variable SITE_DOMAINS_<KEY> (e.g. SITE_DOMAINS_SANPOLY) if set,
     * otherwise "<key>.domains" in sites.properties. Comma separated, e.g. "sanpoly.edu.in,www.sanpoly.edu.in".
     */
    private static String domainsFor(Properties p, String key) {
        String env = System.getenv("SITE_DOMAINS_" + key.toUpperCase(Locale.ROOT).replace('-', '_'));
        if (env != null && !env.trim().isEmpty()) return env;
        return p.getProperty(key + ".domains", "");
    }

    /** Site whose own domain this is (Host header without port), or null for shared/unknown hosts. */
    public static Site byHost(String host) {
        if (host == null) return null;
        String h = host.trim().toLowerCase(Locale.ROOT);
        int colon = h.indexOf(':');
        if (colon >= 0) h = h.substring(0, colon);
        return byDomain.get(h);
    }

    private SiteConfig() { }

    static synchronized void load(ServletContext ctx) throws IOException {
        Properties p = new Properties();
        try (InputStream in = ctx.getResourceAsStream("/WEB-INF/sites.properties")) {
            if (in == null) {
                throw new IOException("Missing /WEB-INF/sites.properties");
            }
            p.load(new InputStreamReader(in, StandardCharsets.UTF_8));
        }

        Map<String, Site> map = new LinkedHashMap<>();
        for (String raw : p.getProperty("sites", "").split(",")) {
            String key = raw.trim().toLowerCase(Locale.ROOT);
            if (key.isEmpty()) continue;
            if (!key.matches("[a-z0-9_-]+")) {
                throw new IOException("Invalid site key in sites.properties: " + key);
            }
            String dbKey = p.getProperty(key + ".db", key).trim().toUpperCase(Locale.ROOT);
            if (!dbKey.matches("[A-Z0-9_]+")) {
                throw new IOException("Invalid db key for site " + key + ": " + dbKey);
            }
            String folder = p.getProperty(key + ".folder", key).trim();
            if (!folder.matches("[A-Za-z0-9_-]+")) {
                throw new IOException("Invalid bucket folder for site " + key + ": " + folder);
            }
            map.put(key, new Site(
                    key,
                    dbKey,
                    p.getProperty(key + ".name", key),
                    p.getProperty(key + ".short", key.toUpperCase(Locale.ROOT)),
                    p.getProperty(key + ".address", ""),
                    p.getProperty(key + ".tagline", ""),
                    p.getProperty(key + ".logo", "/Home/logo.png"),
                    folder,
                    color(p, key, "color1"),
                    color(p, key, "color2"),
                    pattern(p, key, "pattern1"),
                    pattern(p, key, "pattern2")));
        }
        if (map.isEmpty()) {
            throw new IOException("sites.properties defines no sites");
        }

        Map<String, Site> domains = new LinkedHashMap<>();
        for (Site s : map.values()) {
            for (String raw : domainsFor(p, s.getKey()).split(",")) {
                String d = raw.trim().toLowerCase(Locale.ROOT);
                if (d.isEmpty()) continue;
                if (!d.matches("[a-z0-9.-]+")) {
                    throw new IOException("Invalid domain for site " + s.getKey() + ": " + d);
                }
                if (domains.containsKey(d)) {
                    throw new IOException("Domain " + d + " is given to two sites");
                }
                domains.put(d, s);
            }
        }

        String def = p.getProperty("default", "").trim().toLowerCase(Locale.ROOT);
        byDomain = Collections.unmodifiableMap(domains);
        sites = Collections.unmodifiableMap(map);
        defaultSite = map.containsKey(def) ? map.get(def) : map.values().iterator().next();
    }

    /** "#RGB" or "#RRGGBB" only (it is written into the page's CSS), or "" when not set. */
    private static String color(Properties p, String key, String name) throws IOException {
        String v = p.getProperty(key + "." + name, "").trim();
        if (v.isEmpty()) return "";
        if (!v.matches("#[0-9A-Fa-f]{3}|#[0-9A-Fa-f]{6}")) {
            throw new IOException("Invalid " + name + " for site " + key + " (use #RRGGBB): " + v);
        }
        return v;
    }

    /** Image path inside the web app, e.g. /Home/sanpoly/pattern1.svg, or "" when not set. */
    private static String pattern(Properties p, String key, String name) throws IOException {
        String v = p.getProperty(key + "." + name, "").trim();
        if (v.isEmpty()) return "";
        if (!v.matches("/[A-Za-z0-9_./-]+\\.(svg|png|jpg|jpeg|webp)") || v.contains("..")) {
            throw new IOException("Invalid " + name + " for site " + key + " (use a path like /Home/x/pattern.svg): " + v);
        }
        return v;
    }

    /** Site by URL key, or null. */
    public static Site byKey(String key) {
        return key == null ? null : sites.get(key.toLowerCase(Locale.ROOT));
    }

    /**
     * Site for a URL key or an admin branch name ("SRS", "Sanpoly"), case-insensitive.
     * Returns null when nothing matches.
     */
    public static Site resolve(String keyOrBranch) {
        if (keyOrBranch == null) return null;
        return sites.get(keyOrBranch.trim().toLowerCase(Locale.ROOT));
    }

    /** True when the database key belongs to a configured site (used by DBUtil). */
    public static boolean isKnownDbKey(String dbKey) {
        if (dbKey == null) return false;
        for (Site s : sites.values()) {
            if (s.getDbKey().equalsIgnoreCase(dbKey)) return true;
        }
        return false;
    }

    public static Site defaultSite() {
        return defaultSite;
    }

    public static Map<String, Site> all() {
        return sites;
    }

    /** Site chosen by SiteFilter for this request (falls back to the default site). */
    public static Site current(HttpServletRequest request) {
        Object s = request.getAttribute(ATTR_SITE);
        return (s instanceof Site) ? (Site) s : defaultSite;
    }

    /** Database key for the current public site, e.g. "SRS" or "SANPOLY". */
    public static String db(HttpServletRequest request) {
        Site s = current(request);
        return s == null ? null : s.getDbKey();
    }
}
