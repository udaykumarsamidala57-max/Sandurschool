<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:out value="${not empty pageData.title ? pageData.title : 'Sandur Residential School'}" />
    </title>

    <link rel="icon" href="${pageContext.request.contextPath}/Home/logo.png?v=10" type="image/png">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/Home/logo.png?v=10" type="image/png">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/Home/logo.png?v=10">

    <!-- Fonts & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
                      href="${pageContext.request.contextPath}/css/header.css">
</head>
<body>
    <header>
        <!-- Desktop Top Ribbon -->
        <div class="top-bar">
            <div class="school-affiliation">
                <i class="fa-solid fa-graduation-cap"></i>
                <span>Sandur Residential School | Affiliated to CISCE, New Delhi</span>
            </div>
            <div class="top-links">
                <a href="mailto:mail@sandurschool.edu"><i class="fa-regular fa-envelope"></i> <span>mail@sandurschool.edu</span></a>
                <a href="${pageContext.request.contextPath}/homepage?slug=calendar"><i class="fa-regular fa-calendar-days"></i> <span>Calendar</span></a>
                <a href="https://srs.myclassboard.com/" target="_blank"><i class="fa-solid fa-right-to-bracket"></i> <span>Portal Login</span></a>
                <a href="#" class="btn-pill"><i class="fa-solid fa-briefcase"></i> <span>Careers</span></a>
            </div>
        </div>

        <!-- Main Header -->
        <div class="main-header">
            <div class="logo-area">
                <a href="${pageContext.request.contextPath}/homepage">
                    <img src="${pageContext.request.contextPath}/Home/logo.png" alt="Sandur Residential School Logo">
                </a>
            </div>

            <!-- Standard Web Navigation -->
            <div class="desktop-nav">
                <nav>
                    <ul class="main-menu">
                        <c:set var="currentSlug" value="${not empty param.slug ? param.slug : (not empty pageData.slug ? pageData.slug : 'home')}" />
                        <c:forEach var="pg" items="${pagesList}">
                            <c:if test="${pg.slug ne 'home'}">
                                <c:set var="isChildActive" value="false" />
                                <c:if test="${not empty pg.children}">
                                    <c:forEach var="child" items="${pg.children}">
                                        <c:if test="${child.slug eq currentSlug}">
                                            <c:set var="isChildActive" value="true" />
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <li class="${(currentSlug eq pg.slug or isChildActive) ? 'active-tab' : ''}">
                                    <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}">
                                        <c:out value="${pg.title}" />
                                        <c:if test="${not empty pg.children}">
                                            <i class="fa-solid fa-chevron-down"></i>
                                        </c:if>
                                    </a>
                                    <c:if test="${not empty pg.children}">
                                        <ul class="dropdown-menu">
                                            <c:forEach var="child" items="${pg.children}">
                                                <li class="${currentSlug eq child.slug ? 'active-child' : ''}">
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
                    </ul>
                </nav>
            </div>

            <!-- Mobile Trigger Button -->
            <button class="menu-btn-toggle" onclick="toggleMobileDrawer()" type="button" aria-label="Toggle navigation">
                <span>MENU</span>
                <i class="fa-solid fa-bars-staggered"></i>
            </button>
        </div>
    </header>

    <!-- Mobile Navigation Drawer -->
    <div class="mobile-drawer-overlay" id="drawerOverlay" onclick="toggleMobileDrawer()"></div>
    <aside class="mobile-drawer" id="mobileDrawer">
        <div class="drawer-header">
            <span>Navigation</span>
            <button class="drawer-close-btn" onclick="toggleMobileDrawer()" type="button" aria-label="Close menu">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        <div class="drawer-body">
            <ul class="mobile-menu">
                <c:forEach var="pg" items="${pagesList}">
                    <c:if test="${pg.slug ne 'home'}">
                        <c:set var="isChildActive" value="false" />
                        <c:if test="${not empty pg.children}">
                            <c:forEach var="child" items="${pg.children}">
                                <c:if test="${child.slug eq currentSlug}">
                                    <c:set var="isChildActive" value="true" />
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <li class="mobile-menu-item ${isChildActive ? 'expanded' : ''}">
                            <div style="display: flex; align-items: center; justify-content: space-between;">
                                <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}" 
                                   class="mobile-menu-link ${(currentSlug eq pg.slug or isChildActive) ? 'active-tab' : ''}" style="flex:1;">
                                    <c:out value="${pg.title}" />
                                </a>
                                <c:if test="${not empty pg.children}">
                                    <button type="button" class="submenu-toggle" onclick="toggleSubmenu(this)">
                                        <i class="fa-solid fa-chevron-down"></i>
                                    </button>
                                </c:if>
                            </div>

                            <c:if test="${not empty pg.children}">
                                <ul class="mobile-submenu">
                                    <c:forEach var="child" items="${pg.children}">
                                        <li class="${currentSlug eq child.slug ? 'active-child' : ''}">
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
            </ul>
        </div>
    </aside>

    <script>
        function toggleMobileDrawer() {
            const drawer = document.getElementById('mobileDrawer');
            const overlay = document.getElementById('drawerOverlay');
            drawer.classList.toggle('open');
            overlay.classList.toggle('active');
        }

        function toggleSubmenu(button) {
            const menuItem = button.closest('.mobile-menu-item');
            menuItem.classList.toggle('expanded');
        }
    </script>
</body>
</html>