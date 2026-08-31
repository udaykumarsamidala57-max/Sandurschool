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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        <c:out value="${not empty pageData.title ? pageData.title : 'Sandur Residential School'}" />
    </title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/side_design.css">

    <c:if test="${not empty pageData.sections}">

        <c:forEach var="sec" items="${pageData.sections}">

            <c:set var="secType"
                   value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

            <c:if test="${secType eq 'HERO'}">
                <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/hero.css">
            </c:if>

            <c:if test="${secType eq 'DISTINCT'}">
                <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/distinct.css">
            </c:if>

            <c:if test="${secType eq 'DISTINCT2'}">
                <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/distinct2.css">
            </c:if>

            <c:if test="${secType eq 'PERSON_DETAILS'}">
                <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/person-details.css">
            </c:if>

            <c:if test="${secType eq 'DESC'}">
                <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/desc.css">
            </c:if>

            <c:if test="${secType eq 'DESC2'}">
                <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/desc3.css">
            </c:if>

            <c:if test="${secType eq 'DESC3'}">
                <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/desc.css">
            </c:if>

            <c:if test="${secType eq 'SIDE_DESIGN'}">
                <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/side_design.css">
            </c:if>

        </c:forEach>

    </c:if>

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

            transition: background-color 0.2s ease;
        }


        nav .main-menu > li.active-tab > a,
        nav .main-menu > li:hover > a {

            background-color: #FAF8F7;

            color: #000000;
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

            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);

            z-index: 10000;
        }


        nav .main-menu > li:hover .dropdown-menu {
            display: block;
        }


        nav .dropdown-menu li {

            border-bottom: none;

            background-color: #612405;
        }


        nav .dropdown-menu li a {

            display: block;

            padding: 12px 18px;

            color: #ffffff;

            text-decoration: none;

            font-size: 14px;

            background-color: #612405;

            transition: none;
        }


        nav .dropdown-menu li:hover,
        nav .dropdown-menu li:hover a,
        nav .dropdown-menu li a:hover,
        nav .dropdown-menu li.active-child,
        nav .dropdown-menu li.active-child a {

            background-color: #612405;

            color: #ffffff;
        }

        .main-content {
            width: 100%;
            position: relative;
        }

        .page-body-container {

            width: 100%;

            max-width: 1400px;

            margin: 40px auto 70px;

            padding: 0 30px;

            display: flex;

            align-items: flex-start;

            gap: 50px;

            box-sizing: border-box;
        }

        .page-body-container.no-side-design {
            display: block;
            max-width: 1400px;
        }

        .page-body-container.no-side-design .primary-content-area {
            width: 100%;
            max-width: 100%;
            flex: none;
        }

        .page-body-container.no-side-design .right-side-column {
            display: none;
        }

        .primary-content-area {

            flex: 1;

            min-width: 0;

            width: 100%;

            box-sizing: border-box;
        }

        .right-side-column {

            width: 280px;

            min-width: 280px;

            flex: 0 0 280px;

            display: flex;

            flex-direction: column;

            align-items: stretch;

            gap: 25px;

            box-sizing: border-box;

            position: relative;

            z-index: 5;
        }

        .sidebar-nav-box {

            width: 100%;

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

            box-sizing: border-box;
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

        .right-side-column .side-design {

            width: 100%;

            max-width: 100%;

            box-sizing: border-box;

            position: relative;

            display: block;

            margin: 0;

            padding: 0;
        }

        .right-side-column .side-design *,
        .right-side-column .side-design {

            box-sizing: border-box;
        }

        @media (max-width: 1024px) {

            .page-body-container {

                flex-direction: column;

                gap: 30px;

                padding: 0 20px;
            }


            .primary-content-area {

                width: 100%;

                order: 1;
            }


            .right-side-column {

                width: 100%;

                min-width: 0;

                flex: none;

                order: 2;

                align-items: center;
            }


            .sidebar-nav-box {

                width: 100%;

                position: static;
            }


            .right-side-column .side-design {

                width: 320px;

                max-width: 100%;
            }
        }

        @media (max-width: 600px) {

            .page-body-container {

                margin-top: 25px;

                margin-bottom: 40px;

                padding: 0 12px;

                gap: 25px;
            }


            .right-side-column {

                width: 100%;

                min-width: 0;
            }


            .right-side-column .side-design {

                width: 100%;

                max-width: 340px;
            }
        }

        @media (max-width: 400px) {

            .page-body-container {

                padding: 0 10px;
            }


            .right-side-column .side-design {

                max-width: 100%;
            }
        }

    </style>

</head>


<body>

    <%@ include file="Header.jsp" %>

    <main class="main-content">

        <c:forEach var="sec" items="${pageData.sections}">

            <c:set var="sType"
                   value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />


            <c:if test="${sType eq 'HERO'}">

                <%@ include file="views/sections/hero.jspf" %>

            </c:if>

        </c:forEach>

        <c:set var="currentSlug"
                 value="${fn:toLowerCase(fn:trim(not empty param.slug ? param.slug : pageData.slug))}" />

        <c:set var="dynamicSubMenuItems"
                 value="${null}" />


        <c:forEach var="pg" items="${pagesList}">

            <c:set var="parentSlug"
                     value="${fn:toLowerCase(fn:trim(pg.slug))}" />


            <c:set var="isParentOrChild"
                     value="false" />

            <c:if test="${parentSlug eq currentSlug}">

                <c:set var="isParentOrChild"
                         value="true" />

            </c:if>

            <c:if test="${not empty pg.children}">

                <c:forEach var="child" items="${pg.children}">

                    <c:set var="childSlug"
                             value="${fn:toLowerCase(fn:trim(child.slug))}" />


                    <c:if test="${childSlug eq currentSlug}">

                        <c:set var="isParentOrChild"
                                 value="true" />

                    </c:if>

                </c:forEach>

            </c:if>

            <c:if test="${isParentOrChild and not empty pg.children}">

                <c:set var="dynamicSubMenuItems"
                         value="${pg.children}" />

            </c:if>

        </c:forEach>

        <c:set var="hasSideDesign" value="false" />

        <c:if test="${not empty pageData.sections}">
            <c:forEach var="sec" items="${pageData.sections}">
                <c:set var="sTypeCheck" value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />
                <c:if test="${sTypeCheck eq 'SIDE_DESIGN'}">
                    <c:set var="hasSideDesign" value="true" />
                </c:if>
            </c:forEach>
        </c:if>

        <c:set var="showSidebarNav" value="false" />
        <c:if test="${currentSlug ne 'about'
                      and currentSlug ne 'lag'
                      and currentSlug ne 'infrastructure'
                      and currentSlug ne 'home'
                      and not empty dynamicSubMenuItems}">
            <c:set var="showSidebarNav" value="true" />
        </c:if>

        <div class="page-body-container ${(!hasSideDesign and !showSidebarNav) ? 'no-side-design' : ''}">

            <div class="primary-content-area">


                <c:forEach var="sec"
                           items="${pageData.sections}">


                    <c:set var="sType"
                             value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

                    <c:if test="${sType eq 'DISTINCT'}">

                        <%@ include file="views/sections/distinct.jspf" %>

                    </c:if>

                    <c:if test="${sType eq 'DISTINCT2'}">

                        <%@ include file="views/sections/distinct2.jspf" %>

                    </c:if>

                    <c:if test="${sType eq 'PERSON_DETAILS'}">

                        <%@ include file="views/sections/person-details.jspf" %>

                    </c:if>

                    <c:if test="${sType eq 'DESC'}">

                        <%@ include file="views/sections/desc.jspf" %>

                    </c:if>

                    <c:if test="${sType eq 'DESC2'}">

                        <%@ include file="views/sections/desc2.jspf" %>

                    </c:if>

                    <c:if test="${sType eq 'DESC3'}">

                        <%@ include file="views/sections/desc3.jspf" %>

                    </c:if>


                </c:forEach>


            </div>

            <c:if test="${hasSideDesign or showSidebarNav}">

                <aside class="right-side-column">

                    <c:if test="${showSidebarNav}">


                        <div class="sidebar-nav-box">

                            <ul>

                                <c:forEach var="subItem"
                                           items="${dynamicSubMenuItems}">


                                    <c:set var="itemSlug"
                                             value="${fn:toLowerCase(fn:trim(subItem.slug))}" />


                                    <li class="${currentSlug eq itemSlug ? 'active' : ''}">


                                        <a href="${pageContext.request.contextPath}/homepage?slug=${subItem.slug}">

                                            <c:out value="${subItem.title}" />

                                        </a>


                                    </li>


                                </c:forEach>

                            </ul>

                        </div>


                    </c:if>

                    <c:forEach var="sec" items="${pageData.sections}">

                        <c:set var="sType" value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

                        <c:if test="${sType eq 'SIDE_DESIGN'}">

                            <div class="side-design-wrapper">

                                <%@ include file="views/sections/side_design.jspf" %>

                            </div>

                        </c:if>

                    </c:forEach>


                </aside>

            </c:if>


        </div>


    </main>

    <script>

        document.addEventListener("DOMContentLoaded", function () {

            const menuToggle =
                document.querySelector(".menu-toggle");

            const nav =
                document.querySelector("nav");


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
 <%@ include file="Footer.jsp" %>
</html>