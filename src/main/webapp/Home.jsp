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

    <link rel="stylesheet"
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

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">


    <!-- =====================================================
         DETECT SECTION TYPES
    ====================================================== -->

    <c:set var="hasHero" value="false" />
    <c:set var="hasContent" value="false" />
    <c:set var="hasGallery" value="false" />


    <c:forEach var="sec"
               items="${pageData.sections}">

        <c:choose>

            <c:when test="${fn:toUpperCase(sec.sectionType) eq 'HERO'}">

                <c:set var="hasHero" value="true" />

            </c:when>


            <c:when test="${fn:toUpperCase(sec.sectionType) eq 'CONTENT'}">

                <c:set var="hasContent" value="true" />

            </c:when>


            <c:when test="${fn:toUpperCase(sec.sectionType) eq 'GALLERY'}">

                <c:set var="hasGallery" value="true" />

            </c:when>

        </c:choose>

    </c:forEach>


    <!-- =====================================================
         DYNAMIC SECTION CSS
    ====================================================== -->


    <!-- HERO CSS -->

    <c:if test="${hasHero}">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/sections/hero.css">

    </c:if>


    <!-- CONTENT CSS -->

    <c:if test="${hasContent}">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/sections/content.css">

    </c:if>


    <!-- GALLERY CSS -->

    <c:if test="${hasGallery}">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/sections/gallery.css">

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

            <a href="${pageContext.request.contextPath}/homepage?slug=calendar">
                Calendar
            </a>

            <a href="#">
                Quick Links
            </a>

            <a href="#">
                Portal Login
            </a>

            <a href="#"
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
                 HOME
            ================================================== -->

            <li class="${empty param.slug
                        || param.slug eq 'home'
                        || pageData.slug eq 'home'
                        ? 'active-tab'
                        : ''}">

                <a href="${pageContext.request.contextPath}/homepage?slug=home">

                    Home

                </a>

            </li>


            <!-- =================================================
                 DATABASE PAGES
            ================================================== -->

            <c:forEach var="pg"
                       items="${pagesList}">

                <c:if test="${pg.slug ne 'home'}">

                    <li class="${param.slug eq pg.slug
                                || pageData.slug eq pg.slug
                                ? 'active-tab'
                                : ''}">

                        <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}">

                            <c:out value="${pg.title}" />

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
         LOOP THROUGH DATABASE SECTIONS
    ================================================== -->

    <c:forEach var="sec"
               items="${pageData.sections}">


        <!-- =================================================
             HERO SECTION
        ================================================== -->

        <c:if test="${fn:toUpperCase(sec.sectionType) eq 'HERO'}">


            <div
                id="hero-${sec.id}"
                class="hero-fullscreen-container section-HERO"
                data-autoplay="true"
                data-interval="4000">


                <!-- =================================================
                     HERO IMAGES / SLIDES
                ================================================== -->

                <c:forEach var="img"
                           items="${sec.images}"
                           varStatus="status">


                    <div class="hero-slide ${status.first ? 'active' : ''}">


                        <!-- HERO IMAGE -->

                        <img
                            src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                            alt="${not empty img.altText
                                  ? img.altText
                                  : sec.title}">


                        <!-- =================================================
                             HERO TEXT
                        ================================================== -->

                        <div class="slide-content">


                            <c:if test="${not empty sec.title}">

                                <h2>

                                    <c:out value="${sec.title}" />

                                </h2>

                            </c:if>


                            <c:if test="${not empty sec.content}">

                                <p>

                                    <c:out
                                        value="${sec.content}"
                                        escapeXml="false" />

                                </p>

                            </c:if>


                        </div>

                    </div>

                </c:forEach>


                <!-- =================================================
                     HERO CONTROLS
                ================================================== -->

                <c:if test="${fn:length(sec.images) > 1}">


                    <!-- PREVIOUS -->

                    <a
                        class="prev"
                        href="javascript:void(0)"
                        onclick="manualHeroSlide('hero-${sec.id}', -1)"
                        aria-label="Previous slide">

                        &#10094;

                    </a>


                    <!-- NEXT -->

                    <a
                        class="next"
                        href="javascript:void(0)"
                        onclick="manualHeroSlide('hero-${sec.id}', 1)"
                        aria-label="Next slide">

                        &#10095;

                    </a>


                    <!-- =================================================
                         DOTS
                    ================================================== -->

                    <div class="dots">


                        <c:forEach
                            var="img"
                            items="${sec.images}"
                            varStatus="status">


                            <span
                                class="dot ${status.first ? 'active' : ''}"
                                onclick="goToHeroSlide(
                                    'hero-${sec.id}',
                                    ${status.index}
                                )"
                                aria-label="Go to slide ${status.index + 1}">

                            </span>


                        </c:forEach>


                    </div>


                </c:if>


            </div>

        </c:if>



        <!-- =================================================
             CONTENT SECTION
        ================================================== -->

        <c:if test="${fn:toUpperCase(sec.sectionType) eq 'CONTENT'}">


            <section
                class="dynamic-section section-CONTENT">


                <!-- TITLE -->

                <c:if test="${not empty sec.title}">

                    <h2>

                        <c:out value="${sec.title}" />

                    </h2>

                </c:if>


                <!-- CONTENT -->

                <c:if test="${not empty sec.content}">

                    <div class="section-content">

                        <c:out
                            value="${sec.content}"
                            escapeXml="false" />

                    </div>

                </c:if>


                <!-- =================================================
                     CONTENT IMAGES
                ================================================== -->

                <c:if test="${not empty sec.images}">

                    <div class="dynamic-image-grid">


                        <c:forEach
                            var="img"
                            items="${sec.images}">


                            <div class="dynamic-image-card">


                                <img
                                    src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                    alt="${not empty img.altText
                                          ? img.altText
                                          : sec.title}">


                            </div>


                        </c:forEach>


                    </div>

                </c:if>


            </section>

        </c:if>



        <!-- =================================================
             GALLERY SECTION
        ================================================== -->

        <c:if test="${fn:toUpperCase(sec.sectionType) eq 'GALLERY'}">


            <section
                class="dynamic-section section-GALLERY">


                <!-- TITLE -->

                <c:if test="${not empty sec.title}">

                    <h2>

                        <c:out value="${sec.title}" />

                    </h2>

                </c:if>


                <!-- CONTENT -->

                <c:if test="${not empty sec.content}">

                    <div class="section-content">

                        <c:out
                            value="${sec.content}"
                            escapeXml="false" />

                    </div>

                </c:if>


                <!-- =================================================
                     GALLERY IMAGES
                ================================================== -->

                <c:if test="${not empty sec.images}">

                    <div class="dynamic-image-grid">


                        <c:forEach
                            var="img"
                            items="${sec.images}">


                            <div class="dynamic-image-card">


                                <img
                                    src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                    alt="${not empty img.altText
                                          ? img.altText
                                          : sec.title}">


                            </div>


                        </c:forEach>


                    </div>

                </c:if>


            </section>

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
     DYNAMIC SECTION JAVASCRIPT
     Each JS file loaded only once
====================================================== -->


<!-- HERO JS -->

<c:if test="${hasHero}">

    <script
        src="${pageContext.request.contextPath}/js/sections/hero.js">
    </script>

</c:if>


<!-- CONTENT JS -->

<c:if test="${hasContent}">

    <script
        src="${pageContext.request.contextPath}/js/sections/content.js">
    </script>

</c:if>


<!-- GALLERY JS -->

<c:if test="${hasGallery}">

    <script
        src="${pageContext.request.contextPath}/js/sections/gallery.js">
    </script>

</c:if>


</body>

</html>