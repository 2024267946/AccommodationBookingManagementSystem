<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <img id="detail-img-element" src="" alt="Chalet Image" style="width: 100%; height: 100%; min-height: 450px; object-fit: cover; display: block;">
            </div>
            
            <div class="details-info">
                <h1 id="detail-title">Loading Unit Details...</h1>
                <p class="price-large" id="detail-price">RM0<small>/ night</small></p>
                
                <p class="details-desc" id="detail-desc">
                    Loading description...
                </p>
                
                <div class="amenities-list" id="detail-amenities">
                    </div>

                <a href="#" id="proceed-booking-btn" class="btn-primary btn-block text-center" style="margin-top: 2rem; display: inline-block; text-decoration: none;">
                    Proceed to Booking
                </a>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p class="mb-0">&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>
    
    <script>
        // 1. Core Data Repository matching your theme.css mock card links perfectly
        const chaletData = {
            "1": {
                title: "Standard Chalet A1",
                price: "RM 150",
                desc: "Enjoy a peaceful retreat in our Standard Chalet. Perfect for couples or solo travelers looking to experience the beauty of Melaka. Includes a private patio and modern minimalist features.",
                image: "images/cmm3.jpg",
                amenities: [
                    '<span><i class="fas fa-bed"></i> 1 Queen Bed</span>',
                    '<span><i class="fas fa-bath"></i> 1 Bathroom</span>',
                    '<span><i class="fas fa-snowflake"></i> Air Conditioning</span>',
                    '<span><i class="fas fa-tv"></i> Smart TV</span>',
                    '<span><i class="fas fa-wifi"></i> Free High-Speed WiFi</span>'
                ]
            },
            "2": {
                title: "Family Suite B1",
                price: "RM 280",
                desc: "Spacious family suite with extra luxury amenities tailored perfectly for larger group staycations. Enjoy a large lounging layout and convenient proximities to historical landmarks.",
                image: "images/cmm4.jpg",
                amenities: [
                    '<span><i class="fas fa-bed"></i> 3 Beds</span>',
                    '<span><i class="fas fa-bath"></i> 2 Baths</span>',
                    '<span><i class="fas fa-snowflake"></i> Air Conditioning</span>',
                    '<span><i class="fas fa-parking"></i> Dedicated Parking</span>',
                    '<span><i class="fas fa-wifi"></i> Free High-Speed WiFi</span>'
                ]
            },
            "3": {
                title: "Luxury Nature Villa C1",
                price: "RM 350",
                desc: "Premium luxurious villa architecture showcasing breathtaking panoramic views of the surrounding pristine forest scenery. Designed with high ceilings, private lounge zones, and custom wood details.",
                image: "images/cmm5.jpg",
                amenities: [
                    '<span><i class="fas fa-bed"></i> 4 Beds</span>',
                    '<span><i class="fas fa-bath"></i> 3 Baths</span>',
                    '<span><i class="fas fa-snowflake"></i> Full Climate Control</span>',
                    '<span><i class="fas fa-coffee"></i> Espresso Machine</span>',
                    '<span><i class="fas fa-wifi"></i> Fiber High-Speed WiFi</span>'
                ]
            }
        };

        // 2. Parse URL Params
        const params = new URLSearchParams(window.location.search);
        let id = params.get("id");
        
        // Default to unit 1 if id is missing or unmapped
        if (!id || !chaletData[id]) {
            id = "1";
        }

        // 3. Populate Content UI
        const unit = chaletData[id];
        document.getElementById("detail-title").innerText = unit.title;
        document.getElementById("detail-price").innerHTML = `${unit.price}<small>/ night</small>`;
        document.getElementById("detail-desc").innerText = unit.desc;
        document.getElementById("detail-amenities").innerHTML = unit.amenities.join('');
        
        // FIXED: Explicitly assigns the image source link directly onto the img HTML element
        document.getElementById("detail-img-element").src = unit.image;
        
        // Update booking button path query
        document.getElementById("proceed-booking-btn").href = `searchAvailability.jsp?id=${id}`;

        // 4. Teammate Error Alerts Logic
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