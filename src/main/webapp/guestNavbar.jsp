<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String role =
            session.getAttribute("role") == null
            ? null
            : session.getAttribute("role").toString();

    String guestName =
            session.getAttribute("guestName") == null
            ? "Guest"
            : session.getAttribute("guestName").toString();
%>

<nav class="guest-user-nav">

    <div class="guest-nav-inner">

        <a class="guest-logo"
           href="${pageContext.request.contextPath}/homepage.jsp">

            <img src="${pageContext.request.contextPath}/images/logo1.png"
                 alt="Cuti Murah Melaka">

        </a>

        <div class="guest-nav-content">

            <ul class="guest-nav-links">

                <li>
                    <a class="guest-nav-link active"
                       href="${pageContext.request.contextPath}/homepage.jsp">
                        Home
                    </a>
                </li>

                <li>
                    <a class="guest-nav-link"
                       href="${pageContext.request.contextPath}/homestays">
                        Homestays
                    </a>
                </li>

                <li>
                    <a class="guest-nav-link"
                       href="${pageContext.request.contextPath}/homestays/search">
                        Check Availability
                    </a>
                </li>

                <li>
                    <a class="guest-nav-link"
                       href="${pageContext.request.contextPath}/booking/my-booking">
                        My Bookings
                    </a>
                </li>

            </ul>

            <div class="guest-account-area">

                <div class="guest-welcome">
                    <small>Welcome back</small>
                    <strong><%= guestName %></strong>
                </div>

                <a class="guest-account-button"
                   href="${pageContext.request.contextPath}/profile">
                    My profile
                </a>

                <a class="guest-logout-button"
                   href="${pageContext.request.contextPath}/LogoutServlet">
                    Logout
                </a>

            </div>

        </div>

    </div>

</nav>
