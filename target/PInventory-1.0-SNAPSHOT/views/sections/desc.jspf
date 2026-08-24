<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<section class="desc-section">
    <div class="desc-container">

        <%-- Section Title --%>
        <c:if test="${not empty sec.title}">
          
        </c:if>

        <%-- Section Main Content --%>
        
        <%-- Section Images & Image-Level Headings --%>
        <c:if test="${not empty sec.images}">
            <div class="desc-images">
                <c:forEach var="img" items="${sec.images}">

                    <%-- Heading 1 bound to image --%>
                    <c:if test="${not empty img.heading1}">
                        <h1 class="desc-heading1"><c:out value="${img.heading1}" /></h1>
                    </c:if>

                    <%-- Heading 2 bound to image --%>
                    <c:if test="${not empty img.heading2}">
                        <h3 class="desc-heading2"><c:out value="${img.heading2}" /></h3>
                    </c:if>
                    
                    <c:if test="${not empty sec.content}">
            <div class="desc-content">${sec.content}</div>
        </c:if>

                    <div class="desc-image-wrapper">
                        <img src="${pageContext.request.contextPath}/imageStream?id=${img.id}" 
                             alt="<c:out value='${img.altText}' />" 
                             class="desc-image" />
                    </div>

                </c:forEach>
            </div>
        </c:if>

    </div>
</section>