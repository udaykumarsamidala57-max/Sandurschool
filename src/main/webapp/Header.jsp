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

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        nav .main-menu {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            background-color: #FAF8F7;
        }

        nav .main-menu > li {
            position: relative;
        }

        nav .main-menu > li > a {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 14px 23px;
            color: #000000;
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.2s ease;
            border-bottom: 3px solid transparent;
        }

        nav .main-menu > li.active-tab > a,
        nav .main-menu > li:hover > a {
            background-color: #FAF8F7;
            color: #612405;
            border-bottom: 3px solid #612405;
        }

        nav .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            min-width: 210px;
            background-color: #612405;
            list-style: none;
            margin: 0;
            padding: 0;
            border: none;
            border-top: 3px solid #612405;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            z-index: 1000;
        }

        nav .main-menu > li:hover .dropdown-menu {
            display: block;
        }

        nav .dropdown-menu li {
            border: none !important;
            background-color: #612405 !important;
        }

        nav .dropdown-menu li a {
            display: block;
            padding: 12px 18px;
            color: #ffffff;
            text-decoration: none;
            font-size: 14px;
            background-color: #612405;
            transition: color 0.2s ease, background-color 0.2s ease;
            border: none !important;
        }

        nav .dropdown-menu li:hover > a,
        nav .dropdown-menu li a:hover,
        nav .dropdown-menu li.active-child > a {
            background-color: #4a1b03 !important;
            color: #e8cfb8 !important;
        }
    </style>
</head>
<body>
    <header>
        <div class="top-header">
            <div class="logo-area">
                <img src="${pageContext.request.contextPath}/Home/logo.png" alt="Sandur Residential School Logo">
                <h1>Sandur Residential School</h1>
            </div>
            <div class="top-links">
                <a href="${pageContext.request.contextPath}/homepage?slug=calendar">Calendar</a>
                <a href="#">Quick Links</a>
                <a href="https://srs.myclassboard.com/">Portal Login</a>
                <a href="#" aria-label="Search"><i class="fa fa-search"></i></a>
            </div>
        </div>
        <div class="menu-toggle"><i class="fa fa-bars"></i></div>
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
                                    <i class="fa fa-angle-down" style="font-size:12px; margin-left:4px;"></i>
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