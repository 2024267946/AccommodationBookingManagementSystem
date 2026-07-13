<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String role =
            session.getAttribute("role") == null
            ? null
            : session.getAttribute("role").toString();

    if (role == null || !"GUEST".equalsIgnoreCase(role)) {
        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=unauthorized");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>Guest Homepage | Cuti Murah Melaka</title>

    <jsp:include page="guestHeader.jsp" />
</head>

<body class="afterglow-luxury">

    <jsp:include page="navbar.jsp" />

    <section class="emily-hero">

        <div class="emily-hero-content">

            <span class="emily-pre-title">
                WELCOME BACK TO CUTI MURAH MELAKA
            </span>

            <h1 class="emily-main-title">
                Find Your Next Relaxing Stay in Melaka
            </h1>

            <p class="emily-hero-text">
                Browse available homestays, manage your bookings and
                enjoy a simple booking experience in one place.
            </p>

            <div class="emily-hero-actions">

                <a href="${pageContext.request.contextPath}/homestays"
                   class="btn-emily-solid">
                    Explore The Stays
                </a>

                <a href="${pageContext.request.contextPath}/booking/my-booking"
                   class="btn-emily-outline">
                    My Bookings
                </a>

            </div>

        </div>

    </section>

    <section class="container section-padding">

        <div class="row align-items-center g-5">

            <div class="col-md-5">

                <span class="emily-meta-tag">
                    YOUR GUEST PORTAL
                </span>

                <h2 class="emily-section-title mt-2">
                    Everything you need for a comfortable stay.
                </h2>

            </div>

            <div class="col-md-7">

                <p class="emily-body-large text-muted">
                    Search available accommodation, review your booking
                    information and update your account through your guest
                    portal.
                </p>

            </div>

        </div>

        <div class="row mt-5 pt-4 g-4">

            <div class="col-md-8">

                <div class="emily-gallery-window"
                     style="background-image: url('${pageContext.request.contextPath}/images/cmm2.jpg'); height: 500px;">
                </div>

            </div>

            <div class="col-md-4">

                <div class="emily-gallery-window"
                     style="background-image: url('${pageContext.request.contextPath}/images/cmm1.jpg'); height: 500px;">
                </div>

            </div>

        </div>

    </section>

    <section class="emily-slider-section">

        <div class="container-fluid px-5">

            <div class="d-flex justify-content-between align-items-end mb-4 pb-3"
                 style="border-bottom: 1px solid rgba(14, 30, 25, 0.15);">

                <div>
                    <span class="emily-meta-tag">
                        CURATED ACCOMMODATION
                    </span>

                    <h2 class="emily-section-title mt-2">
                        Handpicked Spaces
                    </h2>
                </div>

                <a href="${pageContext.request.contextPath}/homestays/search"
                   class="btn-emily-outline">
                    Check Availability
                </a>

            </div>

            <div class="emily-horizontal-scroll-track">

                <div class="emily-slide-item">

                    <div class="emily-slide-img-box"
                         style="background-image: url('${pageContext.request.contextPath}/images/cmm3.jpg');">

                        <div class="emily-slide-overlay">

                            <span class="slide-number">01</span>

                            <h3>Standard Chalet A1</h3>

                            <p>
                                RM 150
                                <small>/ night</small>
                            </p>

                            <a href="${pageContext.request.contextPath}/homestayDetails.jsp?id=1"
                               class="slide-action-btn">
                                View Space &rarr;
                            </a>

                        </div>

                    </div>

                </div>

                <div class="emily-slide-item">

                    <div class="emily-slide-img-box"
                         style="background-image: url('${pageContext.request.contextPath}/images/cmm4.jpg');">

                        <div class="emily-slide-overlay">

                            <span class="slide-number">02</span>

                            <h3>Family Suite B1</h3>

                            <p>
                                RM 280
                                <small>/ night</small>
                            </p>

                            <a href="${pageContext.request.contextPath}/homestayDetails.jsp?id=2"
                               class="slide-action-btn">
                                View Space &rarr;
                            </a>

                        </div>

                    </div>

                </div>

                <div class="emily-slide-item">

                    <div class="emily-slide-img-box"
                         style="background-image: url('${pageContext.request.contextPath}/images/cmm5.jpg');">

                        <div class="emily-slide-overlay">

                            <span class="slide-number">03</span>

                            <h3>Luxury Nature Villa C1</h3>

                            <p>
                                RM 350
                                <small>/ night</small>
                            </p>

                            <a href="${pageContext.request.contextPath}/homestayDetails.jsp?id=3"
                               class="slide-action-btn">
                                View Space &rarr;
                            </a>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </section>

    <footer class="site-footer">

        <p class="mb-0">
            &copy; 2026 Cuti Murah Melaka Management.
            All rights reserved.
        </p>

    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
    </script>

</body>
</html>
