package controller;


import model.Booking;
import model.Guest;
import model.Staff;

import dao.BookingDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
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

                break;
            case "/booking/my-booking":

                break;
            case "/staff/booking/verify":

                break;
            case "/staff/booking/view-bookings":

                break;
        }
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response) throws IOException{
        
        // CHECKING IF THERE'S ANY MISSING FIELD ON THE REQUEST
        if(request.getParameter("checkInDate") == null || request.getParameter("checkOutDate") == null || request.getParameter("accomodationID") == null){
            response.sendRedirect("homestayDetails.jsp?create-booking=failed&reason=invalid");
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
}