<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard | Cuti Murah Melaka</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">
</head>
<body class="admin-body">

    <jsp:include page="StaffNavbar.jsp" />

    <div class="admin-layout">
        <!-- Pinned Sidebar Framework -->
        <jsp:include page="StaffSidebar.jsp" />

        <!-- Main Workspace -->
        <main class="main-content">
            <div class="container" style="max-width: 1100px; margin: 0;">
                
                <div class="page-header" style="margin-bottom: 30px; text-align: left;">
                    <h1>Dashboard Overview</h1>
                    <p class="text-muted">Welcome back! Here is what is happening across your premium properties today.</p>
                </div>

                <!-- Cards Grid -->
                <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 40px;">
                    <div class="table-card" style="border-left: 4px solid var(--primary-color) !important; padding: 24px; text-align: left;">
                        <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; display: block; margin-bottom: 8px;">Total Bookings</span>
                        <h2 style="font-size: 2.2rem; font-weight: 700; color: var(--text-main); margin: 0;">12</h2>
                    </div>
                    <div class="table-card" style="border-left: 4px solid #f59e0b !important; padding: 24px; text-align: left;">
                        <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; display: block; margin-bottom: 8px;">Pending Verification</span>
                        <h2 style="font-size: 2.2rem; font-weight: 700; color: var(--text-main); margin: 0;">2</h2>
                    </div>
                    <div class="table-card" style="border-left: 4px solid #10b981 !important; padding: 24px; text-align: left;">
                        <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; display: block; margin-bottom: 8px;">Confirmed Stays</span>
                        <h2 style="font-size: 2.2rem; font-weight: 700; color: var(--text-main); margin: 0;">4</h2>
                    </div>
                    <div class="table-card" style="border-left: 4px solid var(--danger) !important; padding: 24px; text-align: left;">
                        <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; display: block; margin-bottom: 8px;">Cancellations</span>
                        <h2 style="font-size: 2.2rem; font-weight: 700; color: var(--text-main); margin: 0;">0</h2>
                    </div>
                </div>

                <div class="table-card" style="padding: 40px; text-align: center;">
                    <h3 style="font-size: 1.4rem; color: var(--text-main); margin-bottom: 8px;">Analytical Tracking Reporting</h3>
                    <p style="color: var(--text-muted); margin: 0;">Database tracking reports and financial metrics will render automatically as active stays compile.</p>
                </div>

            </div>
        </main>
    </div>
</body>
</html>