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
    private final String color1;    // main colour (header strip, footer, menus), e.g. #32175F; "" = SRS default
    private final String color2;    // accent colour (buttons, highlights, lines), e.g. #15A84C; "" = SRS default
    private final String pattern1;  // header/footer pattern, path inside the web app; "" = peacock pattern
    private final String pattern2;  // page background pattern, path inside the web app; "" = soft lattice

    Site(String key, String dbKey, String name, String shortName,
         String address, String tagline, String logo, String folder,
         String color1, String color2, String pattern1, String pattern2) {
        this.key = key;
        this.dbKey = dbKey;
        this.name = name;
        this.shortName = shortName;
        this.address = address;
        this.tagline = tagline;
        this.logo = logo;
        this.folder = folder;
        this.color1 = color1;
        this.color2 = color2;
        this.pattern1 = pattern1;
        this.pattern2 = pattern2;
    }

    public String getKey() { return key; }
    public String getDbKey() { return dbKey; }
    public String getName() { return name; }
    public String getShortName() { return shortName; }
    public String getAddress() { return address; }
    public String getTagline() { return tagline; }
    public String getLogo() { return logo; }
    public String getFolder() { return folder; }
    public String getColor1() { return color1; }
    public String getColor2() { return color2; }
    public String getPattern1() { return pattern1; }
    public String getPattern2() { return pattern2; }
    /** True when this site sets any colour or pattern of its own. */
    public boolean isThemed() {
        return !color1.isEmpty() || !color2.isEmpty() || !pattern1.isEmpty() || !pattern2.isEmpty();
    }
}
