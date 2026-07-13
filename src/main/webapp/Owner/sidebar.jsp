<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get the current page filename to detect the active link dynamically
    String currentPage = request.getRequestURI();
%>
<aside class="sidebar" style="width: 260px; background: #ffffff; padding: 40px 24px; display: flex; flex-direction: column; justify-content: flex-start; box-sizing: border-box; border-right: 1px solid var(--border-color);">
    <nav class="sidebar-nav" style="display: flex; flex-direction: column; gap: 10px; width: 100%;">
        
        <!-- 1. Dashboard -->
        <a href="${pageContext.request.contextPath}/owner/dashboard"
           class="nav-link <%= currentPage.contains("dashboard.jsp") || currentPage.contains("/owner/dashboard") ? "active-admin-link" : "" %>"
           style="display: block; width: 100%; padding: 14px 20px; text-decoration: none; border-radius: 12px; font-weight: 500; font-size: 0.95rem; transition: all 0.3s ease; box-sizing: border-box;">
            Dashboard
        </a>
        
        <!-- 2. Account (Triggers on either profile or user management pages) -->
        <a href="${pageContext.request.contextPath}/owner/view-staff"
           class="nav-link <%= (currentPage.contains("userManagement.jsp") || currentPage.contains("myProfile.jsp") || currentPage.contains("ArchivedStaff.jsp") || currentPage.contains("ArchivedGuest.jsp")) ? "active-admin-link" : "" %>"
           style="display: block; width: 100%; padding: 14px 20px; text-decoration: none; border-radius: 12px; font-weight: 500; font-size: 0.95rem; transition: all 0.3s ease; box-sizing: border-box;">
            Account
        </a>
        
        <!-- 3. Accommodation (Triggers on editHomestay or amenity pages) -->
        <a href="${pageContext.request.contextPath}/OwnerAccommodationListServlet" 
           class="nav-link <%= (currentPage.contains("Accommodation.jsp") || currentPage.contains("amenity.jsp")) ? "active-admin-link" : "" %>" 
           style="display: block; width: 100%; padding: 14px 20px; text-decoration: none; border-radius: 12px; font-weight: 500; font-size: 0.95rem; transition: all 0.3s ease; box-sizing: border-box;">
            Accommodation
        </a>
        
        <!-- 4. Bookings -->
        <a href="${pageContext.request.contextPath}/owner/booking/view-bookings"
           class="nav-link <%= currentPage.contains("manageBookings.jsp") || currentPage.contains("/owner/booking/view-bookings") ? "active-admin-link" : "" %>"
           style="display: block; width: 100%; padding: 14px 20px; text-decoration: none; border-radius: 12px; font-weight: 500; font-size: 0.95rem; transition: all 0.3s ease; box-sizing: border-box;">
            Bookings
        </a>
        
    </nav>
</aside>
