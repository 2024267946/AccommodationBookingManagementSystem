<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Accommodation" %>
<%@ page import="model.Amenity" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chalet Units - Cuti Murah Melaka</title>
   	<jsp:include page="guestHeader.jsp" />
    <jsp:include page="navbar.jsp" />
</head>
<body>
    
    <!-- Page Header -->
    <div class="page-banner">
        <div class="container">
            <h1>Our Chalet Units</h1>
            <p>Browse through our 100 comfortable units and find your perfect stay.</p>
        </div>
    </div>

    <!-- Chalet Grid Section -->
    <main class="container grid-section">
        <div class="chalet-grid">
            
            <%
            List<Accommodation> homestays =
                (List<Accommodation>) request.getAttribute("accommodationList");
            Map<String, List<Amenity>> amenitiesMap =
                (Map<String, List<Amenity>>) request.getAttribute("amenitiesMap");

            if (homestays != null && !homestays.isEmpty()) {

                for (Accommodation hs : homestays) {
                    List<Amenity> amenities = amenitiesMap == null
                        ? null
                        : amenitiesMap.get(hs.getAccommodationId());
            %>
                <div class="chalet-card">
                    <div class="chalet-img-placeholder">
                        <i class="fas fa-image fa-3x text-muted"></i>
                    </div>
                    <div class="chalet-details">
                        <h3><%= hs.getAccommodationName() %></h3>
                        <p class="chalet-desc"><%= hs.getDescription() %></p>
                        <div class="chalet-features">
                            <span><i class="fas fa-users"></i> Up to <%= hs.getMaxCapacity() %> guests</span>
                            <span><i class="fas fa-home"></i> <%= hs.getAccommodationType() %></span>
                            <span><i class="fas fa-map-marker-alt"></i> <%= hs.getLocation() %></span>
                            <%
                            if (amenities != null) {
                                for (Amenity amenity : amenities) {
                            %>
                                <span><i class="fas fa-check"></i> <%= amenity.getAmenityName() %></span>
                            <%
                                }
                            }
                            %>
                        </div>
                        <div class="chalet-footer">
                            <span class="price">RM <%= String.format("%.2f", hs.getPricePerNight()) %> <small>/ night</small></span>
                            <a href="<%= request.getContextPath() %>/homestays/details?id=<%= hs.getAccommodationId() %>" class="btn-primary">View Details</a>
                        </div>
                    </div>
                </div>

            <%
                }

            } else {
            %>

                <p>No accommodation available.</p>

            <%
            }
            %>

        </div>
    </main>

    <footer class="site-footer">
        <p class="mb-0">&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>
</body>
</html>
