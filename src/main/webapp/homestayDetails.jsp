<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Accommodation" %>
<%
Accommodation accommodation = (Accommodation) request.getAttribute("accomodation");
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
                <div class="chalet-img-placeholder" style="width: 100%; height: 100%; min-height: 450px; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-image fa-3x text-muted"></i>
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

                <a href="search?id=<%= accommodation.getAccommodationId() %>" class="btn-primary btn-block text-center" style="margin-top: 2rem; display: inline-block; text-decoration: none;">
                    Proceed to Booking
                </a>
                <% } %>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p class="mb-0">&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>
    
    <script>
        const params = new URLSearchParams(window.location.search);
        if (params.get("error") === "-1") {
            alert("The accommodation was not found.");
        }

        const status = params.get("status");
        if (status === "failed") {
            const which = params.get("which");
            if (which === "create-booking") {
                alert("Failed to create booking");
            }
        }
    </script>
</body>
</html>
