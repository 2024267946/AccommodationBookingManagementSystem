package controller;

import java.io.IOException;
import java.util.List;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Guest;

@WebServlet("/booking/receipt")
public class ReceiptServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Guest guest = session == null ? null : (Guest) session.getAttribute("loggedGuest");

        if (guest == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String bookingID = request.getParameter("bookingID");
        if (bookingID == null || bookingID.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?error=receiptNotFound");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByGuest(guest.getGuestId());
        Booking selectedBooking = null;

        for (Booking booking : bookings) {
            if (bookingID.equals(booking.getBookingID())) {
                selectedBooking = booking;
                break;
            }
        }

        if (selectedBooking == null) {
            response.sendRedirect(request.getContextPath() + "/booking/my-booking?error=receiptNotFound");
            return;
        }

        request.setAttribute("booking", selectedBooking);
        request.getRequestDispatcher("/receipt.jsp").forward(request, response);
    }
}
