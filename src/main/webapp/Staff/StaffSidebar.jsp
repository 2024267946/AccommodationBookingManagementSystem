<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentPage = request.getRequestURI();
%>
<aside class="sidebar" style="width:260px; background:#ffffff; padding:40px 24px; display:flex; flex-direction:column; justify-content:flex-start; box-sizing:border-box; border-right:1px solid var(--border-color);">
    <nav class="sidebar-nav" style="display:flex; flex-direction:column; gap:10px; width:100%;">
        <p style="font-size:0.72rem; text-transform:uppercase; letter-spacing:1px; color:var(--text-muted); font-weight:700; margin:0 0 10px 4px;">
            Staff Menu
        </p>

        <a href="${pageContext.request.contextPath}/staff/dashboard"
           class="nav-link <%= currentPage.contains("StaffDashboard.jsp") || currentPage.contains("/staff/dashboard") ? "active-admin-link" : "" %>"
           style="display:block; width:100%; padding:14px 20px; text-decoration:none; border-radius:12px; font-weight:500; font-size:0.95rem; transition:all 0.3s ease; box-sizing:border-box;">
            Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/staff/view-staff"
           class="nav-link <%= currentPage.contains("StaffViewStaff.jsp") || currentPage.contains("/staff/view-staff") ? "active-admin-link" : "" %>"
           style="display:block; width:100%; padding:14px 20px; text-decoration:none; border-radius:12px; font-weight:500; font-size:0.95rem; transition:all 0.3s ease; box-sizing:border-box;">
            View Staff
        </a>

        <a href="${pageContext.request.contextPath}/staff/update"
           class="nav-link <%= currentPage.contains("StaffUpdateProfile.jsp") || currentPage.contains("/staff/update") ? "active-admin-link" : "" %>"
           style="display:block; width:100%; padding:14px 20px; text-decoration:none; border-radius:12px; font-weight:500; font-size:0.95rem; transition:all 0.3s ease; box-sizing:border-box;">
            Update My Profile
        </a>

        <a href="${pageContext.request.contextPath}/staff/view-guest"
           class="nav-link <%= currentPage.contains("StaffViewGuest.jsp") || currentPage.contains("/staff/view-guest") ? "active-admin-link" : "" %>"
           style="display:block; width:100%; padding:14px 20px; text-decoration:none; border-radius:12px; font-weight:500; font-size:0.95rem; transition:all 0.3s ease; box-sizing:border-box;">
            View Guest
        </a>
        
        <a href="${pageContext.request.contextPath}/staff/accommodation"
          class="nav-link <%= currentPage.contains("StaffAccommodation.jsp") || currentPage.contains("/staff/accommodation") ? "active-admin-link" : "" %>"
   		  style="display:block; width:100%; padding:14px 20px; text-decoration:none; border-radius:12px; font-weight:500; font-size:0.95rem; transition:all 0.3s ease; box-sizing:border-box;">
    	   Accommodation
	</a>
	
	<a href="${pageContext.request.contextPath}/staff/booking/view-bookings"
   class="nav-link <%= currentPage.contains("manageBookings.jsp") || currentPage.contains("/staff/booking/view-bookings") ? "active-admin-link" : "" %>"
   style="display:block; width:100%; padding:14px 20px; text-decoration:none; border-radius:12px; font-weight:500; font-size:0.95rem; transition:all 0.3s ease; box-sizing:border-box;">
    Booking
	</a>
	
    </nav>
</aside>
