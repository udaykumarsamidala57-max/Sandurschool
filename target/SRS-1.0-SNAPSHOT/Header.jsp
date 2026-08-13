<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
                        <!-- Exclude default home slug from duplicating in loop -->
                        <c:if test="${pg.slug ne 'home'}">
                            <li class="${(param.slug eq pg.slug || pageData.slug eq pg.slug) ? 'active-tab' : ''}">
                                <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}">
                                    <c:out value="${pg.title}" />
                                    <c:if test="${not empty pg.children}">
                                        <i class="fa fa-angle-down" style="font-size: 12px; margin-left: 5px;"></i>
                                    </c:if>
                                </a>

                                <!-- Submenu Dropdown Rendering -->
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
                        </c:if>
                    </c:forEach>
                </c:when>
            </c:choose>

        </ul>
    </nav>

</header>