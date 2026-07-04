package controller;

import model.Booking;
import model.Guest;
import model.Staff;
import dao.BookingDAO;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {
    "/booking/create-booking",
    "/booking/cancel-booking",
    "/booking/my-booking",  
    "/staff/booking/verify",
    "/staff/booking/view-bookings"
})
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();

        switch(path){
            case "/booking/create-booking":
                createBooking(request, response);
                break;
            case "/booking/cancel-booking":
                cancelBooking(request, response);
                break;
            case "/booking/my-booking":
                myBooking(request, response);
                break;
            case "/staff/booking/verify":
                verifyBooking(request, response);
                break;
            case "/staff/booking/view-bookings":
                viewBookings(request, response);
                break;
        }
    }

    ///booking/create-booking
    private void createBooking(HttpServletRequest request, HttpServletResponse response) throws IOException{
        
        // CHECKING IF THERE'S ANY MISSING FIELD ON THE REQUEST
        if(request.getParameter("checkInDate") == null || request.getParameter("checkOutDate") == null || request.getParameter("accommodationID") == null){
            response.sendRedirect("homestayDetails.jsp?create-booking=failed&reason=invalid");
            return;
        }

        // CREATE BOOKING MODEL
        Booking booking = new Booking();
        booking.setCheckInDate(request.getParameter("checkInDate"));
        booking.setCheckOutDate(request.getParameter("checkOutDate"));
        booking.setNumberOfPax(Integer.parseInt(request.getParameter("numberOfPax")));
        booking.setTotalPrice(Double.parseDouble(request.getParameter("totalPrice")));
        booking.setBookingStatus(request.getParameter("bookingStatus"));
        booking.setStaffID(Integer.parseInt(request.getParameter("staffID")));
        booking.setGuestID(Integer.parseInt(request.getParameter("guestID")));
        booking.setAccommodationID(Integer.parseInt(request.getParameter("accommodationID")));

        // CALL DAO TO SAVE TO DATABASE
        boolean isSuccess = BookingDAO.createBooking(booking);

        if(isSuccess == true){
            response.sendRedirect("booking.jsp");
        }else{
            response.sendRedirect("homestayDetails.jsp?status=failed&which=create-booking&reason=dao");
        }
    }

    ///booking/cancel-booking
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Booking booking = new Booking();
        booking.setBookingID(Integer.parseInt(request.getParameter("bookingID")));

        BookingDAO bookingDAO = new BookingDAO();
        boolean isSuccess = bookingDAO.cancelBooking(booking);

        if (isSuccess == true) {
            response.sendRedirect("booking.jsp?cancel=success");
        } else {
            response.sendRedirect("booking.jsp?cancel=failed");
        }
    }

    ///booking/my-booking
    private void myBooking(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Guest loggedGuest = (Guest) session.getAttribute("loggedGuest");

        if (loggedGuest == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> list = bookingDAO.getBookingsByGuest(loggedGuest.getGuestId());

        request.setAttribute("bookingsList", list);
        request.getRequestDispatcher("/booking.jsp").forward(request, response);
    }

    ///staff/booking/verify
    private void verifyBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Staff loggedStaff = (Staff) session.getAttribute("loggedStaff");

        if (loggedStaff == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Booking booking = new Booking();
        booking.setBookingID(Integer.parseInt(request.getParameter("bookingID")));
        booking.setStaffID(loggedStaff.getStaffId());

        BookingDAO bookingDAO = new BookingDAO();
        boolean isSuccess = bookingDAO.verifyBooking(booking);

        if (isSuccess == true) {
            response.sendRedirect("view-bookings?verify=success");
        } else {
            response.sendRedirect("dashboard.jsp?verify=failed");
        }
    }

    ///staff/booking/view-bookings
    private void viewBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Staff loggedStaff = (Staff) session.getAttribute("loggedStaff");

        if (loggedStaff == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> masterList = bookingDAO.getAllBookings();

        request.setAttribute("masterBookingsList", masterList);
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}