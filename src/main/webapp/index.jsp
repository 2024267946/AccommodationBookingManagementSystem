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
                <a href="homestays" class="btn-emily-solid">Explore The Stays</a>
                <a href="${pageContext.request.contextPath}/homestays/search" class="btn-emily-outline">Check Availability</a>
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

   

    <!-- Shared Minimalist Footer Block Alignment -->
    <footer class="site-footer">
        <p class="mb-0">&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
