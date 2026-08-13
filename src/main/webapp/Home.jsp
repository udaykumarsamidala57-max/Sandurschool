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
    <title>Dynamic Sections & Image Loader</title>
    
    <!-- External Section Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sections.css">
    
    <!-- Typography / Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Merriweather:wght@400;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--sec-bg-light, #f7f5f2);
            color: var(--sec-text-dark, #222222);
        }
    </style>
</head>

<body>

<%@ include file="Header.jsp" %>

<c:choose>

    <%-- RENDER ONLY DYNAMIC SECTIONS RETRIEVED FROM DATABASE --%>
    <c:when test="${not empty pageData and not empty pageData.sections}">

        <c:forEach
            var="sec"
            items="${pageData.sections}"
            varStatus="secLoop">

            <c:choose>

                <%-- 1. HERO SECTION --%>
                <c:when test="${fn:toLowerCase(sec.sectionType) eq 'hero'}">

                    <section class="page-section section-hero">
                        <div id="slideshow-${secLoop.index}" class="hero-fullscreen-container" data-autoplay="true" data-interval="4000">

                            <c:choose>

                                <c:when test="${not empty sec.images}">

                                    <c:forEach var="img" items="${sec.images}" varStatus="imgLoop">

                                        <div class="hero-slide ${imgLoop.first ? 'active' : ''}">
                                            
                                            <img
                                                src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                                alt="${img.altText}"
                                                onload="
                                                    this.nextElementSibling.querySelector('.status').innerText='LOAD SUCCESS';
                                                    this.nextElementSibling.querySelector('.status').style.color='#4EAE4E';
                                                "
                                                onerror="
                                                    this.nextElementSibling.querySelector('.status').innerText='LOAD FAILED';
                                                    this.nextElementSibling.querySelector('.status').style.color='#FF4D4D';
                                                "
                                            >

                                            <div class="hero-slide-info">
                                                <h3><c:out value="${sec.title}" /></h3>
                                                <p>
                                                    <strong>Image ID:</strong> <c:out value="${img.id}" /> | 
                                                    <strong>Alt:</strong> <c:out value="${img.altText}" />
                                                </p>
                                                <div class="status" style="font-weight:bold;">Testing stream...</div>
                                            </div>

                                        </div>

                                    </c:forEach>

                                    <!-- Navigation Arrows -->
                                    <c:if test="${fn:length(sec.images) > 1}">
                                        <div class="hero-nav">
                                            <button type="button" aria-label="Previous Slide" onclick="manualChangeSlide('slideshow-${secLoop.index}', -1)">&#10094;</button>
                                            <button type="button" aria-label="Next Slide" onclick="manualChangeSlide('slideshow-${secLoop.index}', 1)">&#10095;</button>
                                        </div>

                                        <!-- Dots -->
                                        <div class="hero-dots">
                                            <c:forEach var="img" items="${sec.images}" varStatus="imgLoop">
                                                <span class="dot ${imgLoop.first ? 'active' : ''}" onclick="manualGoToSlide('slideshow-${secLoop.index}', ${imgLoop.index})"></span>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                </c:when>

                                <c:otherwise>
                                    <div style="color:#ffffff; text-align:center; padding-top:20vh;">
                                        <h3>Section: <c:out value="${sec.title}" /></h3>
                                        <p style="color:var(--sec-brand-orange, #e06d38);">No images found in <code>section_images</code> for this Hero section ID.</p>
                                    </div>
                                </c:otherwise>

                            </c:choose>

                        </div>
                    </section>

                </c:when>

                <%-- 2. DISTINCT / DISTRICT SECTION --%>
                <c:when test="${fn:toLowerCase(sec.sectionType) eq 'distinct' or fn:toLowerCase(sec.sectionType) eq 'district'}">

                    <section class="page-section section-distinct">
                        
                        <!-- Background Accent Box -->
                        <div class="distinct-accent-bg"></div>

                        <div class="distinct-grid">

                            <!-- Title Card Block -->
                            <div class="distinct-header-card">
                                <h2><c:out value="${sec.title}" default="Distinctly SRS" /></h2>
                                <p>Discover our school by navigating through our posts, blogs and news.</p>
                            </div>

                            <!-- Dynamic Grid Cards -->
                            <c:choose>
                                <c:when test="${not empty sec.images}">
                                    <c:forEach var="img" items="${sec.images}">
                                        <div class="distinct-img-card">
                                            <img
                                                src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                                alt="${img.altText}"
                                            >
                                            <div class="distinct-img-overlay">
                                                <h3>
                                                    <c:choose>
                                                        <c:when test="${not empty img.altText}">
                                                            <c:out value="${img.altText}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${img.imageType}" default="Explore" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h3>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="distinct-img-card" style="grid-column: span 2; display:flex; align-items:center; justify-content:center; color:#ffffff;">
                                        <p style="padding: 20px;">No images available for this section.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>

                    </section>

                </c:when>

                <%-- 3. POPUP MODAL SECTION --%>
                <c:when test="${fn:toLowerCase(sec.sectionType) eq 'popup_modal'}">

                    <section id="modal-section-${secLoop.index}" class="page-section section-popup_modal">
                        <div class="modal-content-card">
                            <button type="button" class="modal-close-btn" onclick="closePopupModal('modal-section-${secLoop.index}')">&times;</button>
                            
                            <h2 style="margin-top:0; color: var(--sec-brand-dark);"><c:out value="${sec.title}" /></h2>
                            
                            <c:if test="${not empty sec.images}">
                                <div style="margin: 15px 0;">
                                    <c:forEach var="img" items="${sec.images}">
                                        <img 
                                            src="${pageContext.request.contextPath}/imageStream?id=${img.id}" 
                                            alt="${img.altText}"
                                            style="width: 100%; height: auto; border-radius: 6px; margin-bottom: 10px;"
                                        >
                                    </c:forEach>
                                </div>
                            </c:if>
                            
                            <div style="text-align: right; margin-top: 15px;">
                                <button type="button" 
                                        onclick="closePopupModal('modal-section-${secLoop.index}')"
                                        style="background: var(--sec-brand-orange); color: #fff; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;">
                                    Close
                                </button>
                            </div>
                        </div>
                    </section>

                </c:when>

                <%-- 4. FALLBACK FOR ANY OTHER CUSTOM SECTION TYPES --%>
                <c:otherwise>

                    <section class="page-section section-default">

                        <h3>
                            Section #${secLoop.index + 1}:
                            <c:out value="${sec.title}" />
                            (Type: <code><c:out value="${sec.sectionType}" /></code>)
                        </h3>

                        <p style="color: var(--sec-text-muted);">
                            Total Images linked to Section ID <strong><c:out value="${sec.id}" /></strong>:
                            <strong><c:out value="${fn:length(sec.images)}" default="0" /></strong>
                        </p>

                        <c:choose>
                            <c:when test="${not empty sec.images}">
                                <div class="default-grid">
                                    <c:forEach var="img" items="${sec.images}">
                                        <div class="default-card">
                                            <p style="margin: 0 0 8px 0; font-size: 13px;">
                                                <strong>Image ID:</strong> <c:out value="${img.id}" /><br>
                                                <strong>Type:</strong> <c:out value="${img.imageType}" /><br>
                                                <strong>Alt:</strong> <c:out value="${img.altText}" />
                                            </p>
                                            <img
                                                src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                                alt="${img.altText}"
                                                onload="
                                                    this.nextElementSibling.innerText='LOAD SUCCESS';
                                                    this.nextElementSibling.style.color='#4EAE4E';
                                                "
                                                onerror="
                                                    this.nextElementSibling.innerText='LOAD FAILED';
                                                    this.nextElementSibling.style.color='#FF4D4D';
                                                "
                                            >
                                            <div style="font-weight:bold; margin-top:6px; font-size: 12px;">Testing stream...</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p style="color:var(--sec-brand-orange);">
                                    No images found in <code>section_images</code> for this section ID.
                                </p>
                            </c:otherwise>
                        </c:choose>

                    </section>

                </c:otherwise>

            </c:choose>

        </c:forEach>

    </c:when>

    <c:otherwise>

        <section class="diagnostic-container">
            <p style="color:#FF4D4D; font-weight:bold; margin:0;">
                No sections found in pageData. Verify 'pages' table entry with slug='home'.
            </p>
        </section>

    </c:otherwise>

</c:choose>

<!-- CONDITIONAL NEWS SECTION (ONLY RENDERS IF newsList IS NOT EMPTY) -->
<c:if test="${not empty newsList}">
    <hr style="border: none; border-top: 1px solid #e1e1e1; margin: 40px 0;">

    <section class="diagnostic-container">
        <h2 style="margin-top:0; color: var(--sec-brand-dark);">
            <c:out value="${not empty pageData.sections ? fn:length(pageData.sections) + 1 : 1}" />. News Section Images
        </h2>

        <div class="news-grid-container">

            <c:forEach var="news" items="${newsList}">

                <div class="news-card">

                    <h4 style="margin:0 0 8px 0; font-size: 15px;"><c:out value="${news.title}" /></h4>

                    <p style="font-size:12px; color: var(--sec-text-muted); margin: 0 0 10px 0; word-break: break-all;">
                        Path: <code><c:out value="${news.image}" /></code>
                    </p>

                    <img
                        src="${pageContext.request.contextPath}/uploads/${news.image}"
                        alt="News Image"
                        onload="
                            this.nextElementSibling.innerText='OK';
                            this.nextElementSibling.style.color='#4EAE4E';
                        "
                        onerror="
                            this.nextElementSibling.innerText='IMAGE NOT FOUND IN /uploads/';
                            this.nextElementSibling.style.color='#FF4D4D';
                        "
                    >

                    <div style="font-weight:bold; font-size: 12px; margin-top: 6px;">Testing...</div>

                </div>

            </c:forEach>

        </div>
    </section>
</c:if>

<!-- External Section JavaScript -->
<script src="${pageContext.request.contextPath}/js/sections.js"></script>

<%@ include file="Footer.jsp" %>
</body>
</html>