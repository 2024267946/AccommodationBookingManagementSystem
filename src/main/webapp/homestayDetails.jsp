<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Accommodation" %>
<%@ page import="java.util.List" %>
<%@ page import="util.AccommodationImageStore" %>
<%
Accommodation accommodation = (Accommodation) request.getAttribute("accomodation");
List<String> detailPictures = accommodation == null ? java.util.Collections.emptyList()
        : AccommodationImageStore.getImages(accommodation.getAccommodationId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chalet Details - Cuti Murah Melaka</title>
    <jsp:include page="header.jsp" />
    <jsp:include page="navbar.jsp" />
</head>
<body>

    <main class="container details-section">
        <div class="details-grid">
            <div class="details-image-box" style="overflow: hidden;">
                <div class="chalet-img-placeholder accom-photo-carousel" data-accommodation-carousel style="width:100%;height:100%;min-height:450px;">
                    <% if (detailPictures.isEmpty()) { %>
                    <img src="${pageContext.request.contextPath}/images/<%= accommodation != null && "CHALET".equalsIgnoreCase(accommodation.getAccommodationType()) ? "chalet1.png" : "cmm1.jpg" %>" alt="Accommodation picture">
                    <% } else { for (int pictureIndex = 0; pictureIndex < detailPictures.size(); pictureIndex++) { %>
                    <img src="${pageContext.request.contextPath}/accommodation-image?id=<%= java.net.URLEncoder.encode(accommodation.getAccommodationId(), "UTF-8") %>&index=<%= pictureIndex %>" alt="<%= accommodation.getAccommodationName() %> picture <%= pictureIndex + 1 %>">
                    <% } if (detailPictures.size() > 1) { %>
                    <button type="button" class="photo-nav photo-prev" aria-label="Previous picture">&#8249;</button><button type="button" class="photo-nav photo-next" aria-label="Next picture">&#8250;</button><span class="photo-count"><span>1</span>/<%= detailPictures.size() %></span>
                    <% } } %>
                </div>
            </div>
            
            <div class="details-info">
                <h1><%= accommodation == null ? "Accommodation Details" : accommodation.getAccommodationName() %></h1>
                <% if (accommodation != null) { %>
                <p class="price-large">RM <%= String.format("%.2f", accommodation.getPricePerNight()) %><small>/ night</small></p>
                
                <p class="details-desc"><%= accommodation.getDescription() %></p>
                
                <div class="amenities-list">
                    <span><i class="fas fa-users"></i> Up to <%= accommodation.getMaxCapacity() %> guests</span>
                    <span><i class="fas fa-home"></i> <%= accommodation.getAccommodationType() %></span>
                    <span><i class="fas fa-map-marker-alt"></i> <%= accommodation.getLocation() %></span>
                </div>

                <a href="${pageContext.request.contextPath}/homestays/search?id=<%= accommodation.getAccommodationId() %>"
                   class="btn-primary btn-block text-center" 
                   style="margin-top: 2rem; display: inline-block; text-decoration: none;">
                    Proceed to Booking
                </a>
                <% } %>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p class="mb-0">&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>
    
    <script src="${pageContext.request.contextPath}/js/app-modal.js"></script>
    <script src="${pageContext.request.contextPath}/js/accommodation-carousel.js?v=20260714-2"></script>
    <script>
        const params = new URLSearchParams(window.location.search);
        if (params.get("error") === "-1") {
            showAppMessage("Accommodation Not Found", "The requested accommodation was not found.");
        }

        const status = params.get("status");
        if (status === "failed") {
            const which = params.get("which");
            if (which === "create-booking") {
                showAppMessage("Booking Failed", "The booking could not be created. Please try again.");
            }
        }
    </script>
</body>
</html>
