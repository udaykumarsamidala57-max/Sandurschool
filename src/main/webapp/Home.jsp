<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title><c:out value="${pageData.title != null ? pageData.title : 'Home'}" /> - Sandur Residential School</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap" rel="stylesheet">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

/* ================= NON-INTRUSIVE FOOTER PINNING ================= */
body {
    font-family: 'Open Sans', sans-serif;
    background: #f7f5f2;
    min-height: 100vh;
    display: grid;
    grid-template-rows: auto auto 1fr auto; /* top-strip, header, main, footer */
}

.main-content {
    width: 100%;
    max-width: 1300px;
    margin: 0 auto;
    padding: 40px 6%;
}

/* ================= TOP STRIP ================= */

.top-strip{
    width:100%;
    height:8px;
    background:#FA8405;
}

/* ================= HEADER ================= */

.top-header{
    background:white;
    padding:20px 6%;
    display:flex;
    justify-content:space-between;
    align-items:center;
    border-bottom:1px solid #ddd;
}

.logo-area{
    display:flex;
    align-items:center;
    gap:20px;
}

.logo-area img{
    width:90px;
}

.logo-area h1{
    font-family:'Merriweather',serif;
    font-size:38px;
    color:#5b2d0a;
}

.top-links{
    display:flex;
    gap:30px;
}

.top-links a{
    text-decoration:none;
    color:#5b2d0a;
    font-weight:600;
    font-size:15px;
}

/* ================= MOBILE MENU BUTTON ================= */

.menu-toggle{
    display:none;
    background:#f1efec;
    padding:16px 20px;
    font-size:24px;
    cursor:pointer;
    border-bottom:1px solid #ddd;
}

/* ================= NAVIGATION ================= */

nav{
    background:#f1efec;
    position:sticky;
    top:0;
    z-index:999;
    border-bottom:1px solid #ddd;
}

.main-menu{
    list-style:none;
    display:flex;
    justify-content:center;
}

.main-menu li{
    position:relative;
}

.main-menu li a{
    display:block;
    padding:22px 25px;
    text-decoration:none;
    color:#111;
    font-weight:700;
    font-size:17px;
    transition:0.3s;
}

.main-menu li:hover,
.main-menu li.active-tab > a {
    background:#e6ddd3;
    color:#5b2d0a;
}

/* ================= DROPDOWN ================= */

.dropdown{
    display:none;
    position:absolute;
    top:100%;
    left:0;
    background:white;
    min-width:260px;
    list-style:none;
    box-shadow:0 5px 15px rgba(0,0,0,0.15);
    z-index: 1000;
}

.dropdown li{
    width:100%;
}

.dropdown li a{
    padding:15px 20px;
    border-bottom:1px solid #eee;
    color:#333;
    font-size:15px;
    font-weight:600;
}

.dropdown li a:hover{
    background:#d66f2d;
    color:white;
}

.main-menu li:hover .dropdown{
    display:block;
}

/* ================= DYNAMIC SECTION STYLES ================= */

.section-block {
    background: #ffffff;
    padding: 30px;
    margin-bottom: 30px;
    border-radius: 6px;
    border: 1px solid #e0e0e0;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.section-block h3 {
    font-family: 'Merriweather', serif;
    font-size: 22px;
    color: #5b2d0a;
    margin-bottom: 15px;
}

.image-gallery {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    margin-top: 20px;
}

.image-gallery img {
    max-width: 100%;
    height: auto;
    max-height: 350px;
    border-radius: 4px;
    object-fit: cover;
}

/* ================= FOOTER STYLES ================= */

footer {
    background-color: #43230a;
    color: #e5ded8;
    padding: 60px 8% 40px;
    font-size: 14px;
    line-height: 1.6;
}

.footer-container {
    display: flex;
    justify-content: space-between;
    gap: 50px;
    max-width: 1300px;
    margin: 0 auto;
}

.footer-left {
    flex: 1.8;
}

.footer-left h2 {
    font-family: 'Merriweather', serif;
    font-size: 26px;
    color: #ffffff;
    margin-bottom: 12px;
}

.footer-left .address {
    font-size: 15px;
    color: #d1c5bc;
    margin-bottom: 25px;
}

.footer-left .contact-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    color: #ffffff;
    text-decoration: none;
    font-weight: 700;
    font-size: 12px;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 30px;
}

.footer-left .contact-btn:hover {
    color: #FA8405;
}

.footer-left .disclaimer {
    font-size: 13px;
    color: #bfaea2;
    line-height: 1.7;
}

.footer-left .disclaimer p {
    margin-bottom: 18px;
}

.footer-right {
    flex: 1;
    display: flex;
    gap: 20px;
    align-items: flex-start;
}

.social-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 44px;
    height: 44px;
    border: 1px solid #ffffff;
    border-radius: 50%;
    color: #ffffff;
    text-decoration: none;
    font-size: 18px;
    transition: 0.3s ease;
}

.social-icon:hover {
    background-color: #ffffff;
    color: #43230a;
}

.footer-nav-links {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px 30px;
    margin-top: 6px;
}

.footer-nav-links a {
    color: #ffffff;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
    transition: color 0.2s;
}

.footer-nav-links a:hover {
    color: #FA8405;
}

/* ================= MOBILE ================= */

@media(max-width:900px){

.top-header{
    flex-direction:column;
    gap:20px;
    text-align:center;
}

.logo-area{
    flex-direction:column;
}

.logo-area h1{
    font-size:28px;
}

.top-links{
    flex-wrap:wrap;
    justify-content:center;
    gap:15px;
}

.menu-toggle{
    display:block;
}

nav{
    display:none;
    position:relative;
}

nav.active{
    display:block;
}

.main-menu{
    flex-direction:column;
    width:100%;
}

.main-menu li{
    width:100%;
    border-bottom:1px solid #ddd;
}

.main-menu li a{
    padding:18px 20px;
    font-size:16px;
}

.dropdown{
    position:static;
    width:100%;
    box-shadow:none;
    background:#fafafa;
}

.main-menu li:hover .dropdown{
    display:none;
}

.main-menu li.active .dropdown{
    display:block;
}

.dropdown li a{
    padding-left:40px;
}

.footer-container {
    flex-direction: column;
    gap: 40px;
}

.footer-right {
    flex-direction: row;
}

.footer-nav-links {
    grid-template-columns: 1fr;
}

}

</style>

</head>

<body>

<!-- TOP STRIP -->
<div class="top-strip"></div>

<!-- ================= HEADER ================= -->
<header>

<div class="top-header">
    <div class="logo-area">
        <img src="${pageContext.request.contextPath}/Home/logo.png" alt="Logo">
        <h1>Sandur Residential School</h1>
    </div>

    <div class="top-links">
        <a href="#">Calendar</a>
        <a href="#">Quick Links</a>
        <a href="#">Portal Login</a>
        <a href="#"><i class="fa fa-search"></i></a>
    </div>
</div>

<div class="menu-toggle">
    <i class="fa fa-bars"></i>
</div>

<nav>
<ul class="main-menu">

    <!-- Static Home Link -->
    <li class="${empty pageData.slug || pageData.slug eq 'home' ? 'active-tab' : ''}">
        <a href="${pageContext.request.contextPath}/homepage?slug=home">Home</a>
    </li>

    <!-- Dynamic Header Pages from Database -->
    <c:choose>
        <c:when test="${not empty pagesList}">
            <c:forEach var="pg" items="${pagesList}">
                <li class="${pageData.slug eq pg.slug ? 'active-tab' : ''}">
                    <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}">
                        <c:out value="${pg.title}" />
                        <c:if test="${not empty pg.children}">
                            <i class="fa fa-angle-down" style="font-size: 12px; margin-left: 4px;"></i>
                        </c:if>
                    </a>

                    <!-- Dropdown Navigation for Sub-pages -->
                    <c:if test="${not empty pg.children}">
                        <ul class="dropdown">
                            <c:forEach var="child" items="${pg.children}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/homepage?slug=${child.slug}">
                                        <c:out value="${child.title}" />
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:if>
                </li>
            </c:forEach>
        </c:when>
    </c:choose>

</ul>
</nav>

</header>

<!-- ================= MAIN BODY CONTENT ================= -->
<main class="main-content">
    
    <h2 style="font-family: 'Merriweather', serif; font-size: 30px; color: #5b2d0a; margin-bottom: 20px;">
        <c:out value="${pageData.title}" />
    </h2>

    <c:forEach var="sec" items="${pageData.sections}">
        <section class="section-block">
            <c:if test="${not empty sec.title}">
                <h3><c:out value="${sec.title}" /></h3>
            </c:if>
            
            <div class="section-text">
                <c:out value="${sec.content}" escapeXml="false" />
            </div>

            <!-- Dynamic Image Stream Gallery -->
            <c:if test="${not empty sec.images}">
                <div class="image-gallery">
                    <c:forEach var="img" items="${sec.images}">
                        <img src="${pageContext.request.contextPath}/imageStream?id=${img.id}" 
                             alt="${img.altText != null ? img.altText : 'Section Image'}" />
                    </c:forEach>
                </div>
            </c:if>
        </section>
    </c:forEach>

</main>

<!-- ================= FOOTER ================= -->
<footer>
    <div class="footer-container">
        <div class="footer-left">
            <h2>Sandur Residential School</h2>
            <div class="address">
                Shivapur, Sandur - 583119, Ballari District, Karnataka, India
            </div>
            <a href="#" class="contact-btn">
                Contact Us <i class="fa fa-arrow-right"></i>
            </a>
            <div class="disclaimer">
                <p>&copy; Sandur Residential School. All Rights Reserved.</p>
            </div>
        </div>

        <div class="footer-right">
            <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
            <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
            <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
        </div>
    </div>
</footer>

<!-- ================= JAVASCRIPT ================= -->
<script>

const menuToggle = document.querySelector(".menu-toggle");
const nav = document.querySelector("nav");

menuToggle.addEventListener("click", () => {
    nav.classList.toggle("active");
});

document.querySelectorAll(".main-menu > li").forEach(item => {
    item.addEventListener("click", function(e){
        if(window.innerWidth <= 900){
            const dropdown = this.querySelector(".dropdown");
            if(dropdown){
                e.preventDefault();
                this.classList.toggle("active");
            }
        }
    });
});

</script>

</body>
</html>