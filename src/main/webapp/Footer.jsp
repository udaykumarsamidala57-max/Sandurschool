<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ================= FOOTER ================= -->
<footer>

<div class="footer-container">

    <div class="footer-left">
        <h2>Sandur Residential School</h2>
        <p class="address">Shivapur, Sandur – 583119 · Ballari District, Karnataka · India</p>

        <a href="${pageContext.request.contextPath}/contact.jsp" class="contact-btn"> 
        CONTACT US <i class="fa fa-arrow-right"></i>
        </a>

        <div class="disclaimer">
            <p>This official site of Sandur Residential School has been developed to provide general public information. The documents and information displayed on this site are for reference purposes only.</p>
            <p>Whilst Sandur Residential School attempts to keep it's web information accurate and timely, it neither guarantees nor endorses the content, accuracy or completeness of the information, text, graphics, hyperlinks and other matter contained on this server or any other server. Information and content is subject to change without notice from Sandur Residential School.</p>
            <p>Commercial use of web materials displayed on our website is prohibited without the written permission of the school.</p>
        </div>
    </div>

    <div class="footer-right">
        <a href="#" class="social-icon" aria-label="Facebook">
            <i class="fa-brands fa-facebook-f"></i>
        </a>

        <div class="footer-nav-links">
            <a href="${pageContext.request.contextPath}/calendar.jsp">School Calendar</a>
            <a href="${pageContext.request.contextPath}/map.jsp">Map & Directions</a>
            <a href="${pageContext.request.contextPath}/news.jsp">News</a>
            <a href="${pageContext.request.contextPath}/careers.jsp">Job vacancies</a>
        </div>
    </div>

</div>

</footer>