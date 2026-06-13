<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Chalet - DG Rimbun</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body class="auth-body">
    <div class="container booking-container">
        <div class="auth-card" style="max-width: 600px; margin: 2rem auto;">
            <div class="auth-header">
                <h2>Complete Your Booking</h2>
                <p>Standard Chalet A1</p>
            </div>
            
            <form action="BookingServlet" method="POST">
                <!-- Hidden input to pass the unit ID to the database -->
                <input type="hidden" name="homestayId" value="<%= request.getParameter("id") %>">
                
                <div class="form-group">
                    <label>Check-in Date</label>
                    <input type="date" name="checkInDate" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label>Check-out Date</label>
                    <input type="date" name="checkOutDate" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label>Number of Guests</label>
                    <input type="number" name="guestCount" class="form-control" min="1" max="4" value="2" required>
                </div>
                
                <div class="form-group">
                    <label>Special Requests (Optional)</label>
                    <textarea name="remarks" class="form-control" rows="3" placeholder="E.g., extra pillows, late check-in..."></textarea>
                </div>
                
                <div class="price-summary">
                    <p>Base Price: RM 150.00 / night</p>
                    <p>Cleaning Fee: RM 50.00</p>
                    <hr style="margin: 10px 0; border: 0; border-top: 1px solid var(--border-color);">
                    <p style="font-weight: bold; color: var(--primary-color);">Estimated Total will be calculated upon confirmation.</p>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <a href="homestayDetails.jsp?id=1" class="btn-clear text-center" style="flex: 1; text-decoration: none;">Cancel</a>
                    <button type="submit" class="btn-primary" style="flex: 1;">Confirm Booking</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>