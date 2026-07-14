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
