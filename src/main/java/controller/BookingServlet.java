package controller;

import model.Booking;
import model.User;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Security check: Only logged-in guests can book
        if (currentUser == null || !currentUser.getRole().equals("guest")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Get form parameters
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        int guests = Integer.parseInt(request.getParameter("guests"));
        
        // 2. Calculate Total Price (Assuming RM 150/night for Chalet 1)
        LocalDate startDate = LocalDate.parse(checkIn);
        LocalDate endDate = LocalDate.parse(checkOut);
        long nights = ChronoUnit.DAYS.between(startDate, endDate);
        double totalAmount = nights * 150.0;

        // 3. Create new Booking
        String bookingId = "BK-" + System.currentTimeMillis();
        Booking newBooking = new Booking(bookingId, currentUser.getName(), checkIn, checkOut, guests, totalAmount, "Pending");
        
        // 4. Save to our mock database
        Booking.bookingDatabase.add(newBooking);

        // 5. Redirect to the bookings page
        response.sendRedirect("booking.jsp");
    }
}