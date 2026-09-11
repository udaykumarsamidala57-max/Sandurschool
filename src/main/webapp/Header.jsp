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

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* Modern Design System Reset & Base Polish */
        header {
            padding-top: 0;
            width: 100%;
            position: relative;
            background-color: #ffffff;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        /* Top Brown Ribbon Styles */
        .top-ribbon {
            background-color: #612405; /* Original Brown */
            color: #ffffff;
            padding: 7px 35px;
            font-size: 12.5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .top-ribbon .ribbon-left {
            font-weight: 500;
            letter-spacing: 0.4px;
            opacity: 0.95;
        }

        .top-ribbon .ribbon-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .top-ribbon .ribbon-right a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            font-size: 12px;
            letter-spacing: 0.3px;
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
        }

        .top-ribbon .ribbon-right a:hover {
            color: #ffffff;
            opacity: 1;
        }

        .top-ribbon .ribbon-right a::after {
            content: '';
            position: absolute;
            width: 0;
            height: 1px;
            bottom: -2px;
            left: 0;
            background-color: #ffffff;
            transition: width 0.25s ease;
        }

        .top-ribbon .ribbon-right a:hover::after {
            width: 100%;
        }

        /* Top Branding Header - Reduced Top & Bottom Padding */
        .top-header {
            padding: 8px 35px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ffffff;
        }

        .top-header .logo-area {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .top-header .logo-area img {
            height: 104px;
            width: auto;
            object-fit: contain;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.06));
        }

        .top-header .logo-area h1 {
            font-family: 'Merriweather', serif;
            font-size: 32px;
            font-weight: 700;
            color: #612405;
            margin: 0;
            letter-spacing: -0.2px;
        }

        /* Top Header Action Links */
        .top-header .top-links {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .top-header .top-links a {
            color: #333333;
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .top-header .top-links a:hover {
            color: #612405;
        }

        .top-header .top-links a[aria-label="Search"] {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background-color: #f5f5f7;
            color: #444444;
            transition: all 0.2s ease;
        }

        .top-header .top-links a[aria-label="Search"]:hover {
            background-color: #612405;
            color: #ffffff;
            transform: scale(1.05);
        }

        /* Main Navigation Bar */
        nav {
            background-color: #FAF8F7;
            border-top: 1px solid #efebe8;
            border-bottom: 1px solid #e8e3de;
        }

        nav .main-menu {
            list-style: none;
            margin: 0;
            padding: 0 12px;
            display: flex;
            background-color: #FAF8F7;
        }

        nav .main-menu > li {
            position: relative;
        }

        nav .main-menu > li > a {
            display: flex;
            align-items: center;
            gap: 7px;
            padding: 15px 22px;
            color: #2c2c2c;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.2px;
            transition: all 0.2s ease;
            position: relative;
        }

        nav .main-menu > li > a i {
            font-size: 11px;
            transition: transform 0.2s ease;
            opacity: 0.7;
        }

        nav .main-menu > li.active-tab > a,
        nav .main-menu > li:hover > a {
            background-color: #ffffff;
            color: #612405;
        }

        nav .main-menu > li.active-tab > a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background-color: #612405;
        }

        nav .main-menu > li:hover > a i {
            transform: rotate(180deg);
            opacity: 1;
        }

        /* Enhanced Dropdown Menu */
        nav .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            min-width: 230px;
            background-color: #612405; /* Original Brown */
            list-style: none;
            margin: 0;
            padding: 8px 0;
            border: none;
            border-radius: 0 0 6px 6px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.18);
            z-index: 1000;
            opacity: 0;
            transform: translateY(6px);
            transition: opacity 0.2s ease, transform 0.2s ease;
        }

        nav .main-menu > li:hover .dropdown-menu {
            display: block;
            opacity: 1;
            transform: translateY(0);
        }

        nav .dropdown-menu li {
            border-bottom: none;
            background-color: #612405;
        }

        nav .dropdown-menu li a {
            display: block;
            padding: 11px 20px;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 500;
            background-color: #612405;
            transition: all 0.2s ease;
        }

        nav .dropdown-menu li:hover a,
        nav .dropdown-menu li.active-child a {
            background-color: rgba(255, 255, 255, 0.12);
            color: #ffffff;
            padding-left: 24px;
        }

        /* Responsive Mobile Adjustments */
        @media (max-width: 992px) {
            .top-ribbon {
                flex-direction: column;
                gap: 8px;
                padding: 8px 15px;
                text-align: center;
            }

            .top-header {
                flex-direction: column;
                gap: 15px;
                padding: 10px 15px;
                text-align: center;
            }

            .top-header .logo-area {
                flex-direction: column;
            }

            nav .main-menu {
                flex-wrap: wrap;
            }
        }
    </style>
</head>

<body>

    <header>
        <!-- Top Brown Ribbon -->
        <div class="top-ribbon">
            <div class="ribbon-left">
                Sandur Residential School | Affiliated to CISCE
            </div>
            <div class="ribbon-right">
                <a href="${pageContext.request.contextPath}/homepage?slug=admissions">Admissions</a>
                <a href="${pageContext.request.contextPath}/homepage?slug=Current job openings">Recruitment</a>
                <a href="${pageContext.request.contextPath}/homepage?slug=alumni">Alumni</a>
            </div>
        </div>

        <!-- Top Header Logo & Quick Actions -->
        <div class="top-header">
            <div class="logo-area">
                <img src="${pageContext.request.contextPath}/Home/logo.png" alt="Sandur Residential School Logo">
                <h1>Sandur Residential School</h1>
            </div>

            <div class="top-links">
                <a href="${pageContext.request.contextPath}/homepage?slug=calendar">Calendar</a>
                <a href="#">Quick Links</a>
                <a href="#">Portal Login</a>
                <a href="#" aria-label="Search"><i class="fa fa-search"></i></a>
            </div>
        </div>

        <div class="menu-toggle"><i class="fa fa-bars"></i></div>

        <!-- Main Navigation Bar -->
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
                                    <i class="fa fa-angle-down"></i>
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
    </header>

</body>
</html>