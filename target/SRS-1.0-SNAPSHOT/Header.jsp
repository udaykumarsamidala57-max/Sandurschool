<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${not empty pageData.title ? pageData.title : 'Sandur Residential School'}" /></title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap" rel="stylesheet">
    
    <!-- Link your external stylesheet here or keep it inside style tags -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
</head>
<body>

<!-- TOP STRIP -->
<div class="top-strip"></div>

<!-- ================= HEADER SECTION ================= -->
<header>

    <!-- Top Branding & Utility Links -->
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

    <!-- Mobile Menu Toggle Button -->
    <div class="menu-toggle">
        <i class="fa fa-bars"></i>
    </div>

    <!-- Main Dynamic Navigation Bar -->
    <nav>
        <ul class="main-menu">

            <!-- Static Home Navigation Link -->
            <li class="${empty param.slug || param.slug eq 'home' || pageData.slug eq 'home' ? 'active-tab' : ''}">
                <a href="${pageContext.request.contextPath}/homepage?slug=home">Home</a>
            </li>

            <!-- Dynamic Navigation Links Fetched from Database -->
            <c:choose>
                <c:when test="${not empty pagesList}">
                    <c:forEach var="pg" items="${pagesList}">
                        <c:if test="${pg.slug ne 'home'}">
                            <li class="${(param.slug eq pg.slug || pageData.slug eq pg.slug) ? 'active-tab' : ''}">
                                <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}">
                                    <c:out value="${pg.title}" />
                                </a>
                            </li>
                        </c:if>
                    </c:forEach>
                </c:when>
            </c:choose>

        </ul>
    </nav>

</header>

<!-- ================= MAIN BODY CONTENT ================= -->
<main class="main-content">

    <!-- Hero Slideshow aligned with JS -->
    <div id="heroSlideshow" class="about-slideshow hero-fullscreen-container" data-autoplay="true" data-interval="4000">
        <div class="slide hero-slide active">
            <img src="${pageContext.request.contextPath}/Home/slide1.jpg" alt="Slide 1">
            <div class="slide-content">
                <h2>Welcome to Sandur Residential School</h2>
                <p>Nurturing minds and shaping future leaders.</p>
            </div>
        </div>
        <div class="slide hero-slide">
            <img src="${pageContext.request.contextPath}/Home/slide2.jpg" alt="Slide 2">
            <div class="slide-content">
                <h2>Excellence in Academics & Sports</h2>
                <p>Comprehensive education in a serene environment.</p>
            </div>
        </div>

        <!-- Controls -->
        <a class="prev" onclick="manualChangeSlide('heroSlideshow', -1)">&#10094;</a>
        <a class="next" onclick="manualChangeSlide('heroSlideshow', 1)">&#10095;</a>

        <div class="dots">
            <span class="dot active" onclick="manualGoToSlide('heroSlideshow', 0)"></span>
            <span class="dot" onclick="manualGoToSlide('heroSlideshow', 1)"></span>
        </div>
    </div>

    <!-- Dynamic DB Content Section -->
    <c:forEach var="sec" items="${pageData.sections}">
        <section class="dynamic-section">
            <c:if test="${not empty sec.title}">
                <h2><c:out value="${sec.title}" /></h2>
            </c:if>
            <p><c:out value="${sec.content}" escapeXml="false" /></p>

            <c:if test="${not empty sec.images}">
                <div class="dynamic-image-grid">
                    <c:forEach var="img" items="${sec.images}">
                        <div class="dynamic-image-card">
                            <img src="${pageContext.request.contextPath}/imageStream?id=${img.id}" alt="Section Image" />
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </section>
    </c:forEach>

</main>

<script>
// Mobile navigation menu toggle
const menuToggle = document.querySelector(".menu-toggle");
const nav = document.querySelector("nav");

if (menuToggle) {
    menuToggle.addEventListener("click", () => {
        nav.classList.toggle("active");
    });
}
</script>

</body>
</html>