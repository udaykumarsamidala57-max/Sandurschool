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
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Dynamic Section Stylesheets -->
    <c:if test="${not empty pageData.sections}">
        <c:forEach var="sec" items="${pageData.sections}">
            <c:set var="secType" value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

            <c:if test="${secType eq 'HERO'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero.css"></c:if>
            <c:if test="${secType eq 'DISTINCT'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/distinct.css"></c:if>
            <c:if test="${secType eq 'PERSON_DETAILS'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/person-details.css"></c:if>
            <c:if test="${secType eq 'DESC'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/desc.css"></c:if>
            <c:if test="${secType eq 'DESC2'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/desc2.css"></c:if>
            <c:if test="${secType eq 'DESC2'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/desc3.css"></c:if>
            <c:if test="${secType eq 'DESC3'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/desc.css"></c:if>
        </c:forEach>
    </c:if>

    <style>
        /* Header Nav Overlay Rules */
        nav .main-menu { list-style: none; margin: 0; padding: 0; display: flex; background-color: #FAF8F7; }
        nav .main-menu > li { position: relative; }
        nav .main-menu > li > a { display: flex; align-items: center; gap: 6px; padding: 14px 23px; color: #000000; text-decoration: none; font-size: 15px; font-weight: 500; transition: background-color 0.2s ease; }
        nav .main-menu > li.active-tab > a, nav .main-menu > li:hover > a { background-color: #FAF8F7; color: #000000; }
        nav .dropdown-menu { display: none; position: absolute; top: 100%; left: 0; min-width: 210px; background-color: #612405; list-style: none; margin: 0; padding: 0; border: none; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); z-index: 1000; }
        nav .main-menu > li:hover .dropdown-menu { display: block; }
        nav .dropdown-menu li { border-bottom: none; background-color: #612405; }
        nav .dropdown-menu li a { display: block; padding: 12px 18px; color: #ffffff; text-decoration: none; font-size: 14px; background-color: #612405; transition: none; }
        nav .dropdown-menu li:hover, nav .dropdown-menu li:hover a, nav .dropdown-menu li a:hover, nav .dropdown-menu li.active-child, nav .dropdown-menu li.active-child a { background-color: #612405; color: #ffffff; }

        /* Wide Layout Container */
        .page-body-container {
            max-width: 1400px;
            margin: 40px auto 70px;
            padding: 0 30px;
            display: flex;
            gap: 50px;
            align-items: flex-start;
            box-sizing: border-box;
        }

        .primary-content-area {
            flex: 1;
            min-width: 0;
        }

        /* Fixed Right Sidebar Styling */
        .sidebar-nav-box {
            width: 260px;
            flex-shrink: 0;
            position: sticky;
            top: 40px;
            margin-top: 10px;
            background: #ffffff;
            border: 1px solid #e2dcd5;
            padding: 8px 0;
            box-sizing: border-box;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
        }

        .sidebar-nav-box ul {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .sidebar-nav-box li {
            border-bottom: 1px solid #f0eae5;
        }

        .sidebar-nav-box li:last-child {
            border-bottom: none;
        }

        .sidebar-nav-box a {
            display: block;
            padding: 14px 20px;
            color: #4a2b0b;
            text-decoration: none;
            font-family: 'Merriweather', serif;
            font-size: 14px;
            font-weight: 400;
            line-height: 1.4;
            transition: all 0.2s ease;
        }

        .sidebar-nav-box li.active a,
        .sidebar-nav-box a:hover {
            font-weight: 700;
            color: #4a2b0b;
        }

        .sidebar-nav-box li.active a {
            text-decoration: underline;
            text-underline-offset: 5px;
            text-decoration-thickness: 2px;
        }

        @media (max-width: 1024px) {
            .page-body-container {
                flex-direction: column-reverse;
                gap: 30px;
                padding: 0 20px;
            }

            .sidebar-nav-box {
                width: 100%;
                position: static;
                margin-top: 0;
            }
        }
    </style>
</head>

<body>
<%@ include file="Header.jsp" %>

    <main class="main-content">
        <!-- Step 1: Render full-width HERO section standalone at the top -->
        <c:forEach var="sec" items="${pageData.sections}">
            <c:set var="sType" value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />
            <c:if test="${sType eq 'HERO'}">
                <%@ include file="views/sections/hero.jspf" %>
            </c:if>
        </c:forEach>

        <!-- Normalize slug to lowercase for reliable comparison -->
        <c:set var="currentSlug" value="${fn:toLowerCase(fn:trim(not empty param.slug ? param.slug : pageData.slug))}" />

        <!-- Identify current section's sub-navigation items dynamically from pagesList -->
        <c:set var="dynamicSubMenuItems" value="${null}" />
        <c:forEach var="pg" items="${pagesList}">
            <c:set var="parentSlug" value="${fn:toLowerCase(fn:trim(pg.slug))}" />
            <c:set var="isParentOrChild" value="false" />

            <c:if test="${parentSlug eq currentSlug}">
                <c:set var="isParentOrChild" value="true" />
            </c:if>

            <c:if test="${not empty pg.children}">
                <c:forEach var="child" items="${pg.children}">
                    <c:set var="childSlug" value="${fn:toLowerCase(fn:trim(child.slug))}" />
                    <c:if test="${childSlug eq currentSlug}">
                        <c:set var="isParentOrChild" value="true" />
                    </c:if>
                </c:forEach>
            </c:if>

            <c:if test="${isParentOrChild and not empty pg.children}">
                <c:set var="dynamicSubMenuItems" value="${pg.children}" />
            </c:if>
        </c:forEach>

        <!-- Step 2: Content layout wrapper for all remaining sections + Dynamic Sidebar -->
        <div class="page-body-container">
            
            <!-- Left Main Body Content -->
            <div class="primary-content-area">
                <c:forEach var="sec" items="${pageData.sections}">
                    <c:set var="sType" value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

                    <c:if test="${sType eq 'DISTINCT'}"><%@ include file="views/sections/distinct.jspf" %></c:if>
                    <c:if test="${sType eq 'PERSON_DETAILS'}"><%@ include file="views/sections/person-details.jspf" %></c:if>
                    <c:if test="${sType eq 'DESC'}"><%@ include file="views/sections/desc.jspf" %></c:if>
                    <c:if test="${sType eq 'DESC2'}"><%@ include file="views/sections/desc2.jspf" %></c:if>
                    <c:if test="${sType eq 'DESC3'}"><%@ include file="views/sections/desc3.jspf" %></c:if>
                </c:forEach>
            </div>

            <!-- Right Dynamic Subnavigation Sidebar (Rendered ONLY if current section has active dynamic sub-items) -->
            <c:if test="${currentSlug ne 'about' and currentSlug ne 'lag' and currentSlug ne 'infrastructure' and currentSlug ne 'home' and not empty dynamicSubMenuItems}">
                <aside class="sidebar-nav-box">
                    <ul>
                        <c:forEach var="subItem" items="${dynamicSubMenuItems}">
                            <c:set var="itemSlug" value="${fn:toLowerCase(fn:trim(subItem.slug))}" />
                            <li class="${currentSlug eq itemSlug ? 'active' : ''}">
                                <a href="${pageContext.request.contextPath}/homepage?slug=${subItem.slug}">
                                    <c:out value="${subItem.title}" />
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </aside>
            </c:if>

        </div>
    </main>

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