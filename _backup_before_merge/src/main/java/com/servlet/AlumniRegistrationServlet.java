package com.servlet;

import com.bean.DBUtil;
import com.bean.PageBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * ALUMNI REGISTRATION  (public website)
 *
 *   GET  /alumni-registration   shows the form (same fields as the paper form)
 *   POST /alumni-registration   checks the data and saves it with the
 *                               stored procedure sp_enroll_alumni(...)
 *
 * After saving, the visitor is sent back with ?done=1 and sees a thank-you
 * message with a registration number (refreshing does not register twice).
 * Database objects: db/alumni_registration.sql
 */
@WebServlet("/alumni-registration")
public class AlumniRegistrationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final int FOUNDED = 1959;
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]{2,}$");
    private static final Pattern PHONE = Pattern.compile("^[+0-9 ()-]{7,20}$");
    private static final SecureRandom RANDOM = new SecureRandom();

    /** form fields, in the order of the paper form */
    static final String[] FIELDS = {
            "fullName", "dateOfBirth", "studyFrom", "studyTo", "passingX", "passingXii",
            "qualification", "occupation", "organization", "address", "contact", "email",
            "additionalInfo", "signature"
    };

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        token(session);

        if ("1".equals(req.getParameter("done")) && session.getAttribute("alumniDoneNo") != null) {
            req.setAttribute("doneNo", session.getAttribute("alumniDoneNo"));
            req.setAttribute("doneName", session.getAttribute("alumniDoneName"));
            session.removeAttribute("alumniDoneNo");
            session.removeAttribute("alumniDoneName");
        }
        show(req, resp, new LinkedHashMap<>(), new ArrayList<>());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        Map<String, String> f = new LinkedHashMap<>();
        for (String name : FIELDS) {
            String v = req.getParameter(name);
            f.put(name, v == null ? "" : v.trim());
        }
        List<String> errors = new ArrayList<>();

        // ---- simple protection against robots and double posts ----
        String expected = (String) session.getAttribute("alumniToken");
        if (expected == null || !expected.equals(req.getParameter("token"))) {
            errors.add("Your session expired. Please submit the form again.");
        }
        if (!isEmpty(req.getParameter("website"))) {          // hidden field only robots fill in
            resp.sendRedirect("alumni-registration?done=1");
            return;
        }

        // ---- checks (the stored procedure checks again) ----
        int thisYear = LocalDate.now().getYear();

        if (isEmpty(f.get("fullName"))) errors.add("Please enter your name.");

        LocalDate dob = null;
        try {
            dob = LocalDate.parse(f.get("dateOfBirth"));
            if (!dob.isBefore(LocalDate.now())) errors.add("Please enter a valid date of birth.");
        } catch (DateTimeParseException e) {
            errors.add("Please enter your date of birth.");
        }

        Integer from = year(f.get("studyFrom")), to = year(f.get("studyTo"));
        if (from == null || to == null) {
            errors.add("Please enter your years of study (From and To).");
        } else if (from < FOUNDED || to > thisYear || to < from) {
            errors.add("Please check your years of study (From must not be after To).");
        } else if (dob != null && dob.getYear() >= from) {
            errors.add("Date of birth must be before your years of study.");
        }

        Integer passX = year(f.get("passingX")), passXii = year(f.get("passingXii"));
        if (!isEmpty(f.get("passingX")) && (passX == null || passX < FOUNDED || passX > thisYear)) {
            errors.add("Please check the year of passing for X Class.");
        }
        if (!isEmpty(f.get("passingXii")) && (passXii == null || passXii < FOUNDED || passXii > thisYear)) {
            errors.add("Please check the year of passing for XII / PUC.");
        }

        if (isEmpty(f.get("address"))) errors.add("Please enter your mailing address.");
        if (!PHONE.matcher(f.get("contact")).matches()) errors.add("Please enter a valid contact number.");
        if (!EMAIL.matcher(f.get("email")).matches()) errors.add("Please enter a valid email address.");
        if (isEmpty(f.get("signature"))) errors.add("Please type your full name as your signature.");
        if (req.getParameter("declare") == null) errors.add("Please confirm that the details are correct.");

        String[][] limits = {
                {"fullName", "150"}, {"qualification", "255"}, {"occupation", "150"}, {"organization", "255"},
                {"address", "1000"}, {"contact", "20"}, {"email", "150"}, {"additionalInfo", "2000"}, {"signature", "150"}
        };
        for (String[] l : limits) {
            if (f.get(l[0]).length() > Integer.parseInt(l[1])) {
                errors.add("One of the answers is too long. Please shorten it.");
                break;
            }
        }

        if (!errors.isEmpty()) {
            show(req, resp, f, errors);
            return;
        }

        // ---- save with the stored procedure ----
        try (Connection conn = DBUtil.getConnection("SRS");
             CallableStatement cs = conn.prepareCall("{CALL sp_enroll_alumni(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}")) {

            cs.setString(1, f.get("fullName"));
            cs.setDate(2, Date.valueOf(dob));
            cs.setInt(3, from);
            cs.setInt(4, to);
            if (passX == null) cs.setNull(5, Types.SMALLINT); else cs.setInt(5, passX);
            if (passXii == null) cs.setNull(6, Types.SMALLINT); else cs.setInt(6, passXii);
            cs.setString(7, f.get("qualification"));
            cs.setString(8, f.get("occupation"));
            cs.setString(9, f.get("organization"));
            cs.setString(10, f.get("address"));
            cs.setString(11, f.get("contact"));
            cs.setString(12, f.get("email"));
            cs.setString(13, f.get("additionalInfo"));
            cs.setString(14, f.get("signature"));
            cs.setString(15, clientIp(req));
            cs.registerOutParameter(16, Types.BIGINT);
            cs.execute();

            long id = cs.getLong(16);
            String regNo = String.format("SRS/ALU/%d/%04d", thisYear, id);

            session.removeAttribute("alumniToken");
            session.setAttribute("alumniDoneNo", regNo);
            session.setAttribute("alumniDoneName", f.get("fullName"));
            resp.sendRedirect("alumni-registration?done=1");

        } catch (SQLException e) {
            if ("45000".equals(e.getSQLState())) {
                errors.add(e.getMessage());                 // readable message from the procedure
            } else {
                e.printStackTrace();
                errors.add("Sorry, we could not save your registration right now. Please try again later.");
            }
            show(req, resp, f, errors);
        }
    }

    // =========================================================

    private void show(HttpServletRequest req, HttpServletResponse resp,
                      Map<String, String> form, List<String> errors) throws ServletException, IOException {
        req.setAttribute("form", form);
        req.setAttribute("errors", errors);
        req.setAttribute("token", token(req.getSession()));
        req.setAttribute("today", LocalDate.now().toString());
        req.setAttribute("thisYear", LocalDate.now().getYear());

        PageBean pageData = new PageBean();
        pageData.setTitle("Alumni Registration");
        pageData.setSlug("alumni");
        req.setAttribute("pageData", pageData);
        req.setAttribute("pagesList", loadMenu());
        loadBatchCounts(req);

        resp.setHeader("Cache-Control", "no-store");
        req.getRequestDispatcher("/alumni_registration.jsp").forward(req, resp);
    }

    /**
     * Year-wise count of registered alumni for the small dashboard at the top.
     * Batch year = year of passing XII / PUC, else X Class, else last year at SRS.
     * Rejected registrations are not counted.
     */
    private void loadBatchCounts(HttpServletRequest req) {
        List<Map<String, Object>> rows = new ArrayList<>();
        int total = 0, max = 0;
        String sql = "SELECT COALESCE(passing_year_xii, passing_year_x, study_to_year) AS batch, COUNT(*) AS cnt "
                   + "FROM alumni_registrations WHERE status <> 'REJECTED' "
                   + "GROUP BY batch ORDER BY batch ASC";
        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int n = rs.getInt("cnt");
                Map<String, Object> r = new LinkedHashMap<>();
                r.put("year", rs.getInt("batch"));
                r.put("count", n);
                rows.add(r);
                total += n;
                max = Math.max(max, n);
            }
        } catch (Exception e) {
            e.printStackTrace();            // e.g. table not created yet: show an empty dashboard
        }
        for (Map<String, Object> r : rows) {
            int n = (Integer) r.get("count");
            r.put("pct", max == 0 ? 0 : Math.max(6, Math.round(n * 100f / max)));
        }
        req.setAttribute("batchCounts", rows);
        req.setAttribute("alumniTotal", total);
        req.setAttribute("batchTotal", rows.size());
        Map<String, Object> top = null;
        for (Map<String, Object> r : rows) {
            if (top == null || (Integer) r.get("count") > (Integer) top.get("count")) top = r;
        }
        req.setAttribute("topBatch", top);
    }

    /** the website menu, same as on every other page */
    private List<PageBean> loadMenu() {
        List<PageBean> roots = new ArrayList<>();
        Map<Long, PageBean> all = new LinkedHashMap<>();
        Map<Long, Long> parents = new LinkedHashMap<>();
        try (Connection conn = DBUtil.getConnection("SRS");
             PreparedStatement ps = conn.prepareStatement("SELECT id, title, slug, parent_id FROM pages ORDER BY id ASC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PageBean p = new PageBean();
                p.setId(rs.getLong("id"));
                p.setTitle(rs.getString("title"));
                p.setSlug(rs.getString("slug"));
                p.setChildren(new ArrayList<>());
                all.put(p.getId(), p);
                long parent = rs.getLong("parent_id");
                if (rs.wasNull()) roots.add(p); else parents.put(p.getId(), parent);
            }
            for (Map.Entry<Long, Long> e : parents.entrySet()) {
                PageBean child = all.get(e.getKey()), parent = all.get(e.getValue());
                if (child != null && parent != null) parent.getChildren().add(child);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roots;
    }

    private static String token(HttpSession s) {
        String t = (String) s.getAttribute("alumniToken");
        if (t == null) {
            byte[] b = new byte[18];
            RANDOM.nextBytes(b);
            t = Base64.getUrlEncoder().withoutPadding().encodeToString(b);
            s.setAttribute("alumniToken", t);
        }
        return t;
    }

    private static Integer year(String s) {
        if (s == null || !s.matches("\\d{4}")) return null;
        return Integer.parseInt(s);
    }

    private static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static String clientIp(HttpServletRequest req) {
        String fwd = req.getHeader("X-Forwarded-For");
        String ip = (fwd != null && !fwd.isEmpty()) ? fwd.split(",")[0].trim() : req.getRemoteAddr();
        return ip.length() > 45 ? ip.substring(0, 45) : ip;
    }
}
