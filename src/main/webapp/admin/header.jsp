<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session check MUST be at the very top before any white space or dynamic output
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String user   = (String) sess.getAttribute("username");
    String role   = (String) sess.getAttribute("role");
    String dept   = (String) sess.getAttribute("department");
    String branch = (String) sess.getAttribute("branch");
    String initials = (user != null && !user.trim().isEmpty()) ? user.trim().substring(0, 1).toUpperCase() : "?";
    boolean canMove = "Global".equalsIgnoreCase(role) || "Admin".equalsIgnoreCase(role);
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Admin top bar (styles are self-contained so every admin page looks the same) -->
<style type="text/css">
    /* Salesforce Lightning-style global header + app navigation bar (88px) */
    .srs-topbar {
        all: initial;
        box-sizing: border-box;
        position: sticky;
        top: 0;
        z-index: 1000;
        display: block;
        width: 100%;
        font-family: 'Salesforce Sans', -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        color: #181818;
        -webkit-font-smoothing: antialiased;
        box-shadow: 0 2px 3px rgba(0, 0, 0, .12);
    }
    .srs-topbar *, .srs-topbar *::before, .srs-topbar *::after { box-sizing: border-box; margin: 0; padding: 0; font-family: inherit; }
    .srs-topbar a { text-decoration: none; color: inherit; }

    .srs-topbar .tb-global {
        display: flex; align-items: center; gap: 12px;
        height: 48px; padding: 0 12px;
        background: #fff; border-bottom: 1px solid #dddbda;
    }
    .srs-topbar .tb-logo { display: flex; align-items: center; gap: 8px; }
    .srs-topbar .tb-logo .mark {
        width: 28px; height: 28px; border-radius: 4px;
        display: flex; align-items: center; justify-content: center;
        background: #612405; color: #fff; font-size: 11px; font-weight: 700;
    }
    .srs-topbar .tb-logo b { font-size: 13px; font-weight: 700; color: #181818; }
    .srs-topbar .tb-right { margin-left: auto; display: flex; align-items: center; gap: 8px; }
    .srs-topbar .tb-branch {
        height: 20px; padding: 0 8px; border-radius: 15rem;
        display: inline-flex; align-items: center;
        background: #ecebea; color: #3e3e3c; font-size: 12px;
    }
    .srs-topbar .tb-avatar {
        width: 32px; height: 32px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        background: #0176d3; color: #fff; font-size: 13px; font-weight: 700;
    }
    .srs-topbar .tb-user-text { display: flex; flex-direction: column; line-height: 1.2; }
    .srs-topbar .tb-user-text b { font-size: 13px; font-weight: 700; }
    .srs-topbar .tb-user-text small { font-size: 12px; color: #5c5c5c; }
    .srs-topbar .tb-logout {
        display: inline-flex; align-items: center; gap: 6px; height: 32px; padding: 0 12px;
        border: 1px solid #c9c9c9; border-radius: 4px; background: #fff;
        color: #0176d3; font-size: 13px; white-space: nowrap;
    }
    .srs-topbar .tb-logout:hover { background: #f3f3f3; color: #014486; }
    .srs-topbar .tb-logout svg { width: 14px; height: 14px; }

    .srs-topbar .tb-appbar {
        display: flex; align-items: stretch;
        height: 40px; padding: 0 12px;
        background: #fff; border-bottom: 3px solid #0176d3;
    }
    .srs-topbar .tb-app {
        display: flex; align-items: center; gap: 10px;
        padding-right: 24px; margin-right: 8px;
    }
    .srs-topbar .tb-waffle { display: grid; grid-template-columns: repeat(3, 4px); gap: 3px; }
    .srs-topbar .tb-waffle i { width: 4px; height: 4px; border-radius: 50%; background: #747474; display: block; }
    .srs-topbar .tb-app b { font-size: 18px; font-weight: 400; color: #181818; white-space: nowrap; }
    .srs-topbar .tb-nav { display: flex; align-items: stretch; }
    .srs-topbar .tb-nav a {
        position: relative; display: flex; align-items: center; gap: 6px;
        padding: 0 12px; color: #181818; font-size: 13px; white-space: nowrap;
        border-left: 1px solid transparent; border-right: 1px solid transparent;
    }
    .srs-topbar .tb-nav a:hover { background: #f3f3f3; }
    .srs-topbar .tb-nav a.active { font-weight: 700; background: rgba(1, 118, 211, .06); }
    .srs-topbar .tb-nav a.active::before {
        content: ''; position: absolute; left: 0; right: 0; top: 0; height: 3px; background: #0176d3;
    }
    .srs-topbar .tb-nav svg { width: 14px; height: 14px; color: #747474; }
    .srs-topbar .tb-nav a.active svg { color: #0176d3; }
    @media (max-width: 900px) {
        .srs-topbar .tb-user-text, .srs-topbar .tb-branch, .srs-topbar .tb-logo b { display: none; }
        .srs-topbar .tb-app b { font-size: 15px; }
        .srs-topbar .tb-app { padding-right: 8px; }
        .srs-topbar .tb-nav a span { display: none; }
        .srs-topbar .tb-appbar { overflow-x: auto; }
    }
</style>

<header class="srs-topbar">
    <div class="tb-global">
        <a class="tb-logo" href="<c:url value='/admin/pages'/>">
            <span class="mark">SSS</span>
            <b>Shivapur Shikshana Samiti</b>
        </a>
        <div class="tb-right">
            <c:if test="${not empty sessionScope.branch}"><span class="tb-branch">${fn:escapeXml(sessionScope.branch)}</span></c:if>
            <span class="tb-avatar" title="${fn:escapeXml(sessionScope.username)}"><%= initials %></span>
            <span class="tb-user-text">
                <b>${fn:escapeXml(sessionScope.username)}</b>
                <small>${fn:escapeXml(sessionScope.role)}</small>
            </span>
            <a href="Logout.jsp" class="tb-logout">
                <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M15 17l5-5-5-5M20 12H9M12 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7"/></svg>
                Log out
            </a>
        </div>
    </div>
    <div class="tb-appbar">
        <div class="tb-app">
            <span class="tb-waffle"><i></i><i></i><i></i><i></i><i></i><i></i><i></i><i></i><i></i></span>
            <b>Website Admin</b>
        </div>
        <nav class="tb-nav">
            <a href="<c:url value='/admin/pages'/>" data-match="/pages,/index.jsp">
                <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9Z"/><path d="M14 3v6h6"/></svg>
                <span>Pages</span>
            </a>
            <a href="<c:url value='/admin/LatestNewsServlet'/>" data-match="/LatestNewsServlet,/latestNews.jsp">
                <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M4 4h13v16H6a2 2 0 0 1-2-2Z"/><path d="M17 8h3v10a2 2 0 0 1-2 2M8 8h5M8 12h5M8 16h3"/></svg>
                <span>Latest News</span>
            </a>
            <a href="<c:url value='/admin/upcoming-events'/>" data-match="/upcoming-events,/upcoming_events.jsp">
                <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M8 3v4M16 3v4M3 10h18"/></svg>
                <span>Upcoming Events</span>
            </a>
            <% if (canMove) { %>
            <a href="<c:url value='/admin/move-photos'/>" data-match="/admin/move-photos">
                <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M12 16V4M7 9l5-5 5 5"/><path d="M4 16v3a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-3"/></svg>
                <span>Photo Storage</span>
            </a>
            <% } %>
        </nav>
    </div>
</header>
<script>
    (function () {
        var path = window.location.pathname;
        document.querySelectorAll('.srs-topbar .tb-nav a').forEach(function (a) {
            var hit = (a.getAttribute('data-match') || '').split(',').some(function (m) { return m && path.indexOf(m) !== -1; });
            if (hit) a.classList.add('active');
        });
    })();
</script>
