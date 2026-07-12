<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cuti Murah Melaka | Centralized Luxury Chalets</title>
    <jsp:include page="header.jsp" />
</head>
<body class="afterglow-luxury">

    <!-- Premium Shared Full-Width Minimal Navigation Bar -->
    <jsp:include page="navbar.jsp" />

    <!-- 1. The Grand Emily Hero Architecture Block -->
    <section class="emily-hero">
        <div class="emily-hero-content">
            <span class="emily-pre-title">WELCOME TO CUTI MURAH MELAKA</span>
            <h1 class="emily-main-title">A Modern Environment Crafted For Relaxing Stays</h1>
            <p class="emily-hero-text">Experience Encik Ridzuan's signature collection of 100 comfort-driven units situated within historical and natural enclaves.</p>
            <div class="emily-hero-actions">
                <a href="homestays.jsp" class="btn-emily-solid">Explore The Stays</a>
                <a href="searchAvailability.jsp" class="btn-emily-outline">Check Availability</a>
            </div>
        </div>
    </section>

    <!-- 2. The Editorial Gallery/Story Block ("The Concept") -->
    <section class="container section-padding">
        <div class="row align-items-center g-5">
            <div class="col-md-5">
                <span class="emily-meta-tag">THE COMPLEX CONCEPT</span>
                <h2 class="emily-section-title mt-2">Luxurious and modern environments nestled in nature's embrace.</h2>
            </div>
            <div class="col-md-7">
                <p class="emily-body-large text-muted">
                    Just like the architectural complex setups, our homestay portal focuses on bringing seamless functionality straight to you. Every chalet features open, spacious layouts with natural light accents, optimized amenities, and direct access points to historical Melaka landmarks.
                </p>
            </div>
        </div>

        <!-- Grand Asymmetric Multi-Image Banner Windows -->
        <div class="row mt-5 pt-4 g-4">
            <div class="col-md-8">
                <div class="emily-gallery-window" style="background-image: url('images/cmm2.jpg'); height: 500px;"></div>
            </div>
            <div class="col-md-4">
                <div class="emily-gallery-window" style="background-image: url('images/cmm1.jpg'); height: 500px;"></div>
            </div>
        </div>
    </section>

    <!-- 3. Curated Showcase Highlights Section (Horizontal Slider Layout matching image_bba6a9.png) -->
    <section class="emily-slider-section">
        <div class="container-fluid px-5">
            <div class="d-flex justify-content-between align-items-end mb-4 pb-3" style="border-bottom: 1px solid rgba(14, 30, 25, 0.15);">
                <div>
                    <span class="emily-meta-tag">CURATED ACCOMMODATION</span>
                    <h2 class="emily-section-title mt-2">Handpicked Spaces</h2>
                </div>
                
            </div>

            <!-- The Side-by-Side Horizontal Scroll Track Window -->
            <div class="emily-horizontal-scroll-track">
                
                <!-- Slide Item 1 -->
                <div class="emily-slide-item">
                    <div class="emily-slide-img-box" style="background-image: url('images/cmm3.jpg');">
                        <div class="emily-slide-overlay">
                            <span class="slide-number">01</span>
                            <h3>Standard Chalet A1</h3>
                            <p>RM 150 <small>/ night</small></p>
                            <a href="homestayDetails.jsp?id=1" class="slide-action-btn">View Space &rarr;</a>
                        </div>
                    </div>
                </div>

                <!-- Slide Item 2 -->
                <div class="emily-slide-item">
                    <div class="emily-slide-img-box" style="background-image: url('images/cmm4.jpg');">
                        <div class="emily-slide-overlay">
                            <span class="slide-number">02</span>
                            <h3>Family Suite B1</h3>
                            <p>RM 280 <small>/ night</small></p>
                            <a href="homestayDetails.jsp?id=2" class="slide-action-btn">View Space &rarr;</a>
                        </div>
                    </div>
                </div>

                <!-- Slide Item 3 -->
                <div class="emily-slide-item">
                    <div class="emily-slide-img-box" style="background-image: url('images/cmm5.jpg');">
                        <div class="emily-slide-overlay">
                            <span class="slide-number">03</span>
                            <h3>Luxury Nature Villa C1</h3>
                            <p>RM 350 <small>/ night</small></p>
                            <a href="homestayDetails.jsp?id=3" class="slide-action-btn">View Space &rarr;</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- Shared Minimalist Footer Block Alignment -->
    <footer class="site-footer">
        <p class="mb-0">&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>