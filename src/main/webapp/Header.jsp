<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:out value="${not empty pageData.title ? pageData.title : 'Sandur Residential School'}" />
    </title>

    <link rel="icon" href="${pageContext.request.contextPath}/Home/logo.png?v=10" type="image/png">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/Home/logo.png?v=10" type="image/png">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/Home/logo.png?v=10">

    <!-- Fonts & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        :root {
            --primary-brand: #5c1d06;
            --primary-hover: #421202;
            --accent-gold: #d4af37;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --bg-light: #f8fafc;
            --white: #ffffff;
            --border-color: #e2e8f0;
            --transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        body {
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-dark);
            background-color: var(--bg-light);
            -webkit-font-smoothing: antialiased;
        }

        /* Fixed & Optimized Top Utility Ribbon (Desktop) */
        .top-bar {
            background-color: var(--primary-brand);
            color: var(--white);
            padding: 8px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12.5px;
            font-weight: 500;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .top-bar .school-affiliation {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12.5px;
            white-space: nowrap;
        }

        .top-bar .school-affiliation i {
            color: var(--accent-gold);
        }

        .top-bar .top-links {
            display: flex;
            align-items: center;
            gap: 20px;
            font-size: 12.5px;
        }

        .top-bar .top-links a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12.5px;
            transition: var(--transition);
        }

        .top-bar .top-links a:hover {
            color: var(--accent-gold);
        }

        .top-bar .btn-pill {
            border: 1px solid rgba(212, 175, 55, 0.5);
            padding: 3px 12px;
            border-radius: 50px;
            background: rgba(255, 255, 255, 0.08);
            color: var(--accent-gold) !important;
        }

        .top-bar .btn-pill:hover {
            background-color: var(--accent-gold);
            color: var(--primary-brand) !important;
        }

        /* Main Desktop Header */
        .main-header {
            background-color: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(8px);
            padding: 0 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid var(--accent-gold);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .main-header .logo-area {
            display: flex;
            align-items: center;
            padding: 10px 0;
        }

        .main-header .logo-area img {
            height: 120px;
            width: auto;
            object-fit: contain;
        }

        /* Desktop Navigation Menu */
        .desktop-nav {
            display: flex;
            align-items: center;
        }

        .desktop-nav .main-menu {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .desktop-nav .main-menu > li {
            position: relative;
        }

        .desktop-nav .main-menu > li > a {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 22px 14px;
            color: var(--text-dark);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: var(--transition);
        }

        .desktop-nav .main-menu > li.active-tab > a,
        .desktop-nav .main-menu > li:hover > a {
            color: var(--primary-brand);
            background-color: rgba(92, 29, 6, 0.04);
        }

        /* Brown Background & White Text Dropdown Styling */
        .desktop-nav .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            min-width: 220px;
            background-color: var(--primary-brand);
            list-style: none;
            margin: 0;
            padding: 8px 0;
            border-radius: 0 0 8px 8px;
            border: 1px solid var(--primary-hover);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            z-index: 1000;
        }

        .desktop-nav .main-menu > li:hover .dropdown-menu {
            display: block;
        }

        .desktop-nav .dropdown-menu li a {
            display: block;
            padding: 10px 18px;
            color: #ffffff;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: var(--transition);
            background-color: var(--primary-brand);
        }

        .desktop-nav .dropdown-menu li:hover > a,
        .desktop-nav .dropdown-menu li.active-child > a {
            background-color: var(--primary-hover);
            color: var(--accent-gold);
            font-weight: 700;
            padding-left: 22px;
        }

        /* Mobile Controls */
        .menu-btn-toggle {
            display: none;
            background: transparent;
            border: 1px solid var(--border-color);
            color: var(--text-dark);
            padding: 8px 12px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 13px;
            cursor: pointer;
        }

        /* Mobile Drawer Component */
        .mobile-drawer-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background-color: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(4px);
            z-index: 1001;
            opacity: 0;
            visibility: hidden;
            transition: var(--transition);
        }

        .mobile-drawer-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .mobile-drawer {
            position: fixed;
            top: 0;
            right: -320px;
            width: 300px;
            height: 100vh;
            background-color: var(--white);
            z-index: 1002;
            box-shadow: -5px 0 25px rgba(0, 0, 0, 0.15);
            transition: right 0.35s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex;
            flex-direction: column;
        }

        .mobile-drawer.open {
            right: 0;
        }

        .drawer-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: var(--bg-light);
        }

        .drawer-header span {
            font-weight: 700;
            color: var(--primary-brand);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .drawer-close-btn {
            background: transparent;
            border: none;
            font-size: 18px;
            color: var(--text-muted);
            cursor: pointer;
        }

        .drawer-body {
            padding: 10px 0;
            overflow-y: auto;
            flex: 1;
        }

        .mobile-menu {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .mobile-menu-item {
            border-bottom: 1px solid #f1f5f9;
        }

        .mobile-menu-link {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 20px;
            color: var(--text-dark);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .mobile-menu-link.active-tab {
            color: var(--primary-brand);
            background-color: rgba(92, 29, 6, 0.03);
        }

        /* Brown Background & White Text Mobile Submenu Styling */
        .mobile-submenu {
            display: none;
            list-style: none;
            margin: 0;
            padding: 0;
            background-color: var(--primary-brand);
        }

        .mobile-menu-item.expanded .mobile-submenu {
            display: block;
        }

        .mobile-submenu li a {
            display: block;
            padding: 10px 20px 10px 32px;
            color: #ffffff;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            background-color: var(--primary-brand);
        }

        .mobile-submenu li:hover a,
        .mobile-submenu li.active-child a {
            color: var(--accent-gold);
            font-weight: 700;
            background-color: var(--primary-hover);
        }

        .submenu-toggle {
            background: transparent;
            border: none;
            padding: 8px;
            color: var(--text-muted);
            cursor: pointer;
        }

        /* Mobile Breakpoint Adjustments */
        @media (max-width: 992px) {
            .top-bar {
                padding: 6px 4%;
                font-size: 11px;
            }

            .top-bar .school-affiliation span {
                display: none;
            }

            .top-bar .school-affiliation::after {
                content: "Sandur Residential School";
            }

            .top-bar .top-links a span {
                display: none;
            }

            .desktop-nav {
                display: none;
            }

            .menu-btn-toggle {
                display: flex;
                align-items: center;
                gap: 6px;
            }
        }
    </style>
</head>
<body>
    <header>
        <!-- Desktop/Tablet Top Info Ribbon -->
        <div class="top-bar">
            <div class="school-affiliation">
                <i class="fa-solid fa-graduation-cap"></i>
                <span>Sandur Residential School | Affiliated to CISCE, New Delhi</span>
            </div>
            <div class="top-links">
                <a href="mailto:mail@sandurschool.edu"><i class="fa-regular fa-envelope"></i> <span>mail@sandurschool.edu</span></a>
                <a href="${pageContext.request.contextPath}/homepage?slug=calendar"><i class="fa-regular fa-calendar-days"></i> <span>Calendar</span></a>
                <a href="https://srs.myclassboard.com/" target="_blank"><i class="fa-solid fa-right-to-bracket"></i> <span>Portal Login</span></a>
                <a href="#" class="btn-pill"><i class="fa-solid fa-briefcase"></i> <span>Careers</span></a>
            </div>
        </div>

        <!-- Main Header -->
        <div class="main-header">
            <div class="logo-area">
                <a href="${pageContext.request.contextPath}/homepage">
                    <img src="${pageContext.request.contextPath}/Home/logo.png" alt="Sandur Residential School Logo">
                </a>
            </div>

            <!-- Standard Web Navigation -->
            <div class="desktop-nav">
                <nav>
                    <ul class="main-menu">
                        <c:set var="currentSlug" value="${not empty param.slug ? param.slug : (not empty pageData.slug ? pageData.slug : 'home')}" />
                        <c:forEach var="pg" items="${pagesList}">
                            <c:if test="${pg.slug ne 'home'}">
                                <c:set var="isChildActive" value="false" />
                                <c:if test="${not empty pg.children}">
                                    <c:forEach var="child" items="${pg.children}">
                                        <c:if test="${child.slug eq currentSlug}">
                                            <c:set var="isChildActive" value="true" />
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <li class="${(currentSlug eq pg.slug or isChildActive) ? 'active-tab' : ''}">
                                    <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}">
                                        <c:out value="${pg.title}" />
                                        <c:if test="${not empty pg.children}">
                                            <i class="fa-solid fa-chevron-down" style="font-size:10px; margin-left:4px;"></i>
                                        </c:if>
                                    </a>
                                    <c:if test="${not empty pg.children}">
                                        <ul class="dropdown-menu">
                                            <c:forEach var="child" items="${pg.children}">
                                                <li class="${currentSlug eq child.slug ? 'active-child' : ''}">
                                                    <a href="${pageContext.request.contextPath}/homepage?slug=${child.slug}">
                                                        <c:out value="${child.title}" />
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:if>
                                </li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </nav>
            </div>

            <!-- Mobile Drawer Button -->
            <button class="menu-btn-toggle" onclick="toggleMobileDrawer()" type="button" aria-label="Toggle navigation">
                <span>MENU</span>
                <i class="fa-solid fa-bars"></i>
            </button>
        </div>
    </header>

    <!-- Mobile Navigation Drawer Structure -->
    <div class="mobile-drawer-overlay" id="drawerOverlay" onclick="toggleMobileDrawer()"></div>
    <aside class="mobile-drawer" id="mobileDrawer">
        <div class="drawer-header">
            <span>Navigation</span>
            <button class="drawer-close-btn" onclick="toggleMobileDrawer()" type="button" aria-label="Close menu">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        <div class="drawer-body">
            <ul class="mobile-menu">
                <c:forEach var="pg" items="${pagesList}">
                    <c:if test="${pg.slug ne 'home'}">
                        <c:set var="isChildActive" value="false" />
                        <c:if test="${not empty pg.children}">
                            <c:forEach var="child" items="${pg.children}">
                                <c:if test="${child.slug eq currentSlug}">
                                    <c:set var="isChildActive" value="true" />
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <li class="mobile-menu-item ${isChildActive ? 'expanded' : ''}">
                            <div style="display: flex; align-items: center; justify-content: space-between;">
                                <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}" 
                                   class="mobile-menu-link ${(currentSlug eq pg.slug or isChildActive) ? 'active-tab' : ''}" style="flex:1;">
                                    <c:out value="${pg.title}" />
                                </a>
                                <c:if test="${not empty pg.children}">
                                    <button type="button" class="submenu-toggle" onclick="toggleSubmenu(this)">
                                        <i class="fa-solid fa-chevron-down"></i>
                                    </button>
                                </c:if>
                            </div>

                            <c:if test="${not empty pg.children}">
                                <ul class="mobile-submenu">
                                    <c:forEach var="child" items="${pg.children}">
                                        <li class="${currentSlug eq child.slug ? 'active-child' : ''}">
                                            <a href="${pageContext.request.contextPath}/homepage?slug=${child.slug}">
                                                <c:out value="${child.title}" />
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                        </li>
                    </c:if>
                </c:forEach>
            </ul>
        </div>
    </aside>

    <script>
        function toggleMobileDrawer() {
            const drawer = document.getElementById('mobileDrawer');
            const overlay = document.getElementById('drawerOverlay');
            drawer.classList.toggle('open');
            overlay.classList.toggle('active');
        }

        function toggleSubmenu(button) {
            const menuItem = button.closest('.mobile-menu-item');
            menuItem.classList.toggle('expanded');
        }
    </script>
</body>
</html>