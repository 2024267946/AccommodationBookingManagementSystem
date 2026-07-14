<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${pageContext.request.contextPath}/js/app-modal.js?v=20260714-5"></script>
<%
    String currentTopPage = request.getRequestURI();
%>
<header class="navbar" style="box-sizing: border-box; display: flex; align-items: center; justify-content: space-between; height: 80px;">
    
    <!-- Left Section: Logo Image and Elegant Cursive Title -->
    <div style="display: flex; align-items: center; gap: 16px;">
        <img src="${pageContext.request.contextPath}/images/logo2.png" alt="Logo" style="height: 45px; width: auto; object-fit: contain;">
        
    </div>

    <!-- Right Section: Menu Links and Matte Action Button Layout -->
    <ul class="navbar-nav">
        <li>
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link">Home</a>
        </li>
     
        <li>
            <a href="${pageContext.request.contextPath}/owner/dashboard"
               class="nav-link <%= currentTopPage.contains("/Owner/") ? "active-top-link" : "" %>">
               Dashboard
            </a>
        </li>
        <li>
            <form action="${pageContext.request.contextPath}/LogoutServlet" method="POST" style="margin: 0; display: inline;">
                 <button type="submit" class="btn-primary" style="padding: 10px 24px !important; font-size: 0.75rem !important; border-radius: 0px !important;">
                     Log Out
                 </button>
            </form>
        </li>
    </ul>
    
</header>
