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
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        :root {
            --primary-brand: #5c1d06;
            --primary-hover: #421202;
            --accent-gold: #d4af37;
            --text-dark: #1e293b;
            --text-muted: #64748b;
            --bg-light: #f8fafc;
            --white: #ffffff;
            --transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            background-color: var(--bg-light);
            -webkit-font-smoothing: antialiased;
        }

        /* Top Utility Bar */
        .top-bar {
            background-color: var(--primary-brand);
            color: var(--white);
            padding: 4px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            font-weight: 100;
            letter-spacing: 0.2px;
        }

        .top-bar .school-affiliation {
            display: flex;
            align-items: center;
            gap: 8px;
            opacity: 0.9;
        }

        .top-bar .top-links {
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 12px;
             font-weight: 100;
        }

        .top-bar .top-links a {
            color: var(--white);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            opacity: 0.88;
            transition: var(--transition);
            font-size: 12px;
             font-weight: 100;
        }

        .top-bar .top-links a:hover {
            opacity: 1;
            color: var(--accent-gold);
        }

        .top-bar .btn-pill {
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 4px 14px;
            border-radius: 50px;
            background: rgba(255, 255, 255, 0.05);
        }

        .top-bar .btn-pill:hover {
            background-color: var(--accent-gold);
            color: var(--primary-brand) !important;
            border-color: var(--accent-gold);
        }

        /* Main Branding Header */
        .main-header {
            background-color: var(--white);
            padding: 16px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
        }

        .main-header .logo-area {
            display: flex;
            align-items: center;
        }

        .main-header .logo-area img {
            height: 75px;
            width: auto;
            object-fit: contain;
        }

        .menu-btn-toggle {
            display: none;
            background: transparent;
            border: 1px solid #cbd5e1;
            color: var(--text-dark);
            padding: 8px 14px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: var(--transition);
        }

        .menu-btn-toggle:hover {
            background-color: #f1f5f9;
        }

        /* Desktop Navigation Bar */
        .nav-wrapper {
            background-color: var(--white);
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 2px solid var(--accent-gold);
        }

        nav .main-menu {
            list-style: none;
            margin: 0;
            padding: 0 5%;
            display: flex;
            align-items: center;
        }

        nav .main-menu > li {
            position: relative;
        }

        nav .main-menu > li > a {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 16px 20px;
            color: var(--text-dark);
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: var(--transition);
            border-bottom: 3px solid transparent;
        }

        nav .main-menu > li.active-tab > a,
        nav .main-menu > li:hover > a {
            color: var(--primary-brand);
            border-bottom-color: var(--primary-brand);
            background-color: rgba(92, 29, 6, 0.03);
        }

        /* Dropdown Styling */
        nav .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            min-width: 230px;
            background-color: var(--primary-brand);
            list-style: none;
            margin: 0;
            padding: 8px 0;
            border-radius: 0 0 8px 8px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            animation: fadeIn 0.2s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        nav .main-menu > li:hover .dropdown-menu {
            display: block;
        }

        nav .dropdown-menu li a {
            display: block;
            padding: 10px 20px;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 500;
            transition: var(--transition);
        }

        nav .dropdown-menu li:hover > a,
        nav .dropdown-menu li.active-child > a {
            background-color: var(--primary-hover);
            color: var(--accent-gold);
            padding-left: 24px;
        }

        /* Responsive Breakpoints */
        @media (max-width: 992px) {
            .top-bar {
                flex-direction: column;
                gap: 8px;
                text-align: center;
            }

            .menu-btn-toggle {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .nav-wrapper {
                display: none;
                position: absolute;
                width: 100%;
                top: 100%;
                left: 0;
            }

            .nav-wrapper.open {
                display: block;
            }

            nav .main-menu {
                flex-direction: column;
                padding: 0;
            }

            nav .main-menu > li {
                width: 100%;
            }

            nav .main-menu > li > a {
                padding: 14px 20px;
                border-bottom: 1px solid #e2e8f0;
            }

            nav .dropdown-menu {
                position: static;
                box-shadow: none;
                border-radius: 0;
                background-color: #3d1304;
            }
        }
    </style>
</head>
<body>
    <header>
        <!-- Top Info/Utility Bar -->
        <div class="top-bar">
            <div class="school-affiliation">
                <i class="fa-solid fa-graduation-cap"></i>
                <span>Sandur Residential School | Affiliated to CISCE, New Delhi</span>
            </div>
            <div class="top-links">
                <a href="mailto:mail@sandurschool.edu"><i class="fa-regular fa-envelope"></i> mail@sandurschool.edu</a>
                <a href="${pageContext.request.contextPath}/homepage?slug=calendar"><i class="fa-regular fa-calendar-days"></i> Calendar</a>
                <a href="https://srs.myclassboard.com/" target="_blank"><i class="fa-solid fa-right-to-bracket"></i> Portal Login</a>
                <a href="#" class="btn-pill"><i class="fa-solid fa-briefcase"></i> Careers</a>
            </div>
        </div>

        <!-- Main Branding Header -->
        <div class="main-header">
            <div class="logo-area">
                <a href="${pageContext.request.contextPath}/">
                    <img src="${pageContext.request.contextPath}/Home/logo.png" alt="Sandur Residential School Logo">
                </a>
            </div>
            <button class="menu-btn-toggle" onclick="toggleNavigation()" type="button" aria-label="Toggle navigation">
                <span>MENU</span>
                <i class="fa-solid fa-bars"></i>
            </button>
        </div>

        <!-- Navigation Bar -->
        <div class="nav-wrapper" id="navWrapper">
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
    </header>

    <script>
        function toggleNavigation() {
            const navWrapper = document.getElementById('navWrapper');
            navWrapper.classList.toggle('open');
        }
    </script>
</body>
</html>