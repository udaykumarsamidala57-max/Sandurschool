<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
  footer {
    background-color: #542901; /* Deep classic brown */
    color: #ffffff;
    font-family: 'Georgia', 'Times New Roman', serif;
    padding: 60px 7% 80px 7%;
    box-sizing: border-box;
    width: 100%;
    -webkit-font-smoothing: antialiased;
  }

  .footer-container {
    max-width: 1250px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 80px;
  }

  .footer-left {
    flex: 1 1 60%;
    max-width: 680px;
  }

  .footer-left h2 {
    font-size: 30px;
    font-weight: 700;
    margin: 0 0 16px 0;
    color: #ffffff;
    letter-spacing: 0.2px;
    line-height: 1.2;
  }

  .footer-left .address {
    font-size: 17px;
    line-height: 1.6;
    margin-bottom: 28px;
    color: #ffffff;
  }

  .contact-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    color: #ffffff;
    text-decoration: none;
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-weight: 800;
    
    font-size: 13px;
    letter-spacing: 1.5px;
    margin-bottom: 40px;
    text-transform: uppercase;
    transition: opacity 0.2s ease;
  }

  .contact-btn:hover {
    opacity: 0.8;
  }

  .contact-btn i {
    font-size: 12px;
  }

  .disclaimer {
    font-size: 15px;
    line-height: 1.6;
    color: #ffffff;
  }

  .disclaimer p {
    margin-bottom: 22px;
  }

  .disclaimer p:last-child {
    margin-bottom: 0;
  }

  .footer-right {
    flex: 0 0 auto;
    display: flex;
    align-items: flex-start;
    gap: 28px;
    padding-top: 6px;
  }

  .social-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 46px;
    height: 46px;
    border: 1.5px solid #ffffff;
    border-radius: 50%;
    color: #ffffff;
    text-decoration: none;
    font-size: 18px;
    transition: background-color 0.2s ease, transform 0.2s ease;
  }

  .social-icon:hover {
    background-color: rgba(255, 255, 255, 0.12);
  }

  .footer-nav-links {
    display: grid;
    grid-template-columns: auto auto;
    column-gap: 36px;
    row-gap: 16px;
  }

  .footer-nav-links a {
    color: #ffffff;
    text-decoration: none;
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    font-size: 15px;
    font-weight: 500;
    white-space: nowrap;
    transition: opacity 0.2s ease;
  }

  .footer-nav-links a:hover {
    text-decoration: underline;
    opacity: 0.85;
  }

  @media (max-width: 900px) {
    .footer-container {
      flex-direction: column;
      gap: 40px;
    }
  }
</style>

<footer>
    <div class="footer-container">

        <div class="footer-left">
            <h2>Sandur Residential School</h2>
            <p class="address">Shivapur, Sandur – 583119 · Ballari District, Karnataka ·<br>India</p>

            <a href="${pageContext.request.contextPath}/contact.jsp" class="contact-btn"> 
                CONTACT US <i class="fa-solid fa-arrow-right"></i>
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