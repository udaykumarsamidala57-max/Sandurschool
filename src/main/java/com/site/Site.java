package com.site;

/** One public website (school) served by this application. Values come from WEB-INF/sites.properties. */
public final class Site {

    private final String key;       // URL prefix, e.g. "srs" -> /srs/homepage
    private final String dbKey;     // environment prefix, e.g. "SRS" -> SRS_DB_URL
    private final String name;
    private final String shortName;
    private final String address;
    private final String tagline;
    private final String logo;      // path inside the web app, e.g. /Home/logo.png
    private final String folder;    // bucket folder for this site's photos, e.g. SANPOLY-WEBSITE

    Site(String key, String dbKey, String name, String shortName,
         String address, String tagline, String logo, String folder) {
        this.key = key;
        this.dbKey = dbKey;
        this.name = name;
        this.shortName = shortName;
        this.address = address;
        this.tagline = tagline;
        this.logo = logo;
        this.folder = folder;
    }

    public String getKey() { return key; }
    public String getDbKey() { return dbKey; }
    public String getName() { return name; }
    public String getShortName() { return shortName; }
    public String getAddress() { return address; }
    public String getTagline() { return tagline; }
    public String getLogo() { return logo; }
    public String getFolder() { return folder; }
}
