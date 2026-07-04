<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chalet Details - DG Rimbun</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">DG Rimbun</div>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="homestays.jsp" class="active-link">View Units</a>
            <a href="contact.jsp">Contact</a>
            <a href="profile.jsp">My Profile</a>
        </div>
    </nav>

    <main class="container details-section">
        <div class="details-grid">
            <!-- Left Side: Image -->
            <div class="details-image-box">
                <i class="fas fa-home fa-5x text-muted"></i>
                <!-- You will replace this with an actual <img> tag later: <img src="images/unit1.jpg" alt="Chalet"> -->
            </div>
            
            <!-- Right Side: Info & Action -->
            <div class="details-info">
                <h1>Standard Chalet A1</h1>
                <p class="price-large">RM150<small>/ night</small></p>
                
                <p class="details-desc">
                    Enjoy a peaceful retreat in our Standard Chalet. Perfect for couples or solo travelers looking to experience the beauty of Melaka. Includes a private patio and modern amenities.
                </p>
                
                <div class="amenities-list">
                    <div class="amenity-item"><i class="fas fa-bed"></i> 1 Queen Bed</div>
                    <div class="amenity-item"><i class="fas fa-bath"></i> 1 Bathroom</div>
                    <div class="amenity-item"><i class="fas fa-snowflake"></i> Air Conditioning</div>
                    <div class="amenity-item"><i class="fas fa-tv"></i> Smart TV</div>
                    <div class="amenity-item"><i class="fas fa-wifi"></i> Free High-Speed WiFi</div>
                </div>

                <!-- Book Button passes the Chalet ID to the booking page -->
                <a href="booking.jsp?id=1" class="btn-primary btn-block text-center" style="margin-top: 2rem; display: inline-block; text-decoration: none;">
                    Proceed to Booking
                </a>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p>&copy; 2026 DG Rimbun Chalet Management. All rights reserved.</p>
    </footer>
</body>

<script>
    const params = new URLSearchParams(window.location.search);
    const status = params.get("status");

    if(status == "failed"){
        const which = params.get("which");
        const reason = params.get("reason");

        if(which == "create-booking"){
            alert("Failed to create booking");
        }
    }
</script>
</html>