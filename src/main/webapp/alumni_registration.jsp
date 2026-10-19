<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alumni Registration &middot; Sandur Residential School</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* =========================================================
           ALUMNI REGISTRATION  -  page styles (only this page)
           ========================================================= */
        .alu {
            --ink: #22140b;
            --ink-2: #4b3a2e;
            --muted: #85756a;
            --brown: #612405;
            --brown-deep: #2e1102;
            --orange: #e0701b;
            --gold: #c99a3c;
            --line: #e7ddd3;
            --line-2: #d4c5b7;
            --paper: #faf6f1;
            --ok: #2f7a3e;
            --bad: #b3261e;
            color: var(--ink);
            background: var(--paper);
        }
        .alu *, .alu *::before, .alu *::after { box-sizing: border-box; }

        /* ---------- top band ---------- */
        .alu-band {
            position: relative;
            overflow: hidden;
            background: var(--brown-deep);
            color: #fff;
        }
        .alu-band::before {                     /* fine diagonal lines */
            content: '';
            position: absolute; inset: 0;
            background: repeating-linear-gradient(135deg, rgba(255,255,255,.035) 0 1px, transparent 1px 14px);
        }
        .alu-band::after {                      /* orange + gold rule at the bottom */
            content: '';
            position: absolute; left: 0; right: 0; bottom: 0; height: 4px;
            background: linear-gradient(90deg, var(--orange) 0 70%, var(--gold) 70% 100%);
        }
        .alu-band-in {
            position: relative;
            max-width: 1180px; margin: 0 auto;
            padding: 54px 24px 58px;
            display: grid; grid-template-columns: 1fr auto; gap: 32px; align-items: end;
        }
        .alu-eyebrow {
            display: inline-flex; align-items: center; gap: 12px;
            margin: 0 0 16px;
            color: var(--gold);
            font-size: 12px; font-weight: 700; letter-spacing: .22em; text-transform: uppercase;
        }
        .alu-eyebrow::before { content: ''; width: 34px; height: 2px; background: var(--orange); }
        .alu-band h1 {
            margin: 0;
            font-size: clamp(30px, 4.2vw, 46px); font-weight: 900; line-height: 1.12; letter-spacing: -.01em;
        }
        .alu-band .lead {
            margin: 16px 0 0; max-width: 620px;
            color: rgba(255,255,255,.78); font-size: 15.5px; line-height: 1.8;
        }
        .alu-facts { display: flex; gap: 0; border: 1px solid rgba(255,255,255,.18); }
        .alu-facts div { padding: 14px 22px; min-width: 128px; }
        .alu-facts div + div { border-left: 1px solid rgba(255,255,255,.18); }
        .alu-facts b { display: block; font-size: 22px; font-weight: 900; color: #fff; }
        .alu-facts span { display: block; margin-top: 3px; color: rgba(255,255,255,.62); font-size: 11.5px; letter-spacing: .08em; text-transform: uppercase; }

        /* ---------- layout ---------- */
        .alu-body {
            max-width: 1180px; margin: 0 auto;
            padding: 40px 24px 80px;
            display: grid; grid-template-columns: 300px minmax(0, 1fr); gap: 36px; align-items: start;
        }
        .alu-side { position: sticky; top: 104px; display: grid; gap: 20px; }

        /* ---------- live member card ---------- */
        .alu-mcard {
            position: relative; overflow: hidden;
            aspect-ratio: 1.586;
            padding: 20px 22px;
            background: linear-gradient(150deg, #6d2a07 0%, #3d1603 62%, #2a0e01 100%);
            color: #fff;
            box-shadow: 0 22px 40px -24px rgba(46,17,2,.8);
            display: flex; flex-direction: column;
        }
        .alu-mcard::before {
            content: ''; position: absolute; right: -60px; top: -60px;
            width: 200px; height: 200px; border-radius: 50%;
            border: 26px solid rgba(201,154,60,.13);
        }
        .alu-mcard::after {
            content: ''; position: absolute; left: 0; right: 0; bottom: 0; height: 4px;
            background: linear-gradient(90deg, var(--orange), var(--gold));
        }
        .alu-mcard .top { display: flex; justify-content: space-between; align-items: flex-start; position: relative; }
        .alu-mcard .org { font-size: 10px; letter-spacing: .2em; text-transform: uppercase; color: var(--gold); font-weight: 700; line-height: 1.6; }
        .alu-mcard .crest {
            width: 34px; height: 34px; border: 1.5px solid var(--gold); border-radius: 50%;
            display: flex; align-items: center; justify-content: center; color: var(--gold); font-size: 14px;
        }
        .alu-mcard .who { margin-top: auto; position: relative; }
        .alu-mcard .name {
            font-size: 17px; font-weight: 700; line-height: 1.3;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .alu-mcard .name.empty { color: rgba(255,255,255,.45); font-weight: 400; font-style: italic; }
        .alu-mcard .meta { display: flex; gap: 22px; margin-top: 10px; }
        .alu-mcard .meta span { display: block; font-size: 9px; letter-spacing: .16em; text-transform: uppercase; color: rgba(255,255,255,.55); }
        .alu-mcard .meta b { display: block; margin-top: 2px; font-size: 13px; font-weight: 700; }
        .alu-side .cap { margin: -10px 0 0; color: var(--muted); font-size: 12px; text-align: center; }

        /* ---------- section list + progress ---------- */
        .alu-steps { background: #fff; border: 1px solid var(--line); }
        .alu-steps .hd { padding: 16px 18px 14px; border-bottom: 1px solid var(--line); }
        .alu-steps .hd p { margin: 0 0 10px; display: flex; justify-content: space-between; font-size: 12px; color: var(--muted); letter-spacing: .06em; text-transform: uppercase; font-weight: 700; }
        .alu-steps .hd p b { color: var(--brown); }
        .alu-bar { height: 4px; background: #efe6dd; }
        .alu-bar i { display: block; height: 100%; width: 0; background: var(--orange); transition: width .35s ease; }
        .alu-steps ol { list-style: none; margin: 0; padding: 6px 0; }
        .alu-steps li a {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 18px;
            color: var(--ink-2); text-decoration: none; font-size: 13.5px;
            border-left: 3px solid transparent;
            transition: background-color .15s ease, color .15s ease;
        }
        .alu-steps li a:hover { background: var(--paper); color: var(--ink); }
        .alu-steps li.on a { border-left-color: var(--brown); background: var(--paper); color: var(--ink); font-weight: 700; }
        .alu-steps .n {
            flex: none; width: 26px; height: 26px;
            display: flex; align-items: center; justify-content: center;
            border: 1.5px solid var(--line-2); border-radius: 50%;
            font-size: 11px; font-weight: 700; color: var(--muted);
            transition: all .2s ease;
        }
        .alu-steps li.on .n { border-color: var(--brown); color: var(--brown); }
        .alu-steps .n em { font-style: normal; }
        .alu-steps .n i { display: none; font-size: 11px; }
        .alu-steps li.done .n { background: var(--ok); border-color: var(--ok); color: #fff; }
        .alu-steps li.done .n em { display: none; }
        .alu-steps li.done .n i { display: inline; }

        .alu-help { padding: 16px 18px; border: 1px solid var(--line); background: #fff; font-size: 13px; line-height: 1.7; color: var(--ink-2); }
        .alu-help b { display: block; margin-bottom: 4px; color: var(--ink); font-size: 13px; }

        /* ---------- form card ---------- */
        .alu-card { background: #fff; border: 1px solid var(--line); box-shadow: 0 30px 60px -48px rgba(46,17,2,.55); }
        .alu-sec { display: grid; grid-template-columns: 64px minmax(0, 1fr); gap: 0 8px; padding: 34px 40px 36px 28px; scroll-margin-top: 100px; }
        .alu-sec + .alu-sec { border-top: 1px solid var(--line); }
        .alu-sec .num { font-size: 26px; font-weight: 900; color: var(--orange); line-height: 1; padding-top: 2px; letter-spacing: -.02em; }
        .alu-sec h2 { margin: 0; font-size: 19px; font-weight: 900; color: var(--ink); }
        .alu-sec .sub { margin: 6px 0 24px; color: var(--muted); font-size: 13.5px; line-height: 1.6; }

        .alu-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px 22px; }
        .alu-grid .full { grid-column: 1 / -1; }

        .alu-f label, .alu-f .lbl {
            display: block; margin-bottom: 8px;
            color: var(--ink-2); font-size: 11.5px; font-weight: 700; letter-spacing: .1em; text-transform: uppercase;
        }
        .alu-f .req { color: var(--orange); margin-left: 2px; }
        .alu-f .opt { color: var(--muted); font-weight: 400; letter-spacing: .04em; text-transform: none; font-size: 12px; margin-left: 4px; }
        .alu-f input, .alu-f textarea {
            display: block; width: 100%;
            height: 48px; padding: 0 14px;
            border: 1px solid var(--line-2); border-radius: 0;
            background: #fff; color: var(--ink);
            font: inherit; font-size: 15px;
            box-shadow: inset 0 1px 0 rgba(46,17,2,.03);
            transition: border-color .15s ease, box-shadow .15s ease, background-color .15s ease;
            -webkit-appearance: none; appearance: none;
        }
        .alu-f input[type=date] { padding-right: 10px; }
        .alu-f textarea { height: auto; min-height: 104px; padding: 12px 14px; line-height: 1.65; resize: vertical; }
        .alu-f input::placeholder, .alu-f textarea::placeholder { color: #b3a598; }
        .alu-f input:hover, .alu-f textarea:hover { border-color: #b9a796; }
        .alu-f input:focus, .alu-f textarea:focus {
            outline: none; border-color: var(--brown);
            box-shadow: inset 0 0 0 1px var(--brown), 0 0 0 4px rgba(97,36,5,.08);
        }
        .alu-f.bad input, .alu-f.bad textarea { border-color: var(--bad); box-shadow: inset 0 0 0 1px var(--bad); background: #fffafa; }
        .alu-f .msg { display: none; margin-top: 7px; color: var(--bad); font-size: 12.5px; }
        .alu-f .msg::before { content: '\f06a'; font-family: 'Font Awesome 6 Free' !important; font-weight: 900; margin-right: 6px; }
        .alu-f.bad .msg { display: block; }
        .alu-f .hint { margin-top: 7px; color: var(--muted); font-size: 12.5px; }
        .alu-f.bad .hint { display: none; }

        .alu-pair { display: grid; grid-template-columns: 1fr 1fr; }
        .alu-pair > div { position: relative; }
        .alu-pair > div + div input { border-left-width: 0; }
        .alu-pair > div + div input:focus { border-left-width: 1px; }
        .alu-pair small {
            position: absolute; left: 14px; top: 7px; z-index: 1;
            color: var(--muted); font-size: 10px; letter-spacing: .12em; text-transform: uppercase; pointer-events: none;
        }
        .alu-pair input { height: 56px; padding-top: 18px; font-weight: 700; font-size: 16px; }

        .alu-batch {
            display: none; margin-top: 18px; padding: 12px 16px;
            border: 1px dashed var(--line-2); background: var(--paper);
            color: var(--ink-2); font-size: 13.5px;
        }
        .alu-batch.show { display: flex; align-items: center; gap: 10px; }
        .alu-batch i { color: var(--orange); }

        /* ---------- declaration ---------- */
        .alu-declare {
            display: grid; grid-template-columns: 26px 1fr; gap: 14px; align-items: start;
            padding: 18px 20px; border: 1px solid var(--line-2); background: var(--paper);
            position: relative; cursor: pointer; color: var(--ink-2); font-size: 14px; line-height: 1.7;
            transition: border-color .15s ease, background-color .15s ease;
        }
        .alu-declare:hover { border-color: #b9a796; }
        .alu-declare input { position: absolute; opacity: 0; width: 1px; height: 1px; }
        .alu-declare .box {
            width: 24px; height: 24px; margin-top: 2px;
            border: 1.5px solid var(--line-2); background: #fff;
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 12px; transition: all .15s ease;
        }
        .alu-declare .box i { opacity: 0; transform: scale(.6); transition: all .15s ease; }
        .alu-declare input:checked + .box { background: var(--brown); border-color: var(--brown); }
        .alu-declare input:checked + .box i { opacity: 1; transform: none; }
        .alu-declare input:focus-visible + .box { box-shadow: 0 0 0 4px rgba(97,36,5,.15); }
        .alu-declare.checked { border-color: var(--brown); background: #fff; }
        .alu-declare.bad { border-color: var(--bad); }

        .alu-sign { display: grid; grid-template-columns: 220px 1fr; gap: 22px; margin-top: 24px; }
        .alu-date {
            height: 48px; padding: 0 14px;
            display: flex; align-items: center; gap: 10px;
            border: 1px solid var(--line); background: var(--paper);
            color: var(--ink); font-size: 15px; font-weight: 700;
        }
        .alu-date i { color: var(--muted); font-weight: 400; }
        .alu-f.sig input {
            height: 56px; padding: 14px 4px 0;
            border: none; border-bottom: 2px solid var(--ink); box-shadow: none;
            background: transparent;
            font-size: 20px; font-style: italic; color: var(--brown);
        }
        .alu-f.sig input:focus { border-bottom-color: var(--orange); box-shadow: none; }
        .alu-f.sig.bad input { border-bottom-color: var(--bad); box-shadow: none; background: transparent; }

        /* ---------- submit bar ---------- */
        .alu-submit {
            display: flex; align-items: center; justify-content: space-between; gap: 20px;
            padding: 22px 40px 22px 28px;
            border-top: 1px solid var(--line); background: var(--paper);
        }
        .alu-submit p { margin: 0; color: var(--muted); font-size: 12.5px; line-height: 1.6; }
        .alu-submit p i { color: var(--ok); margin-right: 6px; }
        .alu-actions { display: flex; gap: 10px; flex: none; }
        .alu-btn {
            display: inline-flex; align-items: center; justify-content: center; gap: 10px;
            height: 50px; padding: 0 28px;
            border: 1px solid var(--brown); border-radius: 0;
            background: var(--brown); color: #fff;
            font: inherit; font-size: 13px; font-weight: 700; letter-spacing: .12em; text-transform: uppercase;
            text-decoration: none; cursor: pointer;
            transition: background-color .15s ease, border-color .15s ease, transform .15s ease;
        }
        .alu-btn:hover { background: var(--brown-deep); border-color: var(--brown-deep); }
        .alu-btn:active { transform: translateY(1px); }
        .alu-btn i { transition: transform .2s ease; }
        .alu-btn:hover i.fa-arrow-right { transform: translateX(4px); }
        .alu-btn.ghost { background: #fff; color: var(--ink); border-color: var(--line-2); }
        .alu-btn.ghost:hover { border-color: var(--ink); background: #fff; }
        .alu-btn[disabled] { opacity: .7; cursor: wait; }

        /* ---------- server-side errors ---------- */
        .alu-errors {
            display: grid; grid-template-columns: 36px 1fr; gap: 14px;
            margin: 0; padding: 20px 40px 20px 28px;
            background: #fdf1f0; border-bottom: 1px solid #f2cfcb; border-left: 4px solid var(--bad);
            color: #6e1610; font-size: 14px;
        }
        .alu-errors .ic { width: 36px; height: 36px; border-radius: 50%; background: var(--bad); color: #fff; display: flex; align-items: center; justify-content: center; }
        .alu-errors b { display: block; margin: 6px 0 6px; }
        .alu-errors ul { margin: 0; padding-left: 18px; line-height: 1.8; }
        .alu-trap { position: absolute; left: -9999px; width: 1px; height: 1px; overflow: hidden; }

        /* ---------- thank-you ---------- */
        .alu-done-wrap { max-width: 760px; margin: 0 auto; padding: 48px 24px 90px; }
        .alu-done { background: #fff; border: 1px solid var(--line); box-shadow: 0 30px 60px -48px rgba(46,17,2,.55); }
        .alu-done .top { padding: 44px 44px 34px; text-align: center; }
        .alu-done .seal {
            width: 76px; height: 76px; margin: 0 auto 22px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            background: var(--ok); color: #fff; font-size: 30px;
            box-shadow: 0 0 0 8px #e5f1e7;
            animation: alu-pop .5s cubic-bezier(.2,1.4,.4,1) both;
        }
        @keyframes alu-pop { from { transform: scale(.4); opacity: 0; } to { transform: none; opacity: 1; } }
        .alu-done h2 { margin: 0 0 10px; font-size: 26px; font-weight: 900; }
        .alu-done .top p { margin: 0 auto; max-width: 500px; color: var(--ink-2); font-size: 15px; line-height: 1.75; }
        .alu-ticket {
            display: flex; align-items: stretch; margin: 28px auto 0; max-width: 460px;
            border: 1.5px solid var(--brown);
        }
        .alu-ticket .l { flex: 1; padding: 14px 18px; text-align: left; }
        .alu-ticket .l span { display: block; font-size: 10.5px; letter-spacing: .18em; text-transform: uppercase; color: var(--muted); font-weight: 700; }
        .alu-ticket .l b { display: block; margin-top: 4px; font-size: 20px; color: var(--brown); letter-spacing: .04em; }
        .alu-ticket button {
            flex: none; width: 92px; border: none; border-left: 1.5px dashed var(--brown);
            background: var(--paper); color: var(--brown);
            font: inherit; font-size: 11px; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; cursor: pointer;
        }
        .alu-ticket button:hover { background: #f3e8dc; }
        .alu-ticket button i { display: block; font-size: 16px; margin-bottom: 4px; }
        .alu-next { display: grid; grid-template-columns: repeat(3, 1fr); border-top: 1px solid var(--line); }
        .alu-next div { padding: 22px 22px 24px; }
        .alu-next div + div { border-left: 1px solid var(--line); }
        .alu-next b { display: block; margin: 0 0 6px; font-size: 14px; }
        .alu-next b em { font-style: normal; color: var(--orange); margin-right: 8px; }
        .alu-next p { margin: 0; color: var(--muted); font-size: 13px; line-height: 1.65; }
        .alu-done .foot { display: flex; justify-content: center; gap: 10px; padding: 22px; border-top: 1px solid var(--line); background: var(--paper); }

        /* ---------- small screens ---------- */
        @media (max-width: 1000px) {
            .alu-body { grid-template-columns: 1fr; gap: 24px; padding-top: 24px; }
            .alu-side { position: static; grid-template-columns: 1fr; }
            .alu-side .alu-steps, .alu-side .alu-help { display: none; }
            .alu-mcard { max-width: 380px; width: 100%; margin: 0 auto; }
            .alu-mobbar { display: block !important; }
        }
        .alu-mobbar {
            display: none; position: sticky; top: 76px; z-index: 5;
            padding: 12px 20px; background: #fff; border-bottom: 1px solid var(--line);
            font-size: 12px; color: var(--muted); letter-spacing: .06em; text-transform: uppercase; font-weight: 700;
        }
        .alu-mobbar p { margin: 0 0 8px; display: flex; justify-content: space-between; }
        .alu-mobbar p b { color: var(--brown); }
        @media (max-width: 760px) {
            .alu-band-in { grid-template-columns: 1fr; padding: 38px 18px 42px; gap: 24px; }
            .alu-facts div { padding: 12px 16px; min-width: 0; flex: 1; }
            .alu-body { padding: 18px 12px 56px; }
            .alu-sec { grid-template-columns: 1fr; padding: 26px 18px 28px; }
            .alu-sec .num { font-size: 13px; margin-bottom: 8px; letter-spacing: .14em; }
            .alu-grid, .alu-sign { grid-template-columns: 1fr; }
            .alu-errors { padding: 18px; }
            .alu-submit { flex-direction: column; align-items: stretch; padding: 20px 18px; }
            .alu-actions { flex-direction: column-reverse; }
            .alu-btn { width: 100%; }
            .alu-done .top { padding: 34px 20px 26px; }
            .alu-next { grid-template-columns: 1fr; }
            .alu-next div + div { border-left: none; border-top: 1px solid var(--line); }
        }
    </style>
</head>
<body>

<%@ include file="Header.jsp" %>

<div class="alu">

    <%-- ===== top band ===== --%>
    <section class="alu-band">
        <div class="alu-band-in">
            <div>
                <p class="alu-eyebrow">SRS Alumni Association</p>
                <h1><c:choose><c:when test="${not empty doneNo}">Welcome back to SRS</c:when><c:otherwise>Alumni Registration</c:otherwise></c:choose></h1>
                <c:choose>
                    <c:when test="${not empty doneNo}">
                        <p class="lead">Your registration is now with the school office. We look forward to staying in touch.</p>
                    </c:when>
                    <c:otherwise>
                        <p class="lead">Studied at Sandur Residential School? Register with the Alumni Association and stay connected with your batch, your teachers and the school.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <c:if test="${empty doneNo}">
                <div class="alu-facts" aria-hidden="true">
                    <div><b>1959</b><span>Established</span></div>
                    <div><b>6</b><span>Short sections</span></div>
                    <div><b>3 min</b><span>To complete</span></div>
                </div>
            </c:if>
        </div>
    </section>

    <c:choose>
        <%-- ================= thank-you after saving ================= --%>
        <c:when test="${not empty doneNo}">
            <div class="alu-done-wrap">
                <div class="alu-done">
                    <div class="top">
                        <div class="seal"><i class="fa-solid fa-check"></i></div>
                        <h2>Thank you<c:if test="${not empty doneName}">, ${fn:escapeXml(doneName)}</c:if></h2>
                        <p>Your alumni registration has been received. Please keep your registration number for any future contact with the school.</p>
                        <div class="alu-ticket">
                            <div class="l">
                                <span>Registration number</span>
                                <b id="regNo">${fn:escapeXml(doneNo)}</b>
                            </div>
                            <button type="button" id="copyNo"><i class="fa-regular fa-copy"></i><span>Copy</span></button>
                        </div>
                    </div>
                    <div class="alu-next">
                        <div><b><em>01</em>Review</b><p>The school office checks your details against school records.</p></div>
                        <div><b><em>02</em>Confirmation</b><p>You are contacted on the phone number or email you gave.</p></div>
                        <div><b><em>03</em>Stay connected</b><p>Receive news of reunions, events and alumni activities.</p></div>
                    </div>
                    <div class="foot">
                        <a class="alu-btn" href="${pageContext.request.contextPath}/homepage">Back to home <i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </c:when>

        <%-- ================= the form ================= --%>
        <c:otherwise>
            <div class="alu-mobbar" aria-hidden="true">
                <p><span>Your progress</span><b><span class="js-count">0</span> / 6</b></p>
                <div class="alu-bar"><i class="js-bar"></i></div>
            </div>

            <div class="alu-body">

                <%-- ----- left: live card + sections ----- --%>
                <aside class="alu-side">
                    <div class="alu-mcard" aria-hidden="true">
                        <div class="top">
                            <div class="org">Sandur Residential School<br>Alumni Association</div>
                            <div class="crest"><i class="fa-solid fa-graduation-cap"></i></div>
                        </div>
                        <div class="who">
                            <div class="name empty" id="mcName">Your name</div>
                            <div class="meta">
                                <div><span>At SRS</span><b id="mcYears">&mdash;</b></div>
                                <div><span>Batch</span><b id="mcBatch">&mdash;</b></div>
                            </div>
                        </div>
                    </div>
                    <p class="cap">Your alumni card fills in as you type</p>

                    <nav class="alu-steps" aria-label="Form sections">
                        <div class="hd">
                            <p><span>Your progress</span><b><span class="js-count">0</span> / 6</b></p>
                            <div class="alu-bar"><i class="js-bar"></i></div>
                        </div>
                        <ol>
                            <li data-step="s1"><a href="#s1"><span class="n"><em>1</em><i class="fa-solid fa-check"></i></span>Personal details</a></li>
                            <li data-step="s2"><a href="#s2"><span class="n"><em>2</em><i class="fa-solid fa-check"></i></span>Years at SRS</a></li>
                            <li data-step="s3"><a href="#s3"><span class="n"><em>3</em><i class="fa-solid fa-check"></i></span>Education &amp; work</a></li>
                            <li data-step="s4"><a href="#s4"><span class="n"><em>4</em><i class="fa-solid fa-check"></i></span>Contact</a></li>
                            <li data-step="s5"><a href="#s5"><span class="n"><em>5</em><i class="fa-solid fa-check"></i></span>Anything else</a></li>
                            <li data-step="s6"><a href="#s6"><span class="n"><em>6</em><i class="fa-solid fa-check"></i></span>Declaration</a></li>
                        </ol>
                    </nav>

                    <div class="alu-help">
                        <b>Your details are safe</b>
                        They are used only by the school for alumni activities and are never shown on the website.
                    </div>
                </aside>

                <%-- ----- right: the form ----- --%>
                <form class="alu-card" id="aluForm" method="post" action="${pageContext.request.contextPath}/alumni-registration" novalidate>
                    <input type="hidden" name="token" value="${fn:escapeXml(token)}">
                    <div class="alu-trap" aria-hidden="true">
                        <label>Leave this empty <input type="text" name="website" tabindex="-1" autocomplete="off"></label>
                    </div>

                    <c:if test="${not empty errors}">
                        <div class="alu-errors" role="alert">
                            <span class="ic"><i class="fa-solid fa-exclamation"></i></span>
                            <div>
                                <b>Please correct the following and submit again</b>
                                <ul>
                                    <c:forEach var="e" items="${errors}"><li>${fn:escapeXml(e)}</li></c:forEach>
                                </ul>
                            </div>
                        </div>
                    </c:if>

                    <%-- 01 --%>
                    <section class="alu-sec" id="s1">
                        <div class="num">01</div>
                        <div>
                            <h2>Personal details</h2>
                            <p class="sub">As they appear in school records.</p>
                            <div class="alu-grid">
                                <div class="alu-f">
                                    <label for="fullName">Full name<span class="req">*</span></label>
                                    <input type="text" id="fullName" name="fullName" maxlength="150" required autocomplete="name"
                                           value="${fn:escapeXml(form.fullName)}" data-msg="Please enter your name.">
                                    <div class="msg"></div>
                                </div>
                                <div class="alu-f">
                                    <label for="dateOfBirth">Date of birth<span class="req">*</span></label>
                                    <input type="date" id="dateOfBirth" name="dateOfBirth" required max="${today}"
                                           value="${fn:escapeXml(form.dateOfBirth)}" data-msg="Please enter a valid date of birth.">
                                    <div class="msg"></div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <%-- 02 --%>
                    <section class="alu-sec" id="s2">
                        <div class="num">02</div>
                        <div>
                            <h2>Years at SRS</h2>
                            <p class="sub">The years you studied here, and the years you passed your board exams.</p>
                            <div class="alu-grid">
                                <div class="alu-f" id="fStudy">
                                    <span class="lbl">Years of study<span class="req">*</span></span>
                                    <div class="alu-pair">
                                        <div><small>From</small><input type="number" id="studyFrom" name="studyFrom" min="1959" max="${thisYear}" placeholder="1990" required inputmode="numeric" aria-label="Years of study from" value="${fn:escapeXml(form.studyFrom)}"></div>
                                        <div><small>To</small><input type="number" id="studyTo" name="studyTo" min="1959" max="${thisYear}" placeholder="2001" required inputmode="numeric" aria-label="Years of study to" value="${fn:escapeXml(form.studyTo)}"></div>
                                    </div>
                                    <div class="msg"></div>
                                </div>
                                <div class="alu-f" id="fPass">
                                    <span class="lbl">Year of passing<span class="opt">(if applicable)</span></span>
                                    <div class="alu-pair">
                                        <div><small>X Class</small><input type="number" id="passingX" name="passingX" min="1959" max="${thisYear}" placeholder="1999" inputmode="numeric" aria-label="Year of passing X Class" value="${fn:escapeXml(form.passingX)}"></div>
                                        <div><small>XII / PUC</small><input type="number" id="passingXii" name="passingXii" min="1959" max="${thisYear}" placeholder="2001" inputmode="numeric" aria-label="Year of passing XII or PUC" value="${fn:escapeXml(form.passingXii)}"></div>
                                    </div>
                                    <div class="msg"></div>
                                </div>
                            </div>
                            <div class="alu-batch" id="batchNote"><i class="fa-solid fa-user-graduate"></i><span></span></div>
                        </div>
                    </section>

                    <%-- 03 --%>
                    <section class="alu-sec" id="s3">
                        <div class="num">03</div>
                        <div>
                            <h2>Education &amp; work</h2>
                            <p class="sub">What you have done since leaving school. All optional.</p>
                            <div class="alu-grid">
                                <div class="alu-f full">
                                    <label for="qualification">Additional qualification</label>
                                    <input type="text" id="qualification" name="qualification" maxlength="255" placeholder="e.g. B.E. Mechanical, MBA"
                                           value="${fn:escapeXml(form.qualification)}">
                                </div>
                                <div class="alu-f">
                                    <label for="occupation">Occupation</label>
                                    <input type="text" id="occupation" name="occupation" maxlength="150" autocomplete="organization-title" placeholder="e.g. Engineer"
                                           value="${fn:escapeXml(form.occupation)}">
                                </div>
                                <div class="alu-f">
                                    <label for="organization">Organization &amp; place</label>
                                    <input type="text" id="organization" name="organization" maxlength="255" autocomplete="organization" placeholder="e.g. JSW Steel, Toranagallu"
                                           value="${fn:escapeXml(form.organization)}">
                                </div>
                            </div>
                        </div>
                    </section>

                    <%-- 04 --%>
                    <section class="alu-sec" id="s4">
                        <div class="num">04</div>
                        <div>
                            <h2>Contact</h2>
                            <p class="sub">How the school can reach you.</p>
                            <div class="alu-grid">
                                <div class="alu-f full">
                                    <label for="address">Mailing address<span class="req">*</span></label>
                                    <textarea id="address" name="address" maxlength="1000" rows="3" required autocomplete="street-address"
                                              placeholder="House / street, city, district, PIN code" data-msg="Please enter your mailing address.">${fn:escapeXml(form.address)}</textarea>
                                    <div class="msg"></div>
                                </div>
                                <div class="alu-f">
                                    <label for="contact">Contact number<span class="req">*</span></label>
                                    <input type="tel" id="contact" name="contact" maxlength="20" required autocomplete="tel" placeholder="+91 98765 43210"
                                           pattern="[+0-9 ()\-]{7,20}" value="${fn:escapeXml(form.contact)}" data-msg="Please enter a valid contact number.">
                                    <div class="msg"></div>
                                </div>
                                <div class="alu-f">
                                    <label for="email">Email<span class="req">*</span></label>
                                    <input type="email" id="email" name="email" maxlength="150" required autocomplete="email" placeholder="name@example.com"
                                           value="${fn:escapeXml(form.email)}" data-msg="Please enter a valid email address.">
                                    <div class="msg"></div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <%-- 05 --%>
                    <section class="alu-sec" id="s5">
                        <div class="num">05</div>
                        <div>
                            <h2>Anything else</h2>
                            <p class="sub">Optional. Anything you would like the school to know.</p>
                            <div class="alu-f">
                                <label for="additionalInfo">Additional information</label>
                                <textarea id="additionalInfo" name="additionalInfo" maxlength="2000" rows="4"
                                          placeholder="Achievements, memories, or how you would like to help the school">${fn:escapeXml(form.additionalInfo)}</textarea>
                                <div class="hint"><span id="infoCount">0</span> / 2000 characters</div>
                            </div>
                        </div>
                    </section>

                    <%-- 06 --%>
                    <section class="alu-sec" id="s6">
                        <div class="num">06</div>
                        <div>
                            <h2>Declaration</h2>
                            <p class="sub">Please confirm and sign.</p>

                            <label class="alu-declare" id="declareBox">
                                <input type="checkbox" name="declare" value="1" id="declare" required>
                                <span class="box"><i class="fa-solid fa-check"></i></span>
                                <span>I confirm that the details given above are correct, and I agree that the school may contact me about alumni activities.</span>
                            </label>

                            <div class="alu-sign">
                                <div class="alu-f">
                                    <span class="lbl">Date</span>
                                    <div class="alu-date"><i class="fa-regular fa-calendar"></i><span id="todayBox">${today}</span></div>
                                </div>
                                <div class="alu-f sig">
                                    <label for="signature">Signature<span class="req">*</span><span class="opt">type your full name</span></label>
                                    <input type="text" id="signature" name="signature" maxlength="150" required
                                           value="${fn:escapeXml(form.signature)}" data-msg="Please type your full name as your signature.">
                                    <div class="msg"></div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <div class="alu-submit">
                        <p><i class="fa-solid fa-lock"></i>Fields marked <b style="color:var(--orange)">*</b> are required. Your details are kept by the school only.</p>
                        <div class="alu-actions">
                            <a class="alu-btn ghost" href="${pageContext.request.contextPath}/homepage">Cancel</a>
                            <button type="submit" class="alu-btn" id="submitBtn">Submit registration <i class="fa-solid fa-arrow-right"></i></button>
                        </div>
                    </div>
                </form>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
(function () {
    var THIS_YEAR = new Date().getFullYear();
    function $(id) { return document.getElementById(id); }
    function val(id) { var e = $(id); return e ? e.value.trim() : ''; }
    function yr(id) { var v = val(id); return /^\d{4}$/.test(v) ? parseInt(v, 10) : null; }

    /* ---------- thank-you: copy the number ---------- */
    var copy = $('copyNo');
    if (copy) copy.addEventListener('click', function () {
        var t = $('regNo').textContent.trim();
        var done = function () { copy.querySelector('span').textContent = 'Copied'; };
        if (navigator.clipboard) navigator.clipboard.writeText(t).then(done, done); else done();
    });

    var form = $('aluForm');
    if (!form) return;

    /* ---------- today as dd-mm-yyyy ---------- */
    var box = $('todayBox');
    if (box) { var p = box.textContent.trim().split('-'); if (p.length === 3) box.textContent = p[2] + '-' + p[1] + '-' + p[0]; }

    /* ---------- checks for each field (the server checks again) ---------- */
    var checks = {
        fullName:    function () { return val('fullName') ? '' : 'Please enter your name.'; },
        dateOfBirth: function () {
            var v = val('dateOfBirth'); if (!v) return 'Please enter your date of birth.';
            return new Date(v) < new Date() ? '' : 'Please enter a valid date of birth.';
        },
        study: function () {
            var f = yr('studyFrom'), t = yr('studyTo');
            if (f === null || t === null) return 'Please enter both years (From and To).';
            if (f < 1959 || t > THIS_YEAR) return 'Years must be between 1959 and ' + THIS_YEAR + '.';
            if (t < f) return '"From" must not be after "To".';
            var dob = val('dateOfBirth');
            if (dob && parseInt(dob.slice(0, 4), 10) >= f) return 'Date of birth must be before your years of study.';
            return '';
        },
        pass: function () {
            var ok = function (id) { var v = val(id); if (!v) return true; var y = yr(id); return y !== null && y >= 1959 && y <= THIS_YEAR; };
            return ok('passingX') && ok('passingXii') ? '' : 'Years must be between 1959 and ' + THIS_YEAR + '.';
        },
        address:   function () { return val('address') ? '' : 'Please enter your mailing address.'; },
        contact:   function () { return /^[+0-9 ()-]{7,20}$/.test(val('contact')) ? '' : 'Please enter a valid contact number.'; },
        email:     function () { return /^[^@\s]+@[^@\s]+\.[^@\s]{2,}$/.test(val('email')) ? '' : 'Please enter a valid email address.'; },
        signature: function () { return val('signature') ? '' : 'Please type your full name as your signature.'; }
    };
    var wrapOf = {
        fullName: $('fullName').closest('.alu-f'), dateOfBirth: $('dateOfBirth').closest('.alu-f'),
        study: $('fStudy'), pass: $('fPass'),
        address: $('address').closest('.alu-f'), contact: $('contact').closest('.alu-f'),
        email: $('email').closest('.alu-f'), signature: $('signature').closest('.alu-f')
    };
    var touched = {};

    function show(key) {
        var msg = checks[key](), w = wrapOf[key];
        w.classList.toggle('bad', !!msg);
        w.querySelector('.msg').textContent = msg;
        w.querySelectorAll('input,textarea').forEach(function (i) { i.setAttribute('aria-invalid', msg ? 'true' : 'false'); });
        return !msg;
    }

    var keyOfInput = { studyFrom: 'study', studyTo: 'study', passingX: 'pass', passingXii: 'pass' };
    Object.keys(wrapOf).forEach(function (key) {
        wrapOf[key].querySelectorAll('input,textarea').forEach(function (inp) {
            inp.addEventListener('blur', function () {
                // check the year pair only when leaving the pair
                setTimeout(function () {
                    if (wrapOf[key].contains(document.activeElement)) return;
                    touched[key] = true; show(key);
                }, 0);
            });
            inp.addEventListener('input', function () { if (touched[key]) show(key); update(); });
        });
    });

    /* ---------- signature from name ---------- */
    $('fullName').addEventListener('blur', function () {
        var s = $('signature'); if (!s.value.trim() && this.value.trim()) { s.value = this.value.trim(); update(); }
    });

    /* ---------- declaration ---------- */
    var dec = $('declare'), decBox = $('declareBox');
    dec.addEventListener('change', function () { decBox.classList.toggle('checked', dec.checked); decBox.classList.remove('bad'); update(); });

    /* ---------- character count ---------- */
    var info = $('additionalInfo'), cnt = $('infoCount');
    function count() { cnt.textContent = info.value.length; }
    info.addEventListener('input', count); count();

    /* ---------- live card, batch note, progress ---------- */
    var steps = {
        s1: function () { return !checks.fullName() && !checks.dateOfBirth(); },
        s2: function () { return !checks.study() && !checks.pass(); },
        s3: function () { return !!(val('qualification') || val('occupation') || val('organization')); },
        s4: function () { return !checks.address() && !checks.contact() && !checks.email(); },
        s5: function () { return !!val('additionalInfo'); },
        s6: function () { return dec.checked && !checks.signature(); }
    };
    function update() {
        var n = $('mcName'), name = val('fullName');
        n.textContent = name || 'Your name'; n.classList.toggle('empty', !name);

        var f = yr('studyFrom'), t = yr('studyTo');
        $('mcYears').textContent = f && t && t >= f ? f + ' – ' + t : (f ? f + ' – ' : '—');
        var batch = yr('passingXii') || yr('passingX') || (t && t >= (f || 0) ? t : null);
        $('mcBatch').textContent = batch || '—';

        var note = $('batchNote');
        if (f && t && t >= f && f >= 1959) {
            var y = t - f + 1;
            note.querySelector('span').textContent = y + (y === 1 ? ' year' : ' years') + ' at SRS' + (batch ? ' · Batch of ' + batch : '');
            note.classList.add('show');
        } else note.classList.remove('show');

        var done = 0;
        Object.keys(steps).forEach(function (k) {
            var ok = steps[k](); if (ok) done++;
            var li = document.querySelector('[data-step="' + k + '"]'); if (li) li.classList.toggle('done', ok);
        });
        document.querySelectorAll('.js-count').forEach(function (e) { e.textContent = done; });
        document.querySelectorAll('.js-bar').forEach(function (e) { e.style.width = (done / 6 * 100) + '%'; });
    }
    form.querySelectorAll('input,textarea').forEach(function (i) { i.addEventListener('input', update); });
    update();

    /* ---------- highlight the section on screen ---------- */
    if ('IntersectionObserver' in window) {
        var io = new IntersectionObserver(function (ents) {
            ents.forEach(function (e) {
                if (!e.isIntersecting) return;
                document.querySelectorAll('.alu-steps li').forEach(function (li) { li.classList.toggle('on', li.getAttribute('data-step') === e.target.id); });
            });
        }, { rootMargin: '-40% 0px -55% 0px' });
        form.querySelectorAll('.alu-sec').forEach(function (s) { io.observe(s); });
    }

    /* ---------- submit ---------- */
    form.addEventListener('submit', function (ev) {
        var first = null;
        Object.keys(checks).forEach(function (k) { touched[k] = true; if (!show(k) && !first) first = wrapOf[k]; });
        if (!dec.checked) { decBox.classList.add('bad'); if (!first) first = decBox; }
        if (first) {
            ev.preventDefault();
            first.scrollIntoView({ behavior: 'smooth', block: 'center' });
            var i = first.querySelector('input,textarea'); if (i) setTimeout(function () { i.focus({ preventScroll: true }); }, 350);
            return;
        }
        var b = $('submitBtn'); b.disabled = true; b.innerHTML = 'Submitting&hellip;';
    });
})();
</script>

</body>

<%@ include file="Footer.jsp" %>

</html>
