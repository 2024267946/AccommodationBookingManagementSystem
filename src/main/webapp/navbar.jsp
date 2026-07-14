<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String navbarRole = session.getAttribute("role") == null
        ? null
        : session.getAttribute("role").toString();

if ("OWNER".equalsIgnoreCase(navbarRole)) {
%>
    <jsp:include page="Owner/ownerNavbar.jsp" />
<%
} else if ("STAFF".equalsIgnoreCase(navbarRole)) {
%>
    <jsp:include page="Staff/StaffNavbar.jsp" />
<%
} else if ("GUEST".equalsIgnoreCase(navbarRole)
        && session.getAttribute("loggedGuest") != null) {
%>
    <jsp:include page="guestNavbar.jsp" />
<%
} else {
%>
    <nav class="guest-top-nav">
        <nav class="navbar navbar-light" style="padding: 15px 40px !important;">
            <div class="container-fluid d-flex align-items-center justify-content-between flex-nowrap">
                <a class="navbar-brand d-flex align-items-center"
                   href="${pageContext.request.contextPath}/index.jsp"
                   style="gap: 12px; text-decoration: none;">
                    <img src="${pageContext.request.contextPath}/images/logo2.png"
                         alt="Cuti Murah Melaka"
                         class="logo-img">
                </a>

                <div class="d-flex align-items-center" style="gap: 30px;">
                    <ul class="d-flex align-items-center list-unstyled mb-0"
                        style="gap: 25px; margin: 0; padding: 0;">
                        <li><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                        <li><a class="nav-link" href="${pageContext.request.contextPath}/homestays">Accommodation</a></li>
                    </ul>

                    <div class="d-flex align-items-center" style="gap: 15px; margin-left: 10px;">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                    </div>
                </div>
            </div>
        </nav>
    </nav>
<%
}
%>
