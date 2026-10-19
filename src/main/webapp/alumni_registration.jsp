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
        .alu-wrap { max-width: 900px; margin: 40px auto 70px; padding: 0 20px; box-sizing: border-box; }
        .alu-card {
            background: #fff;
            border: 1px solid #ead9c8;
            border-top: 5px solid #612405;
            box-shadow: 0 18px 40px -26px rgba(59, 22, 3, .45);
        }
        .alu-head { padding: 28px 32px 20px; text-align: center; border-bottom: 1px solid #f0e6dc; }
        .alu-head .school { margin: 0; color: #612405; font-size: 24px; font-weight: 700; }
        .alu-head .addr { margin: 4px 0 14px; color: #6b5d52; font-size: 13.5px; }
        .alu-head h1 {
            display: inline-block; margin: 0; padding: 6px 18px;
            border-top: 2px solid #e0701b; border-bottom: 2px solid #e0701b;
            color: #2b1206; font-size: 17px; letter-spacing: .14em; text-transform: uppercase;
        }
        .alu-intro { margin: 14px auto 0; max-width: 620px; color: #4a4039; font-size: 14px; line-height: 1.7; }

        .alu-form { padding: 8px 32px 30px; }
        .alu-group { margin-top: 22px; }
        .alu-group h2 {
            display: flex; align-items: center; gap: 10px;
            margin: 0 0 12px; color: #612405; font-size: 15px; font-weight: 700;
        }
        .alu-group h2::after { content: ''; flex: 1; height: 1px; background: #ead9c8; }
        .alu-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px 18px; }
        .alu-grid .full { grid-column: 1 / -1; }
        .alu-field label { display: block; margin-bottom: 6px; color: #2b1206; font-size: 13.5px; font-weight: 700; }
        .alu-field label .req { color: #c62828; }
        .alu-field label small { color: #8a7b70; font-weight: 400; }
        .alu-field input, .alu-field textarea {
            width: 100%; box-sizing: border-box;
            padding: 10px 12px;
            border: 1px solid #d9c9ba; border-radius: 4px;
            background: #fffdfb; color: #2b1206;
            font: inherit; font-size: 14.5px;
            transition: border-color .15s ease, box-shadow .15s ease;
        }
        .alu-field textarea { resize: vertical; min-height: 84px; line-height: 1.6; }
        .alu-field input:focus, .alu-field textarea:focus {
            outline: none; border-color: #e0701b; box-shadow: 0 0 0 3px rgba(224, 112, 27, .15); background: #fff;
        }
        .alu-pair { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .alu-pair span { display: block; margin-bottom: 4px; color: #6b5d52; font-size: 12.5px; }
        .alu-hint { margin-top: 5px; color: #8a7b70; font-size: 12.5px; }

        .alu-declare {
            display: flex; gap: 10px; align-items: flex-start;
            margin-top: 22px; padding: 14px 16px;
            background: #fbf3ea; border-left: 4px solid #e0701b;
            color: #3b2a1f; font-size: 14px; line-height: 1.6;
        }
        .alu-declare input { margin-top: 4px; width: 18px; height: 18px; accent-color: #612405; }
        .alu-sign { display: grid; grid-template-columns: 1fr 1.4fr; gap: 18px; margin-top: 18px; }
        .alu-sign .date-box {
            padding: 10px 12px; border: 1px dashed #d9c9ba; border-radius: 4px; background: #faf6f1;
            color: #2b1206; font-size: 14.5px;
        }
        .alu-sign .sig input { font-style: italic; }

        .alu-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 26px; }
        .alu-btn {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 12px 26px; border: none; border-radius: 4px;
            background: #612405; color: #fff;
            font: inherit; font-size: 15px; font-weight: 700; letter-spacing: .03em;
            cursor: pointer; transition: background-color .15s ease; text-decoration: none;
        }
        .alu-btn:hover { background: #e0701b; }
        .alu-btn.ghost { background: #fff; color: #612405; border: 1px solid #d9c9ba; }
        .alu-btn.ghost:hover { background: #fbf3ea; }

        .alu-errors {
            margin: 22px 0 0; padding: 14px 18px;
            background: #fdecec; border-left: 4px solid #c62828; color: #7f1d1d; font-size: 14px;
        }
        .alu-errors b { display: block; margin-bottom: 6px; }
        .alu-errors ul { margin: 0; padding-left: 20px; line-height: 1.7; }
        .alu-trap { position: absolute; left: -9999px; width: 1px; height: 1px; overflow: hidden; }

        .alu-done { padding: 46px 32px 50px; text-align: center; }
        .alu-done .tick {
            width: 64px; height: 64px; margin: 0 auto 16px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            background: #e8f5e9; color: #2e7d32; font-size: 28px;
        }
        .alu-done h2 { margin: 0 0 8px; color: #2b1206; font-size: 22px; }
        .alu-done p { margin: 0 auto 6px; max-width: 520px; color: #4a4039; font-size: 15px; line-height: 1.7; }
        .alu-done .regno {
            display: inline-block; margin: 14px 0 22px; padding: 10px 18px;
            border: 1px solid #ead9c8; background: #faf6f1;
            color: #612405; font-size: 17px; font-weight: 700; letter-spacing: .06em;
        }

        @media (max-width: 680px) {
            .alu-wrap { margin: 20px auto 40px; padding: 0 12px; }
            .alu-head, .alu-form { padding-left: 18px; padding-right: 18px; }
            .alu-grid, .alu-sign { grid-template-columns: 1fr; }
            .alu-actions { flex-direction: column-reverse; }
            .alu-btn { justify-content: center; }
        }
    </style>
</head>
<body>

<%@ include file="Header.jsp" %>

<main class="alu-wrap">
    <div class="alu-card">

        <div class="alu-head">
            <p class="school">Sandur Residential School</p>
            <p class="addr">Sandur, Bellary District 583119, Karnataka, India</p>
            <h1>Alumni Registration Form</h1>
            <c:if test="${empty doneNo}">
                <p class="alu-intro">Studied at SRS? Register with the Alumni Association to stay in touch with your batch, your teachers and the school.</p>
            </c:if>
        </div>

        <c:choose>
            <%-- ===== thank-you after saving ===== --%>
            <c:when test="${not empty doneNo}">
                <div class="alu-done">
                    <div class="tick"><i class="fa-solid fa-check"></i></div>
                    <h2>Thank you<c:if test="${not empty doneName}">, ${fn:escapeXml(doneName)}</c:if>!</h2>
                    <p>Your alumni registration has been received. The school office will review it and get in touch with you.</p>
                    <div class="regno">Registration No. ${fn:escapeXml(doneNo)}</div>
                    <div>
                        <a class="alu-btn ghost" href="${pageContext.request.contextPath}/homepage">Back to home page</a>
                    </div>
                </div>
            </c:when>

            <%-- ===== the form ===== --%>
            <c:otherwise>
                <form class="alu-form" method="post" action="${pageContext.request.contextPath}/alumni-registration">
                    <input type="hidden" name="token" value="${fn:escapeXml(token)}">
                    <div class="alu-trap" aria-hidden="true">
                        <label>Leave this empty <input type="text" name="website" tabindex="-1" autocomplete="off"></label>
                    </div>

                    <c:if test="${not empty errors}">
                        <div class="alu-errors" role="alert">
                            <b>Please check the following:</b>
                            <ul>
                                <c:forEach var="e" items="${errors}"><li>${fn:escapeXml(e)}</li></c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <section class="alu-group">
                        <h2>Personal details</h2>
                        <div class="alu-grid">
                            <div class="alu-field">
                                <label for="fullName">Name <span class="req">*</span></label>
                                <input type="text" id="fullName" name="fullName" maxlength="150" required autocomplete="name"
                                       value="${fn:escapeXml(form.fullName)}">
                            </div>
                            <div class="alu-field">
                                <label for="dateOfBirth">Date of Birth <span class="req">*</span></label>
                                <input type="date" id="dateOfBirth" name="dateOfBirth" required max="${today}"
                                       value="${fn:escapeXml(form.dateOfBirth)}">
                            </div>
                        </div>
                    </section>

                    <section class="alu-group">
                        <h2>Years at SRS</h2>
                        <div class="alu-grid">
                            <div class="alu-field">
                                <label>Years of Study <span class="req">*</span></label>
                                <div class="alu-pair">
                                    <div><span>From</span><input type="number" name="studyFrom" min="1959" max="${thisYear}" placeholder="e.g. 1990" required value="${fn:escapeXml(form.studyFrom)}"></div>
                                    <div><span>To</span><input type="number" name="studyTo" min="1959" max="${thisYear}" placeholder="e.g. 2001" required value="${fn:escapeXml(form.studyTo)}"></div>
                                </div>
                            </div>
                            <div class="alu-field">
                                <label>Year of Passing</label>
                                <div class="alu-pair">
                                    <div><span>X Class</span><input type="number" name="passingX" min="1959" max="${thisYear}" placeholder="e.g. 1999" value="${fn:escapeXml(form.passingX)}"></div>
                                    <div><span>XII / PUC</span><input type="number" name="passingXii" min="1959" max="${thisYear}" placeholder="e.g. 2001" value="${fn:escapeXml(form.passingXii)}"></div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="alu-group">
                        <h2>Education &amp; work</h2>
                        <div class="alu-grid">
                            <div class="alu-field full">
                                <label for="qualification">Additional Qualification</label>
                                <input type="text" id="qualification" name="qualification" maxlength="255" placeholder="e.g. B.E. Mechanical, MBA"
                                       value="${fn:escapeXml(form.qualification)}">
                            </div>
                            <div class="alu-field">
                                <label for="occupation">Occupation</label>
                                <input type="text" id="occupation" name="occupation" maxlength="150" autocomplete="organization-title"
                                       value="${fn:escapeXml(form.occupation)}">
                            </div>
                            <div class="alu-field">
                                <label for="organization">Name of your organization &amp; Place</label>
                                <input type="text" id="organization" name="organization" maxlength="255" autocomplete="organization"
                                       value="${fn:escapeXml(form.organization)}">
                            </div>
                        </div>
                    </section>

                    <section class="alu-group">
                        <h2>Contact</h2>
                        <div class="alu-grid">
                            <div class="alu-field full">
                                <label for="address">Mailing Address <span class="req">*</span></label>
                                <textarea id="address" name="address" maxlength="1000" rows="3" required autocomplete="street-address">${fn:escapeXml(form.address)}</textarea>
                            </div>
                            <div class="alu-field">
                                <label for="contact">Contact Number <span class="req">*</span></label>
                                <input type="tel" id="contact" name="contact" maxlength="20" required autocomplete="tel" placeholder="+91 98765 43210"
                                       value="${fn:escapeXml(form.contact)}">
                            </div>
                            <div class="alu-field">
                                <label for="email">Email ID <span class="req">*</span></label>
                                <input type="email" id="email" name="email" maxlength="150" required autocomplete="email"
                                       value="${fn:escapeXml(form.email)}">
                            </div>
                        </div>
                    </section>

                    <section class="alu-group">
                        <h2>Anything else</h2>
                        <div class="alu-field">
                            <label for="additionalInfo">Any Additional Information <small>(optional)</small></label>
                            <textarea id="additionalInfo" name="additionalInfo" maxlength="2000" rows="4"
                                      placeholder="Memories, achievements, how you would like to help the school...">${fn:escapeXml(form.additionalInfo)}</textarea>
                        </div>
                    </section>

                    <label class="alu-declare">
                        <input type="checkbox" name="declare" value="1" required>
                        <span>I confirm that the details given above are correct, and I agree that the school may contact me about alumni activities.</span>
                    </label>

                    <div class="alu-sign">
                        <div class="alu-field">
                            <label>Date</label>
                            <div class="date-box" id="todayBox">${today}</div>
                        </div>
                        <div class="alu-field sig">
                            <label for="signature">Signature <span class="req">*</span> <small>(type your full name)</small></label>
                            <input type="text" id="signature" name="signature" maxlength="150" required
                                   value="${fn:escapeXml(form.signature)}">
                        </div>
                    </div>

                    <div class="alu-actions">
                        <a class="alu-btn ghost" href="${pageContext.request.contextPath}/homepage?slug=alumni">Cancel</a>
                        <button type="submit" class="alu-btn"><i class="fa-solid fa-paper-plane"></i> Submit registration</button>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
    (function () {
        // show today's date as dd-mm-yyyy
        var box = document.getElementById('todayBox');
        if (box) {
            var p = box.textContent.trim().split('-');
            if (p.length === 3) box.textContent = p[2] + '-' + p[1] + '-' + p[0];
        }
        // fill the signature from the name if it is still empty
        var name = document.getElementById('fullName'), sig = document.getElementById('signature');
        if (name && sig) {
            name.addEventListener('blur', function () { if (!sig.value.trim()) sig.value = name.value.trim(); });
        }
        // stop double-clicks submitting twice
        var form = document.querySelector('.alu-form');
        if (form) form.addEventListener('submit', function () {
            var b = form.querySelector('button[type=submit]');
            if (b) { b.disabled = true; b.textContent = 'Submitting…'; }
        });
    })();
</script>

</body>

<%@ include file="Footer.jsp" %>

</html>
