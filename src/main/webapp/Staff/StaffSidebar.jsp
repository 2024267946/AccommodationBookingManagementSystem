<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get the current page filename to detect the active link dynamically
    String currentPage = request.getRequestURI();
%>
<aside class="sidebar" style="width: 260px; background: #ffffff; padding: 40px 24px; display: flex; flex-direction: column; justify-content: flex-start; box-sizing: border-box; border-right: 1px solid var(--border-color);">
    <nav class="sidebar-nav" style="display: flex; flex-direction: column; gap: 10px; width: 100%;">
        
        <!-- 1. Dashboard -->
        <a href="${pageContext.request.contextPath}/staff/dashboard"
           class="nav-link <%= currentPage.contains("dashboard.jsp") || currentPage.contains("/staff/dashboard") ? "active-admin-link" : "" %>"
           style="display: block; width: 100%; padding: 14px 20px; text-decoration: none; border-radius: 12px; font-weight: 500; font-size: 0.95rem; transition: all 0.3s ease; box-sizing: border-box;">
            Dashboard
        </a>
        
        <!-- 2. Account (Stays active on any of the 4 profile/user settings tabs) -->
        <a href="${pageContext.request.contextPath}/staff/my-profile"
           class="nav-link <%= (currentPage.contains("StaffMyProfile.jsp") || currentPage.contains("/staff/my-profile") || currentPage.contains("StaffUserManagement.jsp") || currentPage.contains("/staff/user-management") || currentPage.contains("StaffArchivedStaff.jsp") || currentPage.contains("/staff/archived-staff") || currentPage.contains("StaffArchivedGuest.jsp") || currentPage.contains("/staff/archived-guest")) ? "active-admin-link" : "" %>"
           style="display: block; width: 100%; padding: 14px 20px; text-decoration: none; border-radius: 12px; font-weight: 500; font-size: 0.95rem; transition: all 0.3s ease; box-sizing: border-box;">
            Account
        </a>
        
        <!-- 3. Accommodation -->
        <a href="${pageContext.request.contextPath}/staff/accommodation" 
           class="nav-link <%= (currentPage.contains("Accommodation.jsp") || currentPage.contains("/staff/accommodation")) ? "active-admin-link" : "" %>" 
           style="display: block; width: 100%; padding: 14px 20px; text-decoration: none; border-radius: 12px; font-weight: 500; font-size: 0.95rem; transition: all 0.3s ease; box-sizing: border-box;">
            Accommodation
        </a>
        
        <!-- 4. Bookings -->
        <a href="${pageContext.request.contextPath}/staff/booking/view-bookings"
           class="nav-link <%= currentPage.contains("manageBookings.jsp") || currentPage.contains("/staff/booking/view-bookings") ? "active-admin-link" : "" %>"
           style="display: block; width: 100%; padding: 14px 20px; text-decoration: none; border-radius: 12px; font-weight: 500; font-size: 0.95rem; transition: all 0.3s ease; box-sizing: border-box;">
            Booking
        </a>
        
    </nav>
</aside>