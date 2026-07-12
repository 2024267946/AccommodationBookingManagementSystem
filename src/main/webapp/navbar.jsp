<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if a user session exists and look for their user role designation
    String userRole = (String) session.getAttribute("userRole"); 
    
    if (userRole != null && (userRole.equalsIgnoreCase("owner") || userRole.equalsIgnoreCase("staff"))) {
%>
    <!-- DYNAMIC ROUTE: Automatically loads the owner panel layout if logged in as admin -->
    <jsp:include page="Owner/ownerNavbar.jsp" />
<%
    } else {
%>
    <!-- =========================================================================
         GUEST NAVBAR MARKUP (Handles both Logged-In and Logged-Out Guests)
         ========================================================================= -->
    <nav class="guest-top-nav">
        <nav class="navbar navbar-light" style="padding: 15px 40px !important;">
            <div class="container-fluid d-flex align-items-center justify-content-between flex-nowrap">
                
                <!-- Logo -->
                <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp" style="gap: 12px; text-decoration: none;">
                    <img src="${pageContext.request.contextPath}/images/logo1.png" alt="Logo" class="logo-img">
                </a>

                <div class="d-flex align-items-center" style="gap: 30px;">
                    <!-- Left Side Links -->
                    <ul class="d-flex align-items-center list-unstyled mb-0" style="gap: 25px; margin: 0; padding: 0;">
                        <li>
                            <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                        </li>
                        <li>
                            <a class="nav-link" href="${pageContext.request.contextPath}/homestays.jsp">Homestays</a>
                        </li>
                        
                        <%-- Show 'My Bookings' only for active Logged-In Guest accounts --%>
                        <% if (session.getAttribute("guest") != null || session.getAttribute("user") != null) { %>
                            <li>
                                <a class="nav-link" href="${pageContext.request.contextPath}/booking.jsp">My Bookings</a>
                            </li>
                        <% } %>
                    </ul>

                    <!-- Right Side Actions -->
                    <div class="d-flex align-items-center" style="gap: 15px; margin-left: 10px;">
                        <% if (session.getAttribute("guest") == null && session.getAttribute("staff") == null && session.getAttribute("user") == null) { %>
                            <!-- GUEST IS LOGGED OUT: Show Login and Register -->
                            <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                        
                        <% } else if (session.getAttribute("staff") != null) { %>
                            <!-- ADMIN PANEL SHORTCUT: Show Dashboard and Logout -->
                            <a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/Dashboard/dashboard.jsp">Dashboard</a>
                            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
                        
                        <% } else { %>
                            <!-- GUEST IS LOGGED IN: Show Account and Logout (Exactly like your picture) -->
                            <a class="nav-link" href="${pageContext.request.contextPath}/profile.jsp">Account</a>
                            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
                        <% } %>
                    </div>
                </div>

            </div>
        </nav>
    </nav>
<%
    }
%>