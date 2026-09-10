<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.bean.DBUtil2" %> <%-- Update with your actual package name --%>

<%!
    // Utility method to escape HTML special characters and prevent XSS
    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String filterType = request.getParameter("job_type");
    String searchQuery = request.getParameter("search");

    StringBuilder sql = new StringBuilder("SELECT * FROM school_vacancies WHERE status = 'Open'");
    
    if (filterType != null && !filterType.trim().isEmpty() && !filterType.equals("All")) {
        sql.append(" AND job_type = ?");
    }
    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        sql.append(" AND (job_title LIKE ? OR department LIKE ? OR subject LIKE ? OR location LIKE ?)");
    }
    sql.append(" ORDER BY display_order ASC, created_at DESC");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Current Job Vacancies</title>
    <style>
        :root {
            --primary-dark: #612405;
            --primary-accent: #e26a2c;
            --primary-light: #fdf5f0;
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #2b1208;
            --text-muted: #6e5c54;
            --border-color: #e5d8cf;
            --shadow-sm: 0 2px 8px rgba(97, 36, 5, 0.06);
            --shadow-md: 0 6px 18px rgba(97, 36, 5, 0.12);
            --shadow-lg: 0 12px 28px rgba(97, 36, 5, 0.2);
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family:  sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            margin: 0;
            padding: 1rem 1rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            margin-bottom: 1.25rem;
            text-align: center;
        }

        .header h1 {
            color: var(--primary-dark);
            margin: 0 0 0.25rem 0;
            font-size: 2.25rem;
            font-weight: 800;
        }

        .header p {
            color: var(--text-muted);
            margin: 0;
            font-size: 1.05rem;
        }

        /* Search and Filter Form */
        .search-bar {
            background: var(--card-bg);
            padding: 0.75rem 1rem;
            border-radius: 10px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            margin-bottom: 1.25rem;
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            align-items: center;
        }

        .search-bar input, .search-bar select {
            padding: 0.5rem 0.85rem;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 0.95rem;
            flex: 1;
            min-width: 220px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            color: var(--text-main);
            background-color: #fff;
        }

        .search-bar input:focus, .search-bar select:focus {
            border-color: var(--primary-accent);
            box-shadow: 0 0 0 3px rgba(226, 106, 44, 0.15);
        }

        .search-bar button {
            background-color: var(--primary-accent);
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.95rem;
            transition: background-color 0.2s, transform 0.1s, box-shadow 0.2s;
            box-shadow: 0 2px 6px rgba(226, 106, 44, 0.3);
        }

        .search-bar button:hover {
            background-color: var(--primary-dark);
            box-shadow: 0 4px 10px rgba(97, 36, 5, 0.25);
        }

        /* Vacancy Cards Grid */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 1.25rem;
        }

        .card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 1rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--shadow-sm);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-accent);
        }

        .badge {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            font-size: 0.75rem;
            font-weight: 700;
            border-radius: 9999px;
            background-color: var(--primary-light);
            color: var(--primary-dark);
            border: 1px solid rgba(97, 36, 5, 0.15);
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin: 0 0 0.25rem 0;
            line-height: 1.3;
        }

        .card-meta {
            color: var(--text-muted);
            font-size: 0.875rem;
            margin-bottom: 0.75rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px dashed var(--border-color);
        }

        .info-details {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
            margin-bottom: 0.75rem;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.875rem;
            color: var(--text-main);
        }

        .info-row strong {
            color: var(--text-muted);
            font-weight: 600;
        }

        .card-actions {
            margin-top: auto;
            padding-top: 0.75rem;
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            flex: 1;
            padding: 0.5rem 0.85rem;
            border: 1px solid transparent;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary {
            background-color: var(--primary-accent);
            color: white;
            border-color: var(--primary-accent);
            box-shadow: 0 2px 4px rgba(226, 106, 44, 0.25);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
            box-shadow: 0 4px 8px rgba(97, 36, 5, 0.2);
        }

        .btn-secondary {
            background-color: #ffffff;
            color: var(--primary-dark);
            border-color: var(--border-color);
        }

        .btn-secondary:hover {
            background-color: var(--primary-light);
            border-color: var(--primary-dark);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(43, 18, 8, 0.6);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-content {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            max-width: 650px;
            width: 90%;
            max-height: 85vh;
            overflow-y: auto;
            position: relative;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-color);
        }

        .close-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            cursor: pointer;
            border: none;
            background: transparent;
            color: var(--text-muted);
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.2s, color 0.2s;
        }

        .close-btn:hover {
            background-color: var(--primary-light);
            color: var(--primary-dark);
        }

        .modal-section {
            margin-bottom: 0.85rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--border-color);
        }

        .modal-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .modal-section h4 {
            margin: 0 0 0.25rem 0;
            color: var(--primary-accent);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
        }

        .modal-section p {
            margin: 0;
            color: var(--text-main);
            line-height: 1.5;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>SANDUR RESIDENTIAL SCHOOL, SANDUR</h1>
        <h2>Current Job Vacancies</h2>
        <p>Explore opportunities and apply today.</p>
    </div>

    <!-- Search and Filter Form -->
    <form class="search-bar" method="GET" action="vacancies.jsp">
        <input type="text" name="search" placeholder="Search by title, department, subject, location..." value="<%= searchQuery != null ? escapeHtml(searchQuery) : "" %>">
        
        <select name="job_type">
            <option value="All">All Types</option>
            <option value="Teaching" <%= "Teaching".equals(filterType) ? "selected" : "" %>>Teaching</option>
            <option value="Non-Teaching" <%= "Non-Teaching".equals(filterType) ? "selected" : "" %>>Non-Teaching</option>
        </select>
        
        <button type="submit">Filter Results</button>
    </form>

    <!-- Vacancy Cards Grid -->
    <div class="grid">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean found = false;

            try {
                conn = DBUtil2.getConnection();
                pstmt = conn.prepareStatement(sql.toString());

                int paramIdx = 1;
                if (filterType != null && !filterType.trim().isEmpty() && !filterType.equals("All")) {
                    pstmt.setString(paramIdx++, filterType);
                }
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    String pattern = "%" + searchQuery.trim() + "%";
                    pstmt.setString(paramIdx++, pattern);
                    pstmt.setString(paramIdx++, pattern);
                    pstmt.setString(paramIdx++, pattern);
                    pstmt.setString(paramIdx++, pattern);
                }

                rs = pstmt.executeQuery();

                while (rs.next()) {
                    found = true;
                    int id = rs.getInt("id");
                    String title = rs.getString("job_title");
                    String type = rs.getString("job_type");
                    String dept = rs.getString("department");
                    String subject = rs.getString("subject");
                    String empType = rs.getString("employment_type");
                    String location = rs.getString("location");
                    String salary = rs.getString("salary");
                    int vacancies = rs.getInt("number_of_vacancies");
                    Date lastDate = rs.getDate("application_last_date");
                    
                    String qual = rs.getString("qualification");
                    String exp = rs.getString("experience");
                    String desc = rs.getString("job_description");
                    String resp = rs.getString("responsibilities");
                    String skills = rs.getString("skills_required");
                    String email = rs.getString("application_email");
                    String link = rs.getString("application_link");
                    String contactPerson = rs.getString("contact_person");
                    String contactPhone = rs.getString("contact_phone");
        %>
            <div class="card">
                <div>
                    <span class="badge"><%= escapeHtml(type) %></span>
                    <h2 class="card-title"><%= escapeHtml(title) %></h2>
                    <div class="card-meta">
                        Department : <%=   (dept != null && !dept.isEmpty()) ? escapeHtml(dept) : "General" %> <br>
                        <%= (subject != null && !subject.isEmpty()) ? " Qualification : " + escapeHtml(subject) : "" %>
                    </div>

                    <div class="info-details">
                        <div class="info-row"><strong>Employment:</strong> <span><%= empType != null ? escapeHtml(empType) : "N/A" %></span></div>
                        <div class="info-row"><strong>Location:</strong> <span><%= location != null ? escapeHtml(location) : "N/A" %></span></div>
                        <div class="info-row"><strong>Vacancies:</strong> <span><%= vacancies %></span></div>
                        <% if (salary != null && !salary.trim().isEmpty()) { %>
                            <div class="info-row"><strong>Salary:</strong> <span><%= escapeHtml(salary) %></span></div>
                        <% } %>
                        <% if (lastDate != null) { %>
                            <div class="info-row"><strong>Last Date:</strong> <span><%= lastDate.toString() %></span></div>
                        <% } %>
                    </div>
                </div>

                <div class="card-actions">
                    <button type="button" class="btn btn-secondary" onclick="openDetailsModal('<%= id %>')">View Details</button>
                    <% if (link != null && !link.trim().isEmpty()) { %>
                        <a href="<%= escapeHtml(link) %>" target="_blank" class="btn btn-primary">Apply Now</a>
                    <% } else if (email != null && !email.trim().isEmpty()) { %>
                        <a href="mailto:<%= escapeHtml(email) %>?subject=Application for <%= escapeHtml(title) %>" class="btn btn-primary">Apply Now</a>
                    <% } %>
                </div>
            </div>

            <!-- Hidden Template Data for Detail Modal -->
            <div id="details-<%= id %>" style="display:none;">
                <span data-key="title"><%= escapeHtml(title) %></span>
                <span data-key="type"><%= escapeHtml(type) %></span>
                <span data-key="dept"><%= dept != null ? escapeHtml(dept) : "N/A" %></span>
                <span data-key="subject"><%= subject != null ? escapeHtml(subject) : "N/A" %></span>
                <span data-key="qual"><%= qual != null ? escapeHtml(qual) : "Not specified" %></span>
                <span data-key="exp"><%= exp != null ? escapeHtml(exp) : "Not specified" %></span>
                <span data-key="desc"><%= desc != null ? escapeHtml(desc) : "N/A" %></span>
                <span data-key="resp"><%= resp != null ? escapeHtml(resp) : "N/A" %></span>
                <span data-key="skills"><%= skills != null ? escapeHtml(skills) : "N/A" %></span>
                <span data-key="contact"><%= (contactPerson != null ? escapeHtml(contactPerson) : "HR") + (contactPhone != null ? " (" + escapeHtml(contactPhone) + ")" : "") %></span>
            </div>
        <%
                }
                if (!found) {
        %>
            <p style="grid-column: 1 / -1; text-align: center; color: var(--text-muted); padding: 1.5rem 0; font-size: 1.1rem;">
                No open vacancies found matching your criteria.
            </p>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red; grid-column: 1 / -1;'>Error loading vacancies: " + escapeHtml(e.getMessage()) + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        %>
    </div>
</div>

<!-- Job Details Modal -->
<div id="modal" class="modal">
    <div class="modal-content">
        <button type="button" class="close-btn" onclick="closeModal()">&times;</button>
        <span class="badge" id="m-type"></span>
        <h2 id="m-title" style="margin-top:0.25rem; color: var(--primary-dark);"></h2>
        
        <div class="modal-section">
            <h4>Department & Subject</h4>
            <p><span id="m-dept"></span> (<span id="m-subject"></span>)</p>
        </div>

        <div class="modal-section">
            <h4>Qualifications Required</h4>
            <p id="m-qual"></p>
        </div>

        <div class="modal-section">
            <h4>Experience Required</h4>
            <p id="m-exp"></p>
        </div>

        <div class="modal-section">
            <h4>Job Description</h4>
            <p id="m-desc"></p>
        </div>

        <div class="modal-section">
            <h4>Responsibilities</h4>
            <p id="m-resp"></p>
        </div>

        <div class="modal-section">
            <h4>Key Skills</h4>
            <p id="m-skills"></p>
        </div>

        <div class="modal-section">
            <h4>Contact Info</h4>
            <p id="m-contact"></p>
        </div>
    </div>
</div>

<script>
    function openDetailsModal(id) {
        const dataContainer = document.getElementById('details-' + id);
        if (!dataContainer) return;

        const getVal = (key) => {
            const el = dataContainer.querySelector('[data-key="' + key + '"]');
            return el ? el.textContent : '';
        };

        document.getElementById('m-title').textContent = getVal('title');
        document.getElementById('m-type').textContent = getVal('type');
        document.getElementById('m-dept').textContent = getVal('dept');
        document.getElementById('m-subject').textContent = getVal('subject');
        document.getElementById('m-qual').textContent = getVal('qual');
        document.getElementById('m-exp').textContent = getVal('exp');
        document.getElementById('m-desc').textContent = getVal('desc');
        document.getElementById('m-resp').textContent = getVal('resp');
        document.getElementById('m-skills').textContent = getVal('skills');
        document.getElementById('m-contact').textContent = getVal('contact');

        document.getElementById('modal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('modal').style.display = 'none';
    }

    window.onclick = function(event) {
        const modal = document.getElementById('modal');
        if (event.target === modal) {
            closeModal();
        }
    }
</script>

</body>
</html>