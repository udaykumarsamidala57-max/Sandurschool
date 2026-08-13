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
         SECTION CSS
    ====================================================== -->


    <!-- HERO -->

    <c:if test="${not empty pageData.sections}">

        <c:forEach var="sec" items="${pageData.sections}">

            <c:set
                var="secType"
                value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />


            <!-- HERO CSS -->

            <c:if test="${secType eq 'HERO'}">

                <link
                    rel="stylesheet"
                    href="${pageContext.request.contextPath}/css/hero.css">

            </c:if>


            <!-- DISTINCT CSS -->

            <c:if test="${secType eq 'DISTINCT'}">

                <link
                    rel="stylesheet"
                    href="${pageContext.request.contextPath}/css/distinct.css">

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


    <!-- =================================================
         TOP HEADER
    ================================================== -->

    <div class="top-header">


        <!-- =================================================
             LOGO AREA
        ================================================== -->

        <div class="logo-area">

            <img
                src="${pageContext.request.contextPath}/Home/logo.png"
                alt="Sandur Residential School Logo">

            <h1>
                Sandur Residential School
            </h1>

        </div>


        <!-- =================================================
             TOP LINKS
        ================================================== -->

        <div class="top-links">

            <a
                href="${pageContext.request.contextPath}/homepage?slug=calendar">
                Calendar
            </a>


            <a href="#">
                Quick Links
            </a>


            <a href="#">
                Portal Login
            </a>


            <a
                href="#"
                aria-label="Search">

                <i class="fa fa-search"></i>

            </a>

        </div>

    </div>


    <!-- =================================================
         MOBILE MENU BUTTON
    ================================================== -->

    <div class="menu-toggle">

        <i class="fa fa-bars"></i>

    </div>


    <!-- =================================================
         MAIN NAVIGATION
    ================================================== -->

    <nav>

        <ul class="main-menu">


            <!-- =================================================
                 CURRENT PAGE
            ================================================== -->

            <c:set
                var="currentSlug"
                value="${not empty param.slug
                        ? param.slug
                        : (not empty pageData.slug
                            ? pageData.slug
                            : 'home')}" />


            <!-- =================================================
                 HOME
            ================================================== -->

            <li
                class="${currentSlug eq 'home'
                        ? 'active-tab'
                        : ''}">

                <a
                    href="${pageContext.request.contextPath}/homepage?slug=home">

                    Home

                </a>

            </li>


            <!-- =================================================
                 DATABASE PAGES
            ================================================== -->

            <c:forEach
                var="pg"
                items="${pagesList}">


                <c:if test="${pg.slug ne 'home'}">


                    <li
                        class="${currentSlug eq pg.slug
                                ? 'active-tab'
                                : ''}">


                        <a
                            href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}">


                            <c:out value="${pg.title}" />


                            <!-- DROPDOWN INDICATOR -->

                            <c:if test="${not empty pg.children}">

                                <i
                                    class="fa fa-angle-down"
                                    style="font-size:12px;margin-left:4px;">
                                </i>

                            </c:if>


                        </a>


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


    <!-- =================================================
         DATABASE SECTIONS
         
         Each section is loaded from its own JSPF file.
    ================================================== -->


    <c:forEach
        var="sec"
        items="${pageData.sections}">


        <!-- =================================================
             NORMALIZE SECTION TYPE
        ================================================== -->

        <c:set
            var="sType"
            value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />



        <!-- =================================================
             HERO SECTION
        ================================================== -->

        <c:if test="${sType eq 'HERO'}">

            <%@ include file="views/sections/hero.jspf" %>

        </c:if>
        
         <c:if test="${sType eq 'DISTINCT'}">

            <%@ include file="views/sections/distinct.jspf" %>

        </c:if>



     

    </c:forEach>


</main>



<!-- =====================================================
     MOBILE MENU JAVASCRIPT
====================================================== -->

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



<!-- =====================================================
     SECTION JAVASCRIPT
====================================================== -->


<!-- HERO JS -->

<script
    src="${pageContext.request.contextPath}/js/hero.js">
</script>


<!-- DISTINCT JS -->

<script
    src="${pageContext.request.contextPath}/js/distinct.js">
</script>



</body>

</html>