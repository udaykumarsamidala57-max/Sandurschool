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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/peacock.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/site-font.css">

    <style>
        /* =========================================================
           HEADER - one line with a wide menu
           Thin brown strip on top (quick links), then one white bar:
           logo and name on the left, menu on the right, search.
           A menu item with sub-pages opens a full-width panel.
           Below 1100px the menu folds into a drawer (button with
           three lines), sub-pages open by tapping the arrow.
           ========================================================= */

        header.srs-header {
            --h-brown: #612405;
            --h-brown-deep: #3b1603;
            --h-orange: #e0701b;
            --h-gold: #c99a3c;
            --h-line: #eadfd3;

            position: sticky;
            top: -32px;               /* the brown strip scrolls away, the white bar stays */
            z-index: 1000;
            width: 100%;
            padding: 0;
            background: #ffffff;
            box-shadow: 0 8px 22px -16px rgba(59, 22, 3, 0.45);
        }

        /* ---------- top brown strip ---------- */
        header.srs-header .top-ribbon {
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 0 clamp(16px, 3vw, 40px);
            background: var(--h-brown);
            color: #ffffff;
            font-size: 11.5px;
            letter-spacing: 0.03em;
        }
        header.srs-header .ribbon-left {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            opacity: 0.92;
        }
        header.srs-header .ribbon-right {
            display: flex;
            align-items: center;
            gap: 20px;
            white-space: nowrap;
        }
        header.srs-header .ribbon-right a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            transition: color 0.2s ease;
        }
        header.srs-header .ribbon-right a:hover { color: #ffd9b8; }
        header.srs-header .ribbon-right .sep {
            width: 1px;
            height: 12px;
            background: rgba(255, 255, 255, 0.3);
        }

        /* ---------- white bar ---------- */
        header.srs-header .hdr-bar {
            position: relative;
            display: flex;
            align-items: center;
            gap: clamp(12px, 2vw, 28px);
            min-height: 96px;
            padding: 0 clamp(16px, 3vw, 40px);
            background: #ffffff;
            border-bottom: 3px solid var(--h-orange);
        }

        header.srs-header .hdr-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 0 0 auto;
            text-decoration: none;
        }
        header.srs-header .hdr-logo img {
            height: clamp(66px, 5.8vw, 84px);
            width: auto;
            display: block;
            object-fit: contain;
        }
        header.srs-header .hdr-name {
            display: block;
            max-width: none;
            white-space: nowrap;
            margin: 0;
            color: var(--h-brown);
            font-size: clamp(20px, 1.75vw, 25px);
            font-weight: 700;
            line-height: 1.22;
        }
        header.srs-header .hdr-name small {
            display: block;
            margin-top: 4px;
            color: #9a3f12;
            font-size: 10.5px;
            font-weight: 400;
            letter-spacing: 0.18em;
            text-transform: uppercase;
        }

        /* ---------- menu (desktop) ---------- */
        header.srs-header nav.hdr-nav {
            position: static;
            display: block;
            margin-left: auto;
            background: none;
            border: none;
            box-shadow: none;
        }
        header.srs-header nav.hdr-nav .main-menu {
            display: flex;
            align-items: stretch;
            justify-content: flex-end;
            margin: 0;
            padding: 0;
            list-style: none;
            background: none;
        }
        header.srs-header nav.hdr-nav .main-menu > li {
            position: static;
            display: flex;
            align-items: stretch;
        }
        header.srs-header nav.hdr-nav .main-menu > li > a {
            position: relative;
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 0 clamp(8px, 0.95vw, 14px);
            min-height: 96px;
            background: none;
            border: none;
            color: var(--h-brown-deep);
            font-size: clamp(12.5px, 1vw, 14px);
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
            transition: color 0.2s ease;
        }
        header.srs-header nav.hdr-nav .main-menu > li > a i {
            font-size: 10px;
            opacity: 0.6;
            transition: transform 0.25s ease;
        }
        /* orange line under the selected / pointed item */
        header.srs-header nav.hdr-nav .main-menu > li > a::after {
            content: '';
            position: absolute;
            left: clamp(8px, 0.95vw, 14px);
            right: clamp(8px, 0.95vw, 14px);
            bottom: 28px;
            height: 3px;
            background: var(--h-orange);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.25s ease;
        }
        header.srs-header nav.hdr-nav .main-menu > li:hover > a,
        header.srs-header nav.hdr-nav .main-menu > li:focus-within > a,
        header.srs-header nav.hdr-nav .main-menu > li.active-tab > a {
            background: none;
            color: var(--h-brown);
        }
        header.srs-header nav.hdr-nav .main-menu > li:hover > a::after,
        header.srs-header nav.hdr-nav .main-menu > li.active-tab > a::after {
            transform: scaleX(1);
        }
        header.srs-header nav.hdr-nav .main-menu > li:hover > a i {
            transform: rotate(180deg);
            opacity: 1;
        }
        header.srs-header .sub-toggle { display: none; }

        /* ---------- full-width panel ---------- */
        header.srs-header nav.hdr-nav .mega {
            position: absolute;
            left: 0;
            right: 0;
            top: calc(100% + 3px);
            z-index: 1001;
            display: block;
            visibility: hidden;
            opacity: 0;
            transform: translateY(8px);
            margin: 0;
            padding: 0;
            background: #ffffff;
            border-top: 1px solid var(--h-line);
            box-shadow: 0 22px 34px -20px rgba(59, 22, 3, 0.5);
            transition: opacity 0.2s ease, transform 0.2s ease, visibility 0s linear 0.2s;
        }
        header.srs-header nav.hdr-nav .main-menu > li:hover > .mega,
        header.srs-header nav.hdr-nav .main-menu > li:focus-within > .mega {
            visibility: visible;
            opacity: 1;
            transform: none;
            transition: opacity 0.2s ease, transform 0.2s ease, visibility 0s;
        }
        header.srs-header .mega-inner {
            display: grid;
            grid-template-columns: 270px minmax(0, 1fr);
            gap: clamp(20px, 3vw, 40px);
            max-width: 1320px;
            margin: 0 auto;
            padding: 24px clamp(16px, 3vw, 40px) 28px;
        }
        header.srs-header .mega-lead {
            padding: 20px 22px;
            background: var(--h-brown);
            border-bottom: 4px solid var(--h-gold);
            color: #ffffff;
        }
        header.srs-header .mega-lead strong {
            display: block;
            margin-bottom: 6px;
            font-size: 20px;
            line-height: 1.25;
        }
        header.srs-header .mega-lead span {
            display: block;
            margin-bottom: 16px;
            font-size: 11px;
            letter-spacing: 0.16em;
            text-transform: uppercase;
            opacity: 0.8;
        }
        header.srs-header .mega-lead a {
            display: inline-block;
            color: #ffffff;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            text-decoration: none;
            border-bottom: 2px solid var(--h-orange);
            padding-bottom: 2px;
        }
        header.srs-header .mega-lead a:hover { color: #ffd9b8; }

        header.srs-header .mega-links {
            columns: 2;
            column-gap: clamp(20px, 3vw, 40px);
            margin: 0;
            padding: 0;
            list-style: none;
        }
        header.srs-header .mega-links li {
            break-inside: avoid;
            border-bottom: 1px solid #f1e6db;
            background: none;
        }
        header.srs-header .mega-links li a {
            display: block;
            padding: 11px 4px 11px 18px;
            position: relative;
            background: none;
            color: #2b1206;
            font-size: 13.5px;
            font-weight: 400;
            text-decoration: none;
            border: none;
            transition: color 0.2s ease, padding-left 0.2s ease;
        }
        header.srs-header .mega-links li a::before {
            content: '\203A';
            position: absolute;
            left: 4px;
            color: var(--h-orange);
            font-weight: 700;
        }
        header.srs-header .mega-links li a:hover,
        header.srs-header .mega-links li.active-child a {
            padding-left: 24px;
            color: var(--h-brown);
            font-weight: 700;
        }

        /* ---------- search and menu buttons ---------- */
        header.srs-header .hdr-search,
        header.srs-header .hdr-menu-btn {
            flex: 0 0 auto;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border: none;
            border-radius: 50%;
            background: var(--h-brown);
            color: #ffffff;
            font-size: 15px;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }
        header.srs-header .hdr-search:hover,
        header.srs-header .hdr-menu-btn:hover { background: var(--h-orange); }
        header.srs-header .hdr-menu-btn { display: none; border-radius: 0; }

        /* =========================================================
           TABLETS AND PHONES (below 1100px): menu becomes a drawer
           ========================================================= */
        @media (max-width: 1100px) {
            header.srs-header .ribbon-left { display: none; }
            header.srs-header .top-ribbon { justify-content: center; }
            header.srs-header .ribbon-right {
                gap: 14px;
                overflow-x: auto;
                scrollbar-width: none;
            }
            header.srs-header .ribbon-right::-webkit-scrollbar { display: none; }
            header.srs-header .ribbon-right {
                max-width: 100%;
                padding-right: 24px;
                -webkit-mask-image: linear-gradient(90deg, #000 85%, transparent);
                mask-image: linear-gradient(90deg, #000 85%, transparent);
            }

            header.srs-header .hdr-bar { min-height: 76px; gap: 10px; }
            header.srs-header .hdr-logo img { height: 60px; }
            header.srs-header .hdr-name { font-size: clamp(14px, 3.2vw, 21px); }
            header.srs-header .hdr-logo { min-width: 0; flex: 0 1 auto; }
            header.srs-header .hdr-search { margin-left: auto; }
            header.srs-header .hdr-menu-btn { display: inline-flex; }

            /* the drawer */
            header.srs-header nav.hdr-nav {
                position: absolute;
                left: 0;
                right: 0;
                top: calc(100% + 3px);
                display: none !important;
                max-height: calc(100vh - 110px);
                overflow-y: auto;
                margin: 0;
                background: #ffffff;
                box-shadow: 0 22px 34px -20px rgba(59, 22, 3, 0.55);
            }
            header.srs-header.menu-open nav.hdr-nav { display: block !important; }

            header.srs-header nav.hdr-nav .main-menu {
                flex-direction: column;
                align-items: stretch;
            }
            header.srs-header nav.hdr-nav .main-menu > li {
                display: grid;
                grid-template-columns: 1fr auto;
                border-bottom: 1px solid #f1e6db;
            }
            header.srs-header nav.hdr-nav .main-menu > li > a {
                min-height: 0;
                padding: 15px 20px;
                font-size: 15px;
            }
            header.srs-header nav.hdr-nav .main-menu > li > a i { display: none; }
            header.srs-header nav.hdr-nav .main-menu > li > a::after { display: none; }
            header.srs-header nav.hdr-nav .main-menu > li.active-tab > a {
                color: var(--h-orange);
                box-shadow: inset 4px 0 0 var(--h-orange);
            }

            header.srs-header .sub-toggle {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 54px;
                border: none;
                border-left: 1px solid #f1e6db;
                background: none;
                color: var(--h-brown);
                font-size: 14px;
                cursor: pointer;
            }
            header.srs-header .sub-toggle i { transition: transform 0.25s ease; }
            header.srs-header li.sub-open > .sub-toggle i { transform: rotate(180deg); }

            /* sub-pages open in place under their item */
            header.srs-header nav.hdr-nav .mega,
            header.srs-header nav.hdr-nav .main-menu > li:hover > .mega,
            header.srs-header nav.hdr-nav .main-menu > li:focus-within > .mega {
                grid-column: 1 / -1;
                position: static;
                display: none;
                visibility: visible;
                opacity: 1;
                transform: none;
                border-top: 1px solid #f1e6db;
                box-shadow: none;
                background: #fbf6f0;
                transition: none;
            }
            header.srs-header nav.hdr-nav .main-menu > li.sub-open > .mega { display: block; }
            header.srs-header .mega-inner { display: block; padding: 4px 0 8px; }
            header.srs-header .mega-lead { display: none; }
            header.srs-header .mega-links { columns: 1; }
            header.srs-header .mega-links li { border-bottom: none; }
            header.srs-header .mega-links li a { padding: 11px 20px 11px 40px; font-size: 14px; }
            header.srs-header .mega-links li a::before { left: 26px; }
            header.srs-header .mega-links li a:hover,
            header.srs-header .mega-links li.active-child a { padding-left: 40px; }
        }

        @media (max-width: 600px) {
            header.srs-header .hdr-bar { gap: 8px; padding: 0 12px; }
            header.srs-header .hdr-logo { gap: 8px; }
            header.srs-header .hdr-name { font-size: clamp(13px, 4.1vw, 17px); }
            header.srs-header .hdr-logo img { height: 46px; }
            header.srs-header .hdr-search,
            header.srs-header .hdr-menu-btn { width: 36px; height: 36px; font-size: 14px; }
        }

        @media (prefers-reduced-motion: reduce) {
            header.srs-header * { transition: none !important; }
        }

        /* =========================================================
           POLISH
           ========================================================= */

        /* top strip: small icons, gold hairline at the bottom */
        header.srs-header .top-ribbon { border-bottom: 1px solid rgba(201, 154, 60, 0.55); }
        header.srs-header .top-ribbon i {
            margin-right: 6px;
            color: #f0b67c;
            font-size: 10.5px;
        }
        header.srs-header .ribbon-right a { display: inline-flex; align-items: center; }

        /* white bar: soft warm tint, brown line with orange on top */
        header.srs-header .hdr-bar {
            background: linear-gradient(180deg, #ffffff 0%, #fffaf4 100%);
            border-bottom: 3px solid var(--h-orange);
            box-shadow: 0 3px 0 -1px var(--h-brown);
            transition: min-height 0.3s ease;
        }

        /* logo and name: gold divider between them */
        header.srs-header .hdr-logo { gap: 16px; }
        header.srs-header .hdr-logo img { transition: height 0.3s ease; }
        header.srs-header .hdr-name {
            padding-left: 16px;
            border-left: 2px solid var(--h-gold);
            letter-spacing: 0.01em;
            transition: font-size 0.3s ease;
        }

        /* menu: hover turns the text orange-brown, rounded gradient underline */
        header.srs-header nav.hdr-nav .main-menu > li > a { transition: color 0.2s ease, min-height 0.3s ease; }
        header.srs-header nav.hdr-nav .main-menu > li:hover > a { color: #b8542b; }
        header.srs-header nav.hdr-nav .main-menu > li.active-tab > a { color: var(--h-brown); }
        header.srs-header nav.hdr-nav .main-menu > li > a::after {
            border-radius: 2px;
            background: linear-gradient(90deg, var(--h-orange), var(--h-gold));
        }

        /* search: outlined circle that fills on hover */
        header.srs-header .hdr-search {
            background: #ffffff;
            color: var(--h-brown);
            box-shadow: inset 0 0 0 2px var(--h-brown);
        }
        header.srs-header .hdr-search:hover {
            background: var(--h-brown);
            color: #ffffff;
        }

        /* smaller laptops: tighter spacing so everything fits on one line */
        @media (min-width: 1101px) and (max-width: 1300px) {
            header.srs-header .hdr-bar { gap: 12px; }
            header.srs-header .hdr-logo { gap: 10px; }
            header.srs-header .hdr-logo img { height: 62px; }
            header.srs-header .hdr-name { padding-left: 10px; font-size: 19px; }
            header.srs-header nav.hdr-nav .main-menu > li > a { padding: 0 8px; font-size: 12.5px; }
            header.srs-header nav.hdr-nav .main-menu > li > a::after { left: 8px; right: 8px; }
        }

        /* compact bar after scrolling (desktop) */
        @media (min-width: 1101px) {
            header.srs-header.is-scrolled .hdr-bar { min-height: 72px; }
            header.srs-header.is-scrolled nav.hdr-nav .main-menu > li > a { min-height: 72px; }
            header.srs-header.is-scrolled nav.hdr-nav .main-menu > li > a::after { bottom: 18px; }
            header.srs-header.is-scrolled .hdr-logo img { height: 56px; }
            header.srs-header.is-scrolled .hdr-name { font-size: 20px; }
        }
        /* compact bar after scrolling (tablets and phones) */
        @media (max-width: 1100px) {
            header.srs-header.is-scrolled .hdr-bar { min-height: 64px; }
            header.srs-header.is-scrolled .hdr-logo img { height: 46px; }
            header.srs-header .hdr-logo { gap: 12px; }
            header.srs-header .hdr-name { padding-left: 12px; }
        }
        @media (max-width: 600px) {
            header.srs-header .hdr-logo { gap: 8px; }
            header.srs-header .hdr-name { padding-left: 8px; border-left-width: 1.5px; }
            header.srs-header.is-scrolled .hdr-logo img { height: 40px; }
            header.srs-header.is-scrolled .hdr-bar { min-height: 58px; }
        }

        /* =========================================================
           MORE POLISH
           ========================================================= */

        /* top strip: thin dividers between the links */
        header.srs-header .ribbon-right a + a { position: relative; }
        header.srs-header .ribbon-right a + a::before {
            content: '';
            position: absolute;
            left: -10px;
            top: 50%;
            width: 1px;
            height: 10px;
            margin-top: -5px;
            background: rgba(255, 255, 255, 0.22);
        }
        header.srs-header .ribbon-right .sep { display: none; }
        header.srs-header .ribbon-left { letter-spacing: 0.06em; }

        /* white bar: faint peacock-feather pattern that fades in towards the right */
        header.srs-header .hdr-bar { isolation: isolate; }
        header.srs-header .hdr-bar::before {
            content: '';
            position: absolute;
            inset: 0;
            z-index: -1;
            background: url('${pageContext.request.contextPath}/Home/peacock/pattern.svg') repeat;
            background-size: 46px 52px;
            opacity: 0.07;
            -webkit-mask-image: linear-gradient(90deg, transparent 22%, #000 70%);
            mask-image: linear-gradient(90deg, transparent 22%, #000 70%);
            pointer-events: none;
        }

        /* menu: small gold diamonds between the items */
        header.srs-header nav.hdr-nav .main-menu > li + li > a::before {
            content: '';
            position: absolute;
            left: -2px;
            top: 50%;
            width: 4px;
            height: 4px;
            margin-top: -2px;
            background: var(--h-gold);
            opacity: 0.75;
            transform: rotate(45deg);
        }
        header.srs-header nav.hdr-nav .main-menu > li > a { font-weight: 700; letter-spacing: 0.01em; }

        /* school name: a touch more presence */
        header.srs-header .hdr-name { color: #57210a; text-shadow: 0 1px 0 #ffffff; }

        @media (max-width: 1100px) {
            header.srs-header nav.hdr-nav .main-menu > li + li > a::before { display: none; }
            header.srs-header .ribbon-right a + a::before { left: -7px; }
            header.srs-header .hdr-bar::before {
                -webkit-mask-image: linear-gradient(90deg, transparent 40%, #000 90%);
                mask-image: linear-gradient(90deg, transparent 40%, #000 90%);
            }
        }
    </style>
</head>

<body>

    <header class="srs-header">

        <!-- Top brown strip -->
        <div class="top-ribbon">
            <div class="ribbon-left">
                <i class="fa-solid fa-location-dot"></i> Shivapur, Sandur &middot; Ballari District, Karnataka &middot; Affiliated to CISCE
            </div>
            <div class="ribbon-right">
                <a href="${pageContext.request.contextPath}/homepage?slug=calendar"><i class="fa-regular fa-calendar"></i>Calendar</a>
                <a href="#"><i class="fa-solid fa-link"></i>Quick Links</a>
                <a href="#"><i class="fa-solid fa-user-lock"></i>Portal Login</a>
                <a href="${pageContext.request.contextPath}/homepage?slug=admissions"><i class="fa-solid fa-school"></i>Admissions</a>
                <a href="${pageContext.request.contextPath}/homepage?slug=Current job openings"><i class="fa-solid fa-briefcase"></i>Recruitment</a>
                <a href="${pageContext.request.contextPath}/homepage?slug=alumni"><i class="fa-solid fa-user-graduate"></i>Alumni</a>
            </div>
        </div>

        <!-- Logo, menu and search in one line -->
        <div class="hdr-bar">

            <a class="hdr-logo" href="${pageContext.request.contextPath}/homepage">
                <img src="${pageContext.request.contextPath}/Home/logo.png" alt="Sandur Residential School Logo">
                <h1 class="hdr-name">Sandur Residential School</h1>
            </a>

            <nav class="hdr-nav" aria-label="Main menu">
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
                                        <i class="fa fa-angle-down"></i>
                                    </c:if>
                                </a>

                                <c:if test="${not empty pg.children}">
                                    <button type="button" class="sub-toggle" aria-label="Show <c:out value='${pg.title}' /> pages" aria-expanded="false">
                                        <i class="fa fa-angle-down"></i>
                                    </button>

                                    <div class="mega">
                                        <div class="mega-inner">
                                            <div class="mega-lead">
                                                <strong><c:out value="${pg.title}" /></strong>
                                                <span>Sandur Residential School</span>
                                                <a href="${pageContext.request.contextPath}/homepage?slug=${pg.slug}">Go to <c:out value="${pg.title}" /> &rarr;</a>
                                            </div>
                                            <ul class="mega-links">
                                                <c:forEach var="child" items="${pg.children}">
                                                    <li class="${currentSlug eq child.slug ? 'active-child' : ''}">
                                                        <a href="${pageContext.request.contextPath}/homepage?slug=${child.slug}">
                                                            <c:out value="${child.title}" />
                                                        </a>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </c:if>
                            </li>
                        </c:if>
                    </c:forEach>
                </ul>
            </nav>

            <a href="#" class="hdr-search" aria-label="Search"><i class="fa fa-search"></i></a>

            <button type="button" class="hdr-menu-btn" aria-label="Open menu" aria-expanded="false">
                <i class="fa fa-bars"></i>
            </button>

        </div>
    </header>

    <script>
        /* Header: menu drawer and sub-page arrows on tablets and phones */
        (function () {
            var header = document.querySelector("header.srs-header");
            if (!header) return;
            var btn = header.querySelector(".hdr-menu-btn");

            btn.addEventListener("click", function () {
                var open = header.classList.toggle("menu-open");
                btn.setAttribute("aria-expanded", open ? "true" : "false");
                btn.querySelector("i").className = open ? "fa fa-xmark" : "fa fa-bars";
            });

            header.querySelectorAll(".sub-toggle").forEach(function (t) {
                t.addEventListener("click", function () {
                    var li = t.parentElement;
                    var open = li.classList.toggle("sub-open");
                    t.setAttribute("aria-expanded", open ? "true" : "false");
                });
            });

            /* open the section of the current page when the drawer is used */
            /* compact white bar once the page is scrolled */
            var ticking = false;
            function onScroll() {
                header.classList.toggle("is-scrolled", window.scrollY > 60);
                ticking = false;
            }
            window.addEventListener("scroll", function () {
                if (!ticking) { ticking = true; requestAnimationFrame(onScroll); }
            }, { passive: true });
            onScroll();

            var current = header.querySelector(".main-menu > li.active-tab");
            if (current && current.querySelector(".sub-toggle")) current.classList.add("sub-open");

            /* close the drawer when the screen grows back to desktop size */
            window.addEventListener("resize", function () {
                if (window.innerWidth > 1100 && header.classList.contains("menu-open")) {
                    header.classList.remove("menu-open");
                    btn.setAttribute("aria-expanded", "false");
                    btn.querySelector("i").className = "fa fa-bars";
                }
            });
        })();
    </script>

</body>
</html>
