<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Verification Pipeline - Cuti Murah Melaka</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theme.css">
</head>
<body class="admin-body">
<jsp:include page="ownerNavbar.jsp" />
    <div class="admin-layout">
      
      <!-- Include Sidebar Column -->
      <jsp:include page="sidebar.jsp" />

      <!-- Workspace Panel -->
      <main class="main-content">
        <div class="container">
          
          <div class="page-header">
            <h1>Booking Management</h1>
            <p class="text-muted">Review, track, and verify upcoming homestay reservations.</p>
          </div>

          <div class="table-card">
            <div class="table-header">
              <h2>Pending & Past Reservations</h2>
            </div>
            
            <div class="table-responsive">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Booking ID</th>
                    <th>Guest Name</th>
                    <th>Chalet Unit</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th class="text-center">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="font-medium">BK005</td>
                    <td>Siti Nurhaliza</td>
                    <td>Standard Chalet A1</td>
                    <td>15 Mar 2026</td>
                    <td>18 Mar 2026</td>
                    <td class="font-medium" style="color: var(--primary-color);">RM 540.00</td>
                    <td><span class="badge-status-pending" style="color: #b91c1c; font-weight:600; background: #fee2e2; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem;">Pending</span></td>
                    <td class="text-center">
                      <!-- EXCLUSIVE VERIFY ACTION ONLY -->
                      <form action="${pageContext.request.contextPath}/staff/booking/verify" method="POST"  style="margin:0;">
                        <input type="hidden" name="bookingId" value="BK005">
                        <button type="submit" class="btn-primary" style="padding: 8px 16px; font-size: 0.8rem; border-radius: 8px !important;">
                            Verify
                        </button>
                      </form>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

        </div>
      </main>
    </div>
</body>
</html>