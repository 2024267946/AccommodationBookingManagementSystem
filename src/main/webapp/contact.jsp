<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact Us - DG Rimbun</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <nav class="navbar">
    <div class="nav-brand">Cuti Murah Melaka</div>
    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="homestays.jsp">View Units</a>
        <a href="contact.jsp" class="active-link">Contact</a>
        <a href="login.jsp" class="btn-outline">Login</a>
    </div>
</nav>
...
<footer class="site-footer">
    <p>&copy; 2026 Cuti Murah Melaka Management. All rights reserved.</p>
</footer>

    <div class="page-banner">
        <div class="container">
            <h1>Contact Us</h1>
            <p>Have questions? We're here to help.</p>
        </div>
    </div>

    <main class="container contact-section">
        <div class="auth-card" style="max-width: 600px; margin: 0 auto;">
            <form action="ContactServlet" method="POST">
                <div class="form-group">
                    <label>Your Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Message</label>
                    <textarea name="message" class="form-control" rows="5" required></textarea>
                </div>
                <button type="submit" class="btn-primary btn-block">Send Message</button>
            </form>
        </div>
    </main>

    <footer class="site-footer">
        <p>&copy; 2026 DG Rimbun Chalet Management. All rights reserved.</p>
    </footer>
</body>
</html>