<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    isELIgnored="false" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        <c:out
            value="${not empty pageData.title
                    ? pageData.title
                    : 'Sandur Residential School'}" />
    </title>


    <!-- FONT AWESOME -->

    <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">


    <!-- GOOGLE FONTS -->

    <link
        href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap"
        rel="stylesheet">


    <!-- GLOBAL CSS -->

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/style.css">


    <!-- =====================================================
         DETECT SECTION TYPES
    ====================================================== -->

    <c:set var="hasHero" value="false" />
    <c:set var="hasDistinct" value="false" />
    <c:set var="hasContent" value="false" />
    <c:set var="hasGallery" value="false" />
    <c:set var="hasPersonDetails" value="false" />


    <c:forEach
        var="sec"
        items="${pageData.sections}">

        <c:choose>
        <c:when
    test="${fn:toUpperCase(sec.sectionType) eq 'PERSON-DETAILS'}">

    <c:set
        var="hasPersonDetails"
        value="true" />

</c:when>

            <c:when
                test="${fn:toUpperCase(sec.sectionType) eq 'HERO'}">

                <c:set
                    var="hasHero"
                    value="true" />

            </c:when>

            <c:when
                test="${fn:toUpperCase(sec.sectionType) eq 'DISTINCT'}">

                <c:set
                    var="hasDistinct"
                    value="true" />

            </c:when>

            <c:when
                test="${fn:toUpperCase(sec.sectionType) eq 'CONTENT'}">

                <c:set
                    var="hasContent"
                    value="true" />

            </c:when>

            <c:when
                test="${fn:toUpperCase(sec.sectionType) eq 'GALLERY'}">

                <c:set
                    var="hasGallery"
                    value="true" />

            </c:when>

        </c:choose>

    </c:forEach>


    <!-- =====================================================
         SECTION CSS
    ====================================================== -->

    <c:if test="${hasHero}">

        <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/css/hero.css">

    </c:if>


    <c:if test="${hasDistinct}">

        <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/css/distinct.css">

    </c:if>


    <c:if test="${hasContent}">

        <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/css/sections/content.css">

    </c:if>


    <c:if test="${hasGallery}">

        <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/css/sections/gallery.css">

    </c:if>
    <c:if test="${hasPersonDetails}">

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/sections/person-details.css">

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

            <h1>
                Sandur Residential School
            </h1>

        </div>


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


    <!-- MOBILE MENU -->

    <div class="menu-toggle">

        <i class="fa fa-bars"></i>

    </div>


    <!-- =================================================
         MAIN NAVIGATION
    ================================================== -->

    <nav>

        <ul class="main-menu">


            <c:set
                var="currentSlug"
                value="${not empty param.slug
                        ? param.slug
                        : (not empty pageData.slug
                            ? pageData.slug
                            : 'home')}" />


            <!-- HOME -->

            <li
                class="${currentSlug eq 'home'
                        ? 'active-tab'
                        : ''}">

                <a
                    href="${pageContext.request.contextPath}/homepage?slug=home">

                    Home

                </a>

            </li>


            <!-- DATABASE PAGES -->

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

                            <c:out
                                value="${pg.title}" />


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
         LOOP THROUGH DATABASE SECTIONS
    ================================================== -->

    <c:forEach
        var="sec"
        items="${pageData.sections}">


        <!-- =================================================
             HERO SECTION
        ================================================== -->

        <c:if
            test="${fn:toUpperCase(sec.sectionType) eq 'HERO'}">


            <div
                id="hero-${sec.id}"
                class="hero-fullscreen-container section-HERO"
                data-autoplay="true"
                data-interval="4000">


                <c:forEach
                    var="img"
                    items="${sec.images}"
                    varStatus="status">


                    <div
                        class="hero-slide ${status.first ? 'active' : ''}">


                        <img
                            src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                            alt="${not empty img.altText
                                  ? img.altText
                                  : sec.title}">


                        <div class="slide-content">


                            <c:if test="${not empty sec.title}">

                                <h2>

                                    <c:out
                                        value="${sec.title}" />

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


                <c:if
                    test="${fn:length(sec.images) > 1}">


                    <a
                        class="prev"
                        href="javascript:void(0)"
                        onclick="manualHeroSlide('hero-${sec.id}', -1)"
                        aria-label="Previous slide">

                        &#10094;

                    </a>


                    <a
                        class="next"
                        href="javascript:void(0)"
                        onclick="manualHeroSlide('hero-${sec.id}', 1)"
                        aria-label="Next slide">

                        &#10095;

                    </a>


                    <div class="dots">

                        <c:forEach
                            var="img"
                            items="${sec.images}"
                            varStatus="status">

                            <span
                                class="dot ${status.first ? 'active' : ''}"
                                onclick="goToHeroSlide('hero-${sec.id}', ${status.index})"
                                aria-label="Go to slide ${status.index + 1}">
                            </span>

                        </c:forEach>

                    </div>

                </c:if>

            </div>

        </c:if>


        <!-- =================================================
     DISTINCT SECTION
================================================== -->
<c:if test="${fn:toUpperCase(sec.sectionType) eq 'DISTINCT'}">

    <section class="distinct-section">

        <!-- GRID ITEM 1: INTRO BOX -->
        <div class="distinct-intro">
            <c:if test="${not empty sec.title}">
                <h2><c:out value="${sec.title}" /></h2>
            </c:if>

            <c:if test="${not empty sec.content}">
                <p><c:out value="${sec.content}" escapeXml="false" /></p>
            </c:if>
        </div>

        <!-- GRID ITEMS 2 TO 6: DIRECT CARDS -->
        <c:forEach var="img" items="${sec.images}" varStatus="status">
            <div class="distinct-card">
                
                <img src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                     alt="${not empty img.altText ? img.altText : sec.title}">

                <div class="distinct-overlay">
                    <h3>
                        <c:out value="${not empty img.altText ? img.altText : sec.title}" />
                    </h3>
                </div>

            </div>
        </c:forEach>

    </section>

</c:if>


        <!-- =================================================
             CONTENT SECTION
        ================================================== -->

        <c:if
            test="${fn:toUpperCase(sec.sectionType) eq 'CONTENT'}">


            <section
                class="dynamic-section section-CONTENT">


                <c:if test="${not empty sec.title}">

                    <h2>

                        <c:out
                            value="${sec.title}" />

                    </h2>

                </c:if>


                <c:if test="${not empty sec.content}">

                    <div class="section-content">

                        <c:out
                            value="${sec.content}"
                            escapeXml="false" />

                    </div>

                </c:if>


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

        <c:if
            test="${fn:toUpperCase(sec.sectionType) eq 'GALLERY'}">


            <section
                class="dynamic-section section-GALLERY">


                <c:if test="${not empty sec.title}">

                    <h2>

                        <c:out
                            value="${sec.title}" />

                    </h2>

                </c:if>


                <c:if test="${not empty sec.content}">

                    <div class="section-content">

                        <c:out
                            value="${sec.content}"
                            escapeXml="false" />

                    </div>

                </c:if>


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


                                <c:if test="${not empty img.altText}">

                                    <div class="image-title">

                                        <c:out
                                            value="${img.altText}" />

                                    </div>

                                </c:if>


                            </div>


                        </c:forEach>


                    </div>

                </c:if>


            </section>

        </c:if>


    </c:forEach>

<!-- =================================================
     PERSON DETAILS SECTION
================================================== -->

<c:if
    test="${fn:toUpperCase(sec.sectionType) eq 'PERSON-DETAILS'}">

    <section class="person-details-section">

        <!-- LEFT : PERSON IMAGE -->

        <div class="person-details-image">

            <c:if test="${not empty sec.images}">

                <c:forEach
                    var="img"
                    items="${sec.images}"
                    varStatus="status">

                    <c:if test="${status.first}">

                        <img
                            src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                            alt="${not empty img.altText
                                  ? img.altText
                                  : sec.title}">

                    </c:if>

                </c:forEach>

            </c:if>

        </div>


        <!-- RIGHT : PERSON INFORMATION -->

        <div class="person-details-content">

            <!-- SECTION TITLE -->

            <c:if test="${not empty sec.title}">

                <h2>

                    <c:out
                        value="${sec.title}" />

                </h2>

            </c:if>


            <!-- PERSON NAME -->

            <c:if test="${not empty sec.subtitle}">

                <h3>

                    <c:out
                        value="${sec.subtitle}" />

                </h3>

            </c:if>


            <!-- DESCRIPTION -->

            <c:if test="${not empty sec.content}">

                <div class="person-description">

                    <c:out
                        value="${sec.content}"
                        escapeXml="false" />

                </div>

            </c:if>

        </div>

    </section>

</c:if>

    <!-- =====================================================
         NEWS & EVENTS
    ====================================================== -->

    <c:if
        test="${not empty newsList || not empty eventList}">


        <section
            class="updates-container dynamic-section">


            <div class="updates-grid">


                <!-- NEWS -->

                <c:if test="${not empty newsList}">


                    <div class="news-column">

                        <h3>
                            Latest News
                        </h3>


                        <div class="news-list">


                            <c:forEach
                                var="news"
                                items="${newsList}">


                                <div class="news-card">


                                    <c:if test="${not empty news.image}">

                                        <img
                                            src="${news.image}"
                                            alt="${news.title}">

                                    </c:if>


                                    <h4>

                                        <c:out
                                            value="${news.title}" />

                                    </h4>


                                    <p>

                                        <c:out
                                            value="${news.description}" />

                                    </p>


                                    <c:if test="${not empty news.link}">

                                        <a
                                            href="${news.link}"
                                            class="read-more">

                                            Read More

                                        </a>

                                    </c:if>


                                </div>


                            </c:forEach>


                        </div>

                    </div>


                </c:if>


                <!-- EVENTS -->

                <c:if test="${not empty eventList}">


                    <div class="events-column">

                        <h3>
                            Upcoming Events
                        </h3>


                        <div class="events-list">


                            <c:forEach
                                var="event"
                                items="${eventList}">


                                <div class="event-card">


                                    <div class="event-date">

                                        <fmt:formatDate
                                            value="${event.event_date}"
                                            pattern="dd MMM yyyy" />

                                    </div>


                                    <div class="event-details">


                                        <h4>

                                            <c:out
                                                value="${event.title}" />

                                        </h4>


                                        <p>

                                            <c:out
                                                value="${event.description}" />

                                        </p>


                                    </div>


                                </div>


                            </c:forEach>


                        </div>

                    </div>


                </c:if>


            </div>

        </section>

    </c:if>


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
     HERO JAVASCRIPT
====================================================== -->

<c:if test="${hasHero}">

    <script
        src="${pageContext.request.contextPath}/js/hero.js">
    </script>

</c:if>


<!-- =====================================================
     DISTINCT JAVASCRIPT
====================================================== -->

<c:if test="${hasDistinct}">

    <script
        src="${pageContext.request.contextPath}/js/distinct.js">
    </script>

</c:if>


<!-- =====================================================
     CONTENT JAVASCRIPT
====================================================== -->




<!-- =====================================================
     GALLERY JAVASCRIPT
====================================================== -->




</body>

</html>