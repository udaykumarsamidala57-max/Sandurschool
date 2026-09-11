<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.bean.DBUtil2" %>

<%!
    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    public static class Vacancy {
        public String jobTitle;
        public int vacancies;
        public String qualification;
        public String experience;
        public String category;

        public Vacancy(String jobTitle, int vacancies, String qualification, String experience, String category) {
            this.jobTitle = jobTitle;
            this.vacancies = vacancies;
            this.qualification = qualification;
            this.experience = experience;
            this.category = category;
        }
    }
%>

<%
    List<Vacancy> teachingList = new ArrayList<>();
    List<Vacancy> nonTeachingList = new ArrayList<>();
    boolean fetchError = false;

    String sql = "SELECT job_title, number_of_vacancies, qualification, experience, " +
                 "CASE WHEN LOWER(job_title) REGEXP 'driver|accountant|clerk|attender|lab|assistant|peon|security|receptionist|office|admin|manager|cleaner|bus|helper' " +
                 "THEN 'Non-Teaching' ELSE 'Teaching' END AS auto_category " +
                 "FROM school_vacancies WHERE status = 'Open' ORDER BY display_order ASC, created_at DESC";

    try (Connection conn = DBUtil2.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery()) {

        while (rs.next()) {
            String title = rs.getString("job_title");
            int vacancies = rs.getInt("number_of_vacancies");
            String qual = rs.getString("qualification");
            String exp = rs.getString("experience");
            String cat = rs.getString("auto_category");

            Vacancy v = new Vacancy(title, vacancies, qual, exp, cat);
            if ("Non-Teaching".equalsIgnoreCase(cat)) {
                nonTeachingList.add(v);
            } else {
                teachingList.add(v);
            }
        }
    } catch (Exception e) {
        fetchError = true;
    }

    int totalVacancies = teachingList.size() + nonTeachingList.size();
    boolean isLowCount = (totalVacancies <= 3);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruitment Notice </title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- html2canvas for High-Definition Image Generation -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

    <style>
        :root {
            --primary-dark: #612405;
            --primary-accent: #e26a2c;
            --bg-color: #eef2f5;
            --card-bg: #ffffff;
            --text-main: #2b1208;
            --text-muted: #6e5c54;
            --border-color: #e5d8cf;
            --table-header-bg: #612405;
            --table-row-alt: #fdf5f0;
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            padding: 20px 10px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .print-actions {
            width: 100%;
            max-width: 1080px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            border: none;
            padding: 10px 18px;
            font-size: 0.9rem;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: white;
        }

        .btn-jpg {
            background-color: #d9534f;
            box-shadow: 0 4px 10px rgba(217, 83, 79, 0.3);
        }

        .btn-jpg:hover {
            background-color: #c9302c;
        }

        .btn-print {
            background-color: var(--primary-accent);
            box-shadow: 0 4px 10px rgba(226, 106, 44, 0.3);
        }

        .btn-print:hover {
            background-color: var(--primary-dark);
        }

        .poster-frame {
            width: 1080px;
            min-width: 1080px;
            min-height: 1080px;
            height: auto;
            background-color: #ffffff;
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            display: flex;
            flex-direction: column;
        }

        .poster-container {
            width: 100%;
            height: 100%;
            min-height: 1032px;
            background: var(--card-bg);
            border: 6px solid var(--primary-dark);
            border-radius: 4px;
            padding: 28px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-grow: 1;
        }

        .header-image-container {
            width: 100%;
            text-align: center;
            margin-bottom: 16px;
            border-bottom: 4px solid var(--primary-accent);
            padding-bottom: 12px;
        }

        .header-image-container img {
            max-width: 100%;
            height: auto;
            max-height: 140px;
            object-fit: contain;
        }

        .poster-banner {
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-accent));
            color: white;
            text-align: center;
            padding: 16px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .poster-banner h1 {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            line-height: 1.2;
        }

        .poster-banner p {
            font-size: 1.1rem;
            font-weight: 600;
            letter-spacing: 1.2px;
            opacity: 0.95;
            margin-top: 4px;
        }

        .content-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-evenly;
        }

        .section-header {
            display: flex;
            align-items: center;
            margin-top: 12px;
            margin-bottom: 10px;
            padding: 10px 16px;
            background-color: var(--primary-dark);
            color: white;
            border-radius: 4px;
            font-size: 1.1rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }

        .section-header.non-teaching {
            background-color: #2c3e50;
        }

        .table-responsive {
            width: 100%;
            margin-bottom: 16px;
        }

        .vacancy-table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            table-layout: fixed;
        }

        .vacancy-table th {
            background-color: var(--table-header-bg);
            color: white;
            font-size: 0.95rem;
            font-weight: 700;
            text-transform: uppercase;
            padding: 12px 14px;
            text-align: left;
            border-bottom: 3px solid var(--primary-accent);
        }

        .vacancy-table.non-teaching-table th {
            background-color: #2c3e50;
            border-bottom: 3px solid #34495e;
        }

        .vacancy-table td {
            padding: 12px 14px;
            font-size: 0.95rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
            word-wrap: break-word;
        }

        .vacancy-table tbody tr:nth-child(even) {
            background-color: var(--table-row-alt);
        }

        .job-name {
            font-weight: 700;
            color: var(--primary-dark);
        }

        .poster-footer {
            margin-top: 20px;
            text-align: center;
            background-color: var(--table-row-alt);
            border: 2px dashed var(--primary-accent);
            border-radius: 4px;
            padding: 16px;
            font-size: 0.95rem;
            color: var(--primary-dark);
            font-weight: 600;
        }

        .empty-notice {
            text-align: center;
            padding: 16px;
            color: var(--text-muted);
            font-size: 0.95rem;
            font-style: italic;
        }

        /* Dynamic Spacing Adjustments when Vacancies <= 3 */
        .poster-container[data-low-count="true"] .poster-banner {
            padding: 24px;
            margin-bottom: 30px;
        }

        .poster-container[data-low-count="true"] .poster-banner h1 {
            font-size: 2.8rem;
        }

        .poster-container[data-low-count="true"] .poster-banner p {
            font-size: 1.3rem;
        }

        .poster-container[data-low-count="true"] .section-header {
            padding: 14px 20px;
            font-size: 1.3rem;
            margin-top: 18px;
            margin-bottom: 16px;
        }

        .poster-container[data-low-count="true"] .vacancy-table th {
            padding: 18px 20px;
            font-size: 1.15rem;
        }

        .poster-container[data-low-count="true"] .vacancy-table td {
            padding: 22px 20px;
            font-size: 1.15rem;
        }

        .poster-container[data-low-count="true"] .poster-footer {
            padding: 24px;
            font-size: 1.15rem;
            margin-top: 30px;
        }

        @media print {
            @page {
                size: A4 portrait;
                margin: 0;
            }

            body {
                background: white;
                padding: 0;
            }

            .print-actions {
                display: none;
            }

            .poster-frame {
                box-shadow: none;
                padding: 0;
                width: 100%;
                min-width: 100%;
                min-height: 100vh;
            }

            .poster-container {
                border: 4px solid #000;
                box-shadow: none;
                min-height: 100vh;
            }

            .poster-banner, .section-header {
                background: #000 !important;
                color: #fff !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .vacancy-table th {
                background-color: #333 !important;
                color: #fff !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }
        }
    </style>
</head>
<body>

    <div class="print-actions">
        <span style="font-weight: 700; color: var(--primary-dark);"></span>
        <div class="action-buttons">
            <button class="btn btn-jpg" onclick="downloadJPG()">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                    <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/>
                </svg>
                Download Notification
            </button>
            <button class="btn btn-print" onclick="window.print()">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M2.5 8a.5.5 0 1 0 0-1 .5.5 0 0 0 0 1z"/>
                    <path d="M5 1a2 2 0 0 0-2 2v2H2a2 2 0 0 0-2 2v3a2 2 0 0 0 2 2h1v1a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-1h1a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-1V3a2 2 0 0 0-2-2H5zM4 3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2H4V3zm1 5a2 2 0 0 0-2 2v1H2a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-1v-1a2 2 0 0 0-2-2H5zm1 3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1v-3z"/>
                </svg>
                Print A4
            </button>
        </div>
    </div>

    <div class="poster-frame" id="capture-frame">
        <div class="poster-container" data-low-count="<%= isLowCount %>">

            <div>
                <div class="header-image-container">
                    <img src="Home/recru.png" alt="Institution Header Logo" onerror="this.style.display='none'">
                </div>

                <div class="poster-banner">
                    <h1>CAREER OPPORTUNITIES</h1>
                    <p>WE ARE HIRING — JOIN OUR TEAM</p>
                </div>
            </div>

            <div class="content-area">
                <% if (fetchError) { %>
                    <div class="empty-notice" style="color: var(--primary-accent);">
                        Unable to load recruitment details at this time.
                    </div>
                <% } else { %>

                    <% if (!teachingList.isEmpty()) { %>
                        <div class="section-header">
                            <span>Teaching Positions</span>
                        </div>
                        <div class="table-responsive">
                            <table class="vacancy-table">
                                <thead>
                                    <tr>
                                        <th style="width: 8%;">#</th>
                                        <th style="width: 40%;">Designation / Subject</th>
                                        <th style="width: 32%;">Required Qualification</th>
                                        <th style="width: 20%;">Experience</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int sNo = 1;
                                        for (Vacancy v : teachingList) {
                                    %>
                                                <tr>
                                                    <td><%= sNo++ %></td>
                                                    <td class="job-name"><%= escapeHtml(v.jobTitle) %></td>
                                                    <td><%= (v.qualification != null && !v.qualification.trim().isEmpty()) ? escapeHtml(v.qualification) : "As per Norms" %></td>
                                                    <td><%= (v.experience != null && !v.experience.trim().isEmpty()) ? escapeHtml(v.experience) : "Freshers Can Apply" %></td>
                                                </tr>
                                    <%  } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>

                    <% if (!nonTeachingList.isEmpty()) { %>
                        <div class="section-header non-teaching">
                            <span>Non-Teaching Positions</span>
                        </div>
                        <div class="table-responsive">
                            <table class="vacancy-table non-teaching-table">
                                <thead>
                                    <tr>
                                        <th style="width: 8%;">#</th>
                                        <th style="width: 40%;">Designation / Role</th>
                                        <th style="width: 32%;">Required Qualification</th>
                                        <th style="width: 20%;">Experience</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int sNo = 1;
                                        for (Vacancy v : nonTeachingList) {
                                    %>
                                                <tr>
                                                    <td><%= sNo++ %></td>
                                                    <td class="job-name" style="color: #2c3e50;"><%= escapeHtml(v.jobTitle) %></td>
                                                    <td><%= (v.qualification != null && !v.qualification.trim().isEmpty()) ? escapeHtml(v.qualification) : "As per Norms" %></td>
                                                    <td><%= (v.experience != null && !v.experience.trim().isEmpty()) ? escapeHtml(v.experience) : "Freshers Can Apply" %></td>
                                                </tr>
                                    <%  } %>
                                </tbody>
                            </table>
                            
                        </div>
                    <% } %>

                    <% if (teachingList.isEmpty() && nonTeachingList.isEmpty()) { %>
                        <div class="empty-notice">
                            No positions currently open.
                        </div>
                    <% } %>

                <% } %>
            </div>

            <div class="poster-footer">
                Interested candidates can submit their resume at the administrative office or apply online via our portal.
            </div>
            <span align="right">As on <%= new java.text.SimpleDateFormat("dd MMMM yyyy").format(new java.util.Date()) %></span>
        </div>
    </div>

    <script>
        function downloadJPG() {
            const frame = document.getElementById('capture-frame');
            const actualHeight = frame.offsetHeight;
            const targetHeight = actualHeight > 1080 ? Math.round(1080 * 1.414) : 1080;

            html2canvas(frame, {
                scale: 2,
                useCORS: true,
                backgroundColor: '#ffffff',
                logging: false,
                width: 1080,
                height: targetHeight,
                windowWidth: 1080
            }).then(canvas => {
                const link = document.createElement('a');
                link.download = 'SRS-Recruitment_Instagram_A4.jpg';
                link.href = canvas.toDataURL('image/jpeg', 0.95);
                link.click();
            });
        }
    </script>

</body>
</html>