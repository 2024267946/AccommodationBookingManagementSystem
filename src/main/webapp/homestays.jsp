<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chalet Units - Cuti Murah Melaka</title>
   	<jsp:include page="guestHeader.jsp" />
    <jsp:include page="guestNavbar.jsp" />
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
            
            <!-- Example of ONE Chalet Card -->
            <div class="chalet-card">
                <div class="chalet-img-placeholder">
                    <i class="fas fa-image fa-3x text-muted"></i>
                </div>
                <div class="chalet-details">
                    <h3>Standard Chalet A1</h3>
                    <p class="chalet-desc">A comfortable standard unit perfect for couples or solo travelers.</p>
                    <div class="chalet-features">
                        <span><i class="fas fa-bed"></i> 1 Bed</span>
                        <span><i class="fas fa-bath"></i> 1 Bath</span>
                        <span><i class="fas fa-wifi"></i> Free WiFi</span>
                    </div>
                    <div class="chalet-footer">
                        <span class="price">RM 150 <small>/ night</small></span>
                        <a href="homestayDetails.jsp?id=1" class="btn-primary">View Details</a>
                    </div>
                </div>
            </div>
            
            <!-- Example Card 2 -->
            <div class="chalet-card">
                <div class="chalet-img-placeholder">
                    <i class="fas fa-image fa-3x text-muted"></i>
                </div>
                <div class="chalet-details">
                    <h3>Family Suite B1</h3>
                    <p class="chalet-desc">Spacious family suite with extra amenities for a comfortable group stay.</p>
                    <div class="chalet-features">
                        <span><i class="fas fa-bed"></i> 3 Beds</span>
                        <span><i class="fas fa-bath"></i> 2 Baths</span>
                        <span><i class="fas fa-parking"></i> Parking</span>
                    </div>
                    <div class="chalet-footer">
                        <span class="price">RM 280 <small>/ night</small></span>
                        <a href="homestayDetails.jsp?id=2" class="btn-primary">View Details</a>
                    </div>
                </div>
            </div>

            <!-- Example Card 3 (ADDED) -->
            <div class="chalet-card">
                <div class="chalet-img-placeholder">
                    <i class="fas fa-image fa-3x text-muted"></i>
                </div>
                <div class="chalet-details">
                    <h3>Luxury Nature Villa C1</h3>
                    <p class="chalet-desc">Luxurious villa with breathtaking views of the surrounding forest scenery.</p>
                    <div class="chalet-features">
                        <span><i class="fas fa-bed"></i> 4 Beds</span>
                        <span><i class="fas fa-bath"></i> 3 Baths</span>
                        <span><i class="fas fa-snowflake"></i> AirCon</span>
                    </div>
                    <div class="chalet-footer">
                        <span class="price">RM 350 <small>/ night</small></span>
                        <a href="homestayDetails.jsp?id=3" class="btn-primary">View Details</a>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <footer class="site-footer">
        <p class="mb-0">&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>
</body>
</html>