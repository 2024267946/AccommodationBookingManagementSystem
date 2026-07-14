<%@ page import="java.util.List" %>
<%@ page import="model.Accommodation" %>
<%@ page import="util.AccommodationImageStore" %>
<%@ page import="java.time.LocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // ==========================================
    // BACKEND ARCHITECTURE (100% UNCHANGED)
    // ==========================================
    List<Accommodation> accommodationList = (List<Accommodation>) request.getAttribute("accommodationList");
    Accommodation accommodationChosen = (Accommodation) request.getAttribute("accomodationChoosen");

    String selectedAccommodationId = request.getParameter("id");
    String availability = request.getParameter("availability");
    String bookingError = request.getParameter("error");

    String message = (String) request.getAttribute("message");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    String pax = (String) request.getAttribute("pax");

    if (checkIn == null) checkIn = request.getParameter("checkIn");
    if (checkOut == null) checkOut = request.getParameter("checkOut");
    if (pax == null) pax = request.getParameter("pax");

    if (checkIn == null) checkIn = "";
    if (checkOut == null) checkOut = "";
    if (pax == null) pax = "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check Availability | Cuti Murah Melaka</title>

    <jsp:include page="guestHeader.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: #fbfbfa;
            color: #1c2b26;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        /* 1. MATCHING HERO BG IMAGE LAYOUT FROM SCREENSHOT */
        .hero-banner {
            position: relative;
            width: 100%;
            min-height: 540px;
            background: linear-gradient(rgba(0, 0, 0, 0.35), rgba(0, 0, 0, 0.35)),
                        url("${pageContext.request.contextPath}/images/cmm2.jpg") center/cover no-repeat;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #ffffff;
            padding: 40px 20px;
            box-sizing: border-box;
        }

        .hero-banner h1 {
            margin: 0 0 16px;
            font-family: "Playfair Display", Georgia, serif;
            font-size: clamp(38px, 5vw, 56px);
            font-weight: 500;
            letter-spacing: -0.01em;
        }

        .hero-banner p {
            margin: 0;
            font-size: clamp(14px, 2vw, 17px);
            opacity: 0.9;
            font-weight: 300;
            letter-spacing: 0.02em;
        }

        /* 2. CENTERED PILL SEARCH CAPSULE CONTAINER */
        .floating-search-container {
            position: relative;
            margin-top: 35px; /* Spaces it perfectly below the text */
            background: #ffffff;
            border-radius: 60px;
            padding: 20px 45px;
            box-shadow: 0 12px 36px rgba(0, 0, 0, 0.12);
            width: min(1040px, 92%);
            box-sizing: border-box;
            z-index: 10;
        }

        .search-grid-form {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            width: 100%;
        }

        .search-field-group {
            display: flex;
            flex-direction: column;
            flex: 1;
            text-align: left;
        }

        .search-field-group label {
            font-size: 11px;
            font-weight: 700;
            color: #1c2b26;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 8px;
            padding-left: 4px;
        }

        .search-input-field {
            width: 100%;
            height: 46px;
            border: 1px solid #e1e6e3;
            border-radius: 12px;
            padding: 10px 16px;
            font-size: 14px;
            color: #222222;
            background-color: #fafafa;
            outline: none;
            box-sizing: border-box;
            font-family: inherit;
        }

        .search-input-field:focus {
            border-color: #043e32;
            background-color: #ffffff;
        }

        .btn-trigger-search {
            height: 46px;
            padding: 0 32px;
            border: none;
            border-radius: 50px;
            background-color: #043e32;
            color: #ffffff;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            cursor: pointer;
            margin-top: 19px; 
            transition: background-color 0.2s;
            white-space: nowrap;
        }

        .btn-trigger-search:hover {
            background-color: #075444;
        }

        /* 3. INVENTORY LAYOUT AREA SECTIONS */
        .content-body-wrapper {
            max-width: 1180px;
            margin: 0 auto;
            padding: 40px 24px 80px;
        }

        .section-main-title {
            color: #043e32;
            font-family: "Playfair Display", Georgia, serif;
            font-size: 32px;
            font-weight: 700;
            text-align: center;
            margin: 0 0 24px;
        }

        /* Default layout banner view box matching image empty alert */
        .fallback-alert-card {
            background-color: #f4f2ee;
            color: #333333;
            padding: 22px;
            border-radius: 8px;
            text-align: center;
            font-size: 14px;
            font-weight: 400;
            max-width: 960px;
            margin: 0 auto;
        }

        .results-heading-meta {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 24px;
            border-bottom: 1px solid #e5e2dc;
            padding-bottom: 12px;
        }

        .results-heading-meta h2 {
            margin: 0;
            color: #043e32;
            font-family: "Playfair Display", Georgia, serif;
            font-size: 26px;
        }

        .results-heading-meta span {
            color: #72706c;
            font-size: 13px;
            font-weight: 600;
        }

        .accommodation-display-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
        }

        .accommodation-card {
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background: #ffffff;
            border: 1px solid #e8e5df;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(4, 62, 50, 0.05);
        }

        .card-visual-header {
            position: relative;
            overflow: hidden;
        }

        .card-visual-img {
            width: 100%;
            height: 230px;
            object-fit: cover;
        }

        .badge-geo {
            position: absolute;
            top: 12px;
            left: 12px;
            background-color: #043e32;
            color: #ffffff;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 500;
        }

        .badge-score {
            position: absolute;
            top: 12px;
            right: 12px;
            background: rgba(255, 255, 255, 0.95);
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            color: #111111;
        }

        .card-body-content {
            display: flex;
            flex: 1;
            flex-direction: column;
            padding: 24px;
            text-align: left;
        }

        .card-tagline {
            color: #78827e;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        .card-body-content h3 {
            margin: 0 0 10px;
            color: #043e32;
            font-family: "Playfair Display", Georgia, serif;
            font-size: 23px;
            font-weight: 700;
        }

        .card-desc-text {
            margin: 0 0 16px;
            color: #6a706e;
            font-size: 13.5px;
            line-height: 1.5;
            min-height: 42px;
        }

        .card-amenities-row {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 16px;
        }

        .amenity-tag {
            background: #f2effa;
            color: #495450;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 500;
        }

        .card-row-divider {
            border: 0;
            border-top: 1px solid #eae7e1;
            margin: 14px 0;
        }

        .card-meta-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .capacity-lbl {
            color: #78827e;
            font-size: 13px;
            font-weight: 500;
        }

        .price-display-wrapper {
            text-align: right;
        }

        .price-val {
            font-size: 1.45rem;
            font-weight: 700;
            color: #043e32;
            display: block;
            line-height: 1;
        }

        .price-sub {
            color: #6a706e;
            font-size: 11px;
        }

        .btn-action-book {
            display: block;
            width: 100%;
            box-sizing: border-box;
            text-align: center;
            text-decoration: none;
            padding: 12px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            border-radius: 8px;
            background-color: #043e32;
            color: #ffffff;
            transition: background-color 0.2s;
        }

        .btn-action-book:hover {
            background-color: #075444;
        }

        /* Modal windows components */
        .availability-modal {
            position: fixed;
            z-index: 3000;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: rgba(4, 20, 16, 0.6);
            backdrop-filter: blur(4px);
        }

        .availability-modal-card {
            width: min(440px, 100%);
            padding: 35px 30px;
            border-radius: 20px;
            background: #ffffff;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        .availability-modal-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 64px;
            height: 64px;
            margin: 0 auto 18px;
            border-radius: 50%;
            font-size: 28px;
            font-weight: 800;
        }

        .availability-modal-icon.available { background: #e6f7ef; color: #08734f; }
        .availability-modal-icon.unavailable { background: #fdeded; color: #b33c2f; }

        .availability-modal-card h2 {
            margin: 0 0 10px;
            color: #043e32;
            font-family: "Playfair Display", Georgia, serif;
            font-size: 26px;
        }

        .availability-modal-card p {
            margin: 0 0 24px;
            color: #666460;
            font-size: 14px;
            line-height: 1.6;
        }

        @media(max-width: 960px) {
            .hero-banner { height: auto; padding: 60px 20px; }
            .floating-search-container { border-radius: 24px; padding: 25px; margin-top: 30px; }
            .search-grid-form { flex-direction: column; gap: 14px; }
            .btn-trigger-search { width: 100%; margin-top: 5px; }
        }
    </style>
</head>

<body>

<jsp:include page="navbar.jsp" />

<!-- SPLIT SECTION HERO CONTAINER BLOCK -->
<div class="hero-banner">
    <h1>Find Your Perfect Escape</h1>
    <p>Search and discover available premium homestays and chalets in nature's embrace.</p>
    
    <!-- CENTERED WRAPPER FORM CONTAINER CAPSULE -->
    <div class="floating-search-container">
        <form action="${pageContext.request.contextPath}/homestays/search" method="get" class="search-grid-form">

            <% if (selectedAccommodationId != null && !selectedAccommodationId.trim().isEmpty()) { %>
                <input type="hidden" name="id" value="<%= selectedAccommodationId %>">
            <% } %>

            <div class="search-field-group">
                <label for="checkIn">Check-in</label>
                <input id="checkIn" type="date" name="checkIn" value="<%= checkIn %>" min="<%= LocalDate.now() %>" class="search-input-field" required>
            </div>

            <div class="search-field-group">
                <label for="checkOut">Check-out</label>
                <input id="checkOut" type="date" name="checkOut" value="<%= checkOut %>" min="<%= LocalDate.now() %>" class="search-input-field" required>
            </div>

            <div class="search-field-group">
                <label for="pax">Number of Pax</label>
                <input id="pax" type="number" name="pax" min="1" value="<%= pax %>" class="search-input-field" required>
            </div>

            <button type="submit" class="btn-trigger-search">
                Check Availability
            </button>
        </form>
    </div>
</div>

<% if (message != null) { %>
    <div style="max-width: 960px; margin: 0 auto 20px;" class="alert alert-warning"><%= message %></div>
<% } %>

<main class="content-body-wrapper">

    <!-- SELECTED ACCOMMODATION ANCHOR (RESTORED) -->
    <% if (selectedAccommodationId != null && accommodationChosen != null) { %>
        <% List<String> chosenPictures = AccommodationImageStore.getImages(accommodationChosen.getAccommodationId()); %>
        <div class="results-heading-meta">
            <h2>Selected Accommodation</h2>
            <span>Verifying designated option details</span>
        </div>

        <div style="max-width: 450px; margin: 0 auto 40px;">
            <article class="accommodation-card">
                <div class="card-visual-header">
                    <div class="accom-photo-carousel" data-accommodation-carousel data-fallback="${pageContext.request.contextPath}/images/<%= "CHALET".equalsIgnoreCase(accommodationChosen.getAccommodationType()) ? "chalet1.png" : "cmm3.jpg" %>">
                    <% if (chosenPictures.isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/images/<%= "CHALET".equalsIgnoreCase(accommodationChosen.getAccommodationType()) ? "chalet1.png" : "cmm3.jpg" %>" alt="Selected Stay" class="card-visual-img">
                    <% } else { for (int pictureIndex = 0; pictureIndex < chosenPictures.size(); pictureIndex++) { %>
                        <img src="${pageContext.request.contextPath}/accommodation-image?id=<%= java.net.URLEncoder.encode(accommodationChosen.getAccommodationId(), "UTF-8") %>&index=<%= pictureIndex %>&v=<%= chosenPictures.get(pictureIndex).hashCode() %>" alt="Selected Stay picture <%= pictureIndex + 1 %>" class="card-visual-img">
                    <% } if (chosenPictures.size() > 1) { %><button type="button" class="photo-nav photo-prev" aria-label="Previous picture">&#8249;</button><button type="button" class="photo-nav photo-next" aria-label="Next picture">&#8250;</button><span class="photo-count"><span>1</span>/<%= chosenPictures.size() %></span><% } } %>
                    </div>
                    <span class="badge-geo"><i class="bi bi-geo-alt-fill"></i> <%= accommodationChosen.getLocation() %></span>
                    <span class="badge-score">★ Selected</span>
                </div>
                <div class="card-body-content">
                    <div class="card-tagline"><%= accommodationChosen.getAccommodationType() %></div>
                    <h3><%= accommodationChosen.getAccommodationName() %></h3>
                    <p class="card-desc-text"><%= accommodationChosen.getDescription() == null ? "Comfortable high-amenity stay situated inside historical Melaka." : accommodationChosen.getDescription() %></p>
                    
                    <div class="card-meta-footer">
                        <span class="capacity-lbl">Capacity: <%= accommodationChosen.getMaxCapacity() %> Guests</span>
                        <div class="price-display-wrapper">
                            <span class="price-val">RM<%= String.format("%.2f", accommodationChosen.getPricePerNight()) %></span>
                            <small class="price-sub">per night</small>
                        </div>
                    </div>
                </div>
            </article>
        </div>
    <% } %>

    <!-- INVENTORY LISTING WRAPPER LOOP -->
    <h2 class="section-main-title">Available Accommodations</h2>

    <% if (accommodationList == null) { %>
        <!-- BLANK INITIAL SCREEN ALERT MODIFIED TO REPLICATE SCREENSHOT -->
        <div class="fallback-alert-card">
            Please select check-in date, check-out date, and number of pax above to view options.
        </div>
    <% } else if (accommodationList.isEmpty()) { %>
        <div style="background-color: #f8d7da; color: #842029; border: 1px solid #f5c2c7;" class="fallback-alert-card">
            No available accommodation found for your selected dates. Please try another timeline!
        </div>
    <% } else { %>
        
        <div class="results-heading-meta">
            <h2>Search Results</h2>
            <span><%= accommodationList.size() %> property option(s) found</span>
        </div>

        <div class="accommodation-display-grid">
            <% for (Accommodation acc : accommodationList) { %>
                <% List<String> resultPictures = AccommodationImageStore.getImages(acc.getAccommodationId()); %>
                <article class="accommodation-card">
                    <div class="card-visual-header">
                        <div class="accom-photo-carousel" data-accommodation-carousel data-fallback="${pageContext.request.contextPath}/images/<%= "CHALET".equalsIgnoreCase(acc.getAccommodationType()) ? "chalet1.png" : "cmm3.jpg" %>">
                        <% if (resultPictures.isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/<%= "CHALET".equalsIgnoreCase(acc.getAccommodationType()) ? "images/chalet1.png" : "images/cmm3.jpg" %>" alt="Stay Thumbnail" class="card-visual-img">
                        <% } else { for (int pictureIndex = 0; pictureIndex < resultPictures.size(); pictureIndex++) { %>
                            <img src="${pageContext.request.contextPath}/accommodation-image?id=<%= java.net.URLEncoder.encode(acc.getAccommodationId(), "UTF-8") %>&index=<%= pictureIndex %>&v=<%= resultPictures.get(pictureIndex).hashCode() %>" alt="<%= acc.getAccommodationName() %> picture <%= pictureIndex + 1 %>" class="card-visual-img">
                        <% } if (resultPictures.size() > 1) { %><button type="button" class="photo-nav photo-prev" aria-label="Previous picture">&#8249;</button><button type="button" class="photo-nav photo-next" aria-label="Next picture">&#8250;</button><span class="photo-count"><span>1</span>/<%= resultPictures.size() %></span><% } } %>
                        </div>
                        <span class="badge-geo"><i class="bi bi-geo-alt-fill"></i> <%= acc.getLocation() %></span>
                        <span class="badge-score">★ 4.9</span>
                    </div>

                    <div class="card-body-content">
                        <div class="card-tagline"><%= acc.getAccommodationType() %></div>
                        <h3><%= acc.getAccommodationName() %></h3>
                        
                        <p class="card-desc-text">
                            <%= acc.getDescription() == null ? "Comfortable high-amenity stay situated inside historical Melaka." : acc.getDescription() %>
                        </p>

                        <div class="card-amenities-row">
                            <span class="amenity-tag">Free WiFi</span>
                            <span class="amenity-tag">AirCon</span>
                            <span class="amenity-tag">Parking</span>
                        </div>

                        <hr class="card-row-divider">

                        <div class="card-meta-footer">
                            <span class="capacity-lbl">Up to <%= acc.getMaxCapacity() %> Guests</span>
                            <div class="price-display-wrapper">
                                <span class="price-val">RM<%= String.format("%.2f", acc.getPricePerNight()) %></span>
                                <small class="price-sub">per night</small>
                            </div>
                        </div>

                        <!-- SYSTEM INTERACTION PIPELINE ANCHOR -->
                        <a class="btn-action-book" href="${pageContext.request.contextPath}/booking?id=<%= acc.getAccommodationId() %>&checkIn=<%= checkIn %>&checkOut=<%= checkOut %>&pax=<%= pax %>">
                            Book Now
                        </a>
                    </div>
                </article>
            <% } %>
        </div>
    <% } %>
</main>

<!-- RESPONSE FLOW SYSTEM DIALOG OVERLAYS (UNTOUCHED ACTION HANDLERS) -->
<% if (availability != null && accommodationChosen != null) {
       boolean isAvailable = "true".equalsIgnoreCase(availability);
%>
<div class="availability-modal" id="availability-result-modal" role="dialog" aria-modal="true">
    <div class="availability-modal-card">
        <div class="availability-modal-icon <%= isAvailable ? "available" : "unavailable" %>">
            <%= isAvailable ? "&#10003;" : "&#10005;" %>
        </div>
        <h2><%= isAvailable ? "Your Stay Is Available" : "Dates Not Available" %></h2>
        <p>
            <%= isAvailable
                    ? "Great news! This accommodation is available for your selected dates. Continue to complete your booking."
                    : "This accommodation is unavailable for part of your selected date range. Please choose different dates and try again." %>
        </p>
        <% if (isAvailable) { %>
            <a class="btn-action-book" style="display:block;" href="${pageContext.request.contextPath}/booking?id=<%= accommodationChosen.getAccommodationId() %>&checkIn=<%= checkIn %>&checkOut=<%= checkOut %>&pax=<%= pax %>">
                Continue to Booking
            </a>
        <% } else { %>
            <button type="button" class="btn-action-book" id="close-availability-modal">
                Choose Different Dates
            </button>
        <% } %>
    </div>
</div>
<% if (!isAvailable) { %>
<script>
    (function () {
        const modal = document.getElementById("availability-result-modal");
        document.getElementById("close-availability-modal").addEventListener("click", function () {
            modal.remove();
        });
        window.setTimeout(function () { if (modal.isConnected) modal.remove(); }, 1500);
    })();
</script>
<% } %>
<% } %>

<% if ("bookingFailed".equals(bookingError)) { %>
<div class="availability-modal" id="booking-error-modal" role="dialog" aria-modal="true">
    <div class="availability-modal-card">
        <div class="availability-modal-icon unavailable">!</div>
        <h2>Something Went Wrong</h2>
        <p>We couldn’t create your booking. Your selected accommodation and dates have been kept, so you can review them and try again.</p>
        <button type="button" class="btn-action-book" id="close-booking-error-modal">
            Review Search
        </button>
    </div>
</div>
<script>
    (function () {
        const modal = document.getElementById("booking-error-modal");
        document.getElementById("close-booking-error-modal").addEventListener("click", function () {
            modal.remove();
        });
        window.setTimeout(function () { if (modal.isConnected) modal.remove(); }, 1500);
    })();
</script>
<% } %>

<footer style="text-align: center; padding: 30px 20px; color: #78827e; font-size: 13px;">
    <p>&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
</footer>

<script src="${pageContext.request.contextPath}/js/accommodation-carousel.js?v=20260714-4"></script>
<script>
(function () {
    const checkInInput = document.getElementById('checkIn');
    const checkOutInput = document.getElementById('checkOut');
    if (!checkInInput || !checkOutInput) return;
    function updateCheckoutMinimum() {
        checkOutInput.min = checkInInput.value || '<%= LocalDate.now() %>';
        if (checkOutInput.value && checkOutInput.value <= checkInInput.value) {
            checkOutInput.value = '';
        }
    }
    checkInInput.addEventListener('change', updateCheckoutMinimum);
    updateCheckoutMinimum();
})();
</script>

</body>
</html>
