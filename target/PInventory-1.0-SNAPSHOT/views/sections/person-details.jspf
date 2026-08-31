

<section class="person-details-section">

   
    <c:if test="${not empty sec.title}">
        <h2 class="person-section-title">
            <c:out value="${sec.title}" />
        </h2>
    </c:if>

   
    <div class="person-details-profile">

       
        <div class="person-details-image">
            <c:if test="${not empty sec.images}">
                <c:forEach var="img" items="${sec.images}" varStatus="status">
                    <c:if test="${status.first}">
                        <img src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                             alt="${not empty img.altText ? img.altText : sec.title}">
                    </c:if>
                </c:forEach>
            </c:if>
        </div>

      
        <div class="person-details-content">

            <c:forEach var="img" items="${sec.images}" varStatus="status">
                <c:if test="${status.first}">

                  
                    <c:if test="${not empty img.heading1}">
                        <h3 class="person-designation">
                            <c:out value="${img.heading1}" />
                        </h3>
                    </c:if>

                   
                    <c:choose>
                        <c:when test="${not empty img.heading2}">
                            <h4 class="person-name">
                                <c:out value="${img.heading2}" />
                            </h4>
                        </c:when>
                        <c:when test="${not empty img.altText}">
                            <h4 class="person-name">
                                <c:out value="${img.altText}" />
                            </h4>
                        </c:when>
                    </c:choose>

                </c:if>
            </c:forEach>

          
            <c:if test="${not empty sec.content}">
                <div class="person-description">
                    <c:out value="${sec.content}" escapeXml="false" />
                </div>
            </c:if>

        </div>

    </div>

</section>