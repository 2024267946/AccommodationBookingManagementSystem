<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Account - DG Rimbun</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body class="auth-body">
    <div class="container booking-container">
        <div class="auth-card" style="max-width: 500px; margin: 2rem auto;">
            <div class="auth-header">
                <h2>Edit Account</h2>
                <p>Update your personal information</p>
            </div>
            
            <form action="UpdateAccountServlet" method="POST">
                <!-- Hidden ID for the database update -->
                <input type="hidden" name="userId" value="<%= request.getParameter("id") %>">
                
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" class="form-control" value="Jane Doe" required>
                </div>
                
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel" name="phone" class="form-control" value="+6012-345-6789" required>
                </div>
                
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" value="jane@email.com" required>
                </div>
                
                <div class="form-group">
                    <label>New Password (Optional)</label>
                    <input type="password" name="password" class="form-control" placeholder="Leave blank to keep current password">
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <a href="profile.jsp" class="btn-clear text-center" style="flex: 1; text-decoration: none;">Cancel</a>
                    <button type="submit" class="btn-primary" style="flex: 1;">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>