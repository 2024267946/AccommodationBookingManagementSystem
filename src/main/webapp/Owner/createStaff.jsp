<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Staff - Cuti Murah Melaka</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">
</head>
<body class="admin-body">

    <jsp:include page="ownerNavbar.jsp" />

    <div class="admin-layout">
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <div class="container" style="max-width: 650px; margin: 0 auto;">
                
                <div style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/staff/view-staff" style="text-decoration: none; color: var(--text-muted); font-size: 0.9rem; display: inline-flex; align-items: center; gap: 8px;">
                        Back to User Management
                    </a>
                </div>

                <div class="page-header" style="text-align: left; margin-bottom: 25px;">
                    <h1>Add New Staff Account</h1>
                    <p class="text-muted">Register a new administrative staff member to help manage bookings and homestay units.</p>
                </div>

                <div class="auth-card" style="padding: 40px !important; border-radius: 16px !important; margin: 0 auto !important;">
                    
                    <form action="${pageContext.request.contextPath}/owner/create-staff" method="POST">
                        <input type="hidden" name="staffRoles" value="STAFF">

                        <div class="form-group" style="display: flex; flex-direction: column; margin-bottom: 20px; text-align: left;">
                            <label style="font-size: 0.85rem; font-weight: 600; text-transform: uppercase; margin-bottom: 6px;">Full Name</label>
                            <input type="text" name="staffName" class="form-control" placeholder="Enter staff's full name" required>
                        </div>

                        <div class="form-group" style="display: flex; flex-direction: column; margin-bottom: 20px; text-align: left;">
                            <label style="font-size: 0.85rem; font-weight: 600; text-transform: uppercase; margin-bottom: 6px;">Email Address</label>
                            <input type="email" name="staffEmail" class="form-control" placeholder="e.g. staffname@cutimurah.com" required>
                        </div>

                        <div class="form-group" style="display: flex; flex-direction: column; margin-bottom: 20px; text-align: left;">
                            <label style="font-size: 0.85rem; font-weight: 600; text-transform: uppercase; margin-bottom: 6px;">Phone Number</label>
                            <input type="tel" name="staffPhoneNumber" class="form-control" placeholder="e.g. +6012-3456789" required>
                        </div>

                        <div class="form-group" style="display: flex; flex-direction: column; margin-bottom: 30px; text-align: left;">
                            <label style="font-size: 0.85rem; font-weight: 600; text-transform: uppercase; margin-bottom: 6px;">Temporary Password</label>
                            <input type="password" name="staffPassword" class="form-control" minlength="6" placeholder="Assign a default login password" required>
                            <small style="color: var(--text-muted); font-size: 0.8rem; margin-top: 4px;">Staff members can update their password later via profile configurations.</small>
                        </div>

                        <div style="display: flex; gap: 15px; justify-content: flex-end; margin-top: 10px;">
                            <a href="${pageContext.request.contextPath}/owner/view-staff" class="btn-primary" style="background-color: transparent !important; color: var(--text-main) !important; border: 1px solid var(--border-color) !important; border-radius: 8px !important; padding: 12px 24px !important;">
                                Cancel
                            </a>
                            <button type="submit" class="btn-primary" style="border-radius: 8px !important; padding: 12px 24px !important;">
                                Save
                            </button>
                        </div>
                    </form>

                </div>

            </div>
        </main>
    </div>

</body>
</html>