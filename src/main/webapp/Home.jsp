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

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
      
    <c:if test="${not empty pageData.sections}">
        <c:forEach var="sec" items="${pageData.sections}">
            <c:set var="secType" value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

            <c:if test="${secType eq 'HERO'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero.css"></c:if>
            <c:if test="${secType eq 'DISTINCT'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/distinct.css"></c:if>
            <c:if test="${secType eq 'PERSON_DETAILS'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/person-details.css"></c:if>
            <c:if test="${secType eq 'DESC'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/desc.css"></c:if>
        </c:forEach>
    </c:if>

    <style>
        nav .main-menu { list-style: none; margin: 0; padding: 0; display: flex; background-color: #FAF8F7; }
        nav .main-menu > li { position: relative; }
        nav .main-menu > li > a { display: flex; align-items: center; gap: 6px; padding: 14px 23px; color: #000000; text-decoration: none; font-size: 15px; font-weight: 500; transition: background-color 0.2s ease; }
        nav .main-menu > li.active-tab > a, nav .main-menu > li:hover > a { background-color: #FAF8F7; color: #000000; }
        nav .dropdown-menu { display: none; position: absolute; top: 100%; left: 0; min-width: 210px; background-color: #612405; list-style: none; margin: 0; padding: 0; border: none; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); z-index: 1000; }
        nav .main-menu > li:hover .dropdown-menu { display: block; }
        nav .dropdown-menu li { border-bottom: none; background-color: #612405; }
        nav .dropdown-menu li a { display: block; padding: 12px 18px; color: #ffffff; text-decoration: none; font-size: 14px; background-color: #612405; transition: none; }
        nav .dropdown-menu li:hover, nav .dropdown-menu li:hover a, nav .dropdown-menu li a:hover, nav .dropdown-menu li.active-child, nav .dropdown-menu li.active-child a { background-color: #612405; color: #ffffff; }
    </style>

    <!-- Dynamic Stylesheets -->
    <c:if test="${not empty pageData.sections}">
        <c:forEach var="sec" items="${pageData.sections}">
            <c:set var="secType" value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

            <c:if test="${secType eq 'HERO'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/hero.css"></c:if>
            <c:if test="${secType eq 'DISTINCT'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/distinct.css"></c:if>
            <c:if test="${secType eq 'PERSON_DETAILS'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/person-details.css"></c:if>
            <c:if test="${secType eq 'DESC'}"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/desc.css"></c:if>
        </c:forEach>
    </c:if>
</head>

<body>
<%@ include file="Header.jsp" %>
   

    <main class="main-content">
        <c:forEach var="sec" items="${pageData.sections}">
            <c:set var="sType" value="${fn:toUpperCase(fn:trim(sec.sectionType))}" />

            <c:if test="${sType eq 'HERO'}"><%@ include file="views/sections/hero.jspf" %></c:if>
            <c:if test="${sType eq 'DISTINCT'}"><%@ include file="views/sections/distinct.jspf" %></c:if>
            <c:if test="${sType eq 'PERSON_DETAILS'}"><%@ include file="views/sections/person-details.jspf" %></c:if>
            <c:if test="${sType eq 'DESC'}"><%@ include file="views/sections/desc.jspf" %></c:if>
        </c:forEach>
    </main>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const menuToggle = document.querySelector(".menu-toggle");
            const nav = document.querySelector("nav");
            if (menuToggle && nav) {
                menuToggle.addEventListener("click", function () {
                    nav.classList.toggle("active");
                });
            }
        });
    </script>

    <script src="${pageContext.request.contextPath}/js/hero.js"></script>
    <script src="${pageContext.request.contextPath}/js/distinct.js"></script>

</body>
</html>