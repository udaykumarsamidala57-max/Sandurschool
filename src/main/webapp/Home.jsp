<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    isELIgnored="false" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- =====================================================
         PAGE TITLE
    ====================================================== -->

    <title>
        <c:out
            value="${not empty pageData.title
                    ? pageData.title
                    : 'Sandur Residential School'}" />
    </title>

    <!-- =====================================================
         FONT AWESOME
    ====================================================== -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- =====================================================
         GOOGLE FONTS
    ====================================================== -->

    <link
        href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap"
        rel="stylesheet">

    <!-- =====================================================
         GLOBAL CSS
    ====================================================== -->

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/style.css">

    <!-- =====================================================
         SUB-NAVIGATION DROPDOWN STYLING
    ====================================================== -->

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
        padding: 14px 22px;
        color: #000000;
        text-decoration: none;
        font-size: 15px;
        font-weight: 500;
        transition: background-color 0.2s ease;
    }

    /* MAIN MENU HOVER */
    nav .main-menu > li.active-tab > a,
    nav .main-menu > li:hover > a {
        background-color: #FAF8F7;
        color: #000000;
    }


    /* =====================================================
       DROPDOWN MENU
    ===================================================== */

    nav .dropdown-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        min-width: 210px;

        /* ALWAYS BROWN */
        background-color: #612405;

        list-style: none;
        margin: 0;
        padding: 0;

        /* BORDER LINE REMOVED */
        border: none;

        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);

        z-index: 1000;
    }

    /* SHOW DROPDOWN */
    nav .main-menu > li:hover .dropdown-menu {
        display: block;
    }


    /* DROPDOWN ITEMS */
    nav .dropdown-menu li {
        border-bottom: none; /* REMOVED INTERNAL SEPARATOR LINES */
        background-color: #612405;
    }


    /* DROPDOWN LINKS */
    nav .dropdown-menu li a {
        display: block;
        padding: 12px 18px;

        /* ALWAYS WHITE */
        color: #ffffff;

        text-decoration: none;
        font-size: 14px;

        background-color: #612405;

        transition: none;
    }


    /* =====================================================
       NO HOVER COLOR CHANGE
    ===================================================== */

    nav .dropdown-menu li:hover,
    nav .dropdown-menu li:hover a,
    nav .dropdown-menu li a:hover,
    nav .dropdown-menu li.active-child,
    nav .dropdown-menu li.active-child a {
        background-color: #612405;
        color: #ffffff;
    }

</style>

    <!-- =====================================================
         DYNAMIC SECTION CSS
    ====================================================== -->

    <c:if test="${not empty pageData.sections}">
        <c:forEach var="sec" items="${pageData.sections}">

            <c:set
                var="secType"
                value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

            <c:if test="${secType eq 'HERO'}">
                <link
                    rel="stylesheet"
                    href="${pageContext.request.contextPath}/css/hero.css">
            </c:if>

            <c:if test="${secType eq 'DISTINCT'}">
                <link
                    rel="stylesheet"
                    href="${pageContext.request.contextPath}/css/distinct.css">
            </c:if>

            <c:if test="${secType eq 'PERSON_DETAILS'}">
                <link
                    rel="stylesheet"
                    href="${pageContext.request.contextPath}/css/person-details.css">
            </c:if>

        </c:forEach>
    </c:if>

</head>

<body>

<!-- =====================================================
     TOP STRIP
====================================================== -->

<div class="top-strip"></div>

<!-- =====================================================
     HEADER
====================================================== -->

<header>

    <div class="top-header">

        <div class="logo-area">
            <img
                src="${pageContext.request.contextPath}/Home/logo.png"
                alt="Sandur Residential School Logo">
            <h1>Sandur Residential School</h1>
        </div>

        <div class="top-links">
            <a href="${pageContext.request.contextPath}/homepage?slug=calendar">
                Calendar
            </a>
            <a href="#">Quick Links</a>
            <a href="#">Portal Login</a>
            <a href="#" aria-label="Search">
                <i class="fa fa-search"></i>
            </a>
        </div>

    </div>

    <div class="menu-toggle">
        <i class="fa fa-bars"></i>
    </div>

    <!-- MAIN NAVIGATION WITH SUB-DROPDOWNS -->
    <nav>
        <ul class="main-menu">

            <c:set
                var="currentSlug"
                value="${not empty param.slug
                        ? param.slug
                        : (not empty pageData.slug
                            ? pageData.slug
                            : 'home')}" />

            <!-- HOME LINK -->
            <li class="${currentSlug eq 'home' ? 'active-tab' : ''}">
                <a href="${pageContext.request.contextPath}/homepage?slug=home">
                    Home
                </a>
            </li>

            <!-- PARENT & CHILD PAGES -->
            <c:forEach var="pg" items="${pagesList}">
                <c:if test="${pg.slug ne 'home'}">

                    <!-- CHECK IF CURRENT ACTIVE SLUG IS PARENT OR CHILD -->
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

                        <!-- SUB-NAVIGATION DROPDOWN -->
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

<!-- =====================================================
     MAIN CONTENT
====================================================== -->

<main class="main-content">

    <c:forEach var="sec" items="${pageData.sections}">

        <c:set
            var="sType"
            value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

        <c:if test="${sType eq 'HERO'}">
            <%@ include file="views/sections/hero.jspf" %>
        </c:if>

        <c:if test="${sType eq 'DISTINCT'}">
            <%@ include file="views/sections/distinct.jspf" %>
        </c:if>

        <c:if test="${sType eq 'PERSON_DETAILS'}">
            <%@ include file="views/sections/person-details.jspf" %>
        </c:if>

    </c:forEach>

</main>

<!-- =====================================================
     SCRIPTS
====================================================== -->

<script>
document.addEventListener("DOMContentLoaded", function () {
    const menuToggle = document.querySelector(".menu-toggle");
    const nav = document.querySelector("nav");

    if (menuToggle && nav) {
        menuToggle.addEventListener("click", function () {
            nav.classList.toggle("active");
        });
    }
});
</script>

<script src="${pageContext.request.contextPath}/js/hero.js"></script>
<script src="${pageContext.request.contextPath}/js/distinct.js"></script>

</body>

</html>