package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
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
import model.Staff;

@WebServlet(urlPatterns = {
    "/booking/create-booking",
    "/booking/cancel-booking",
    "/booking/my-booking",
    "/staff/booking/verify",
    "/staff/booking/view-bookings"
})
public class BookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {

            case "/booking/my-booking":
                myBooking(request, response);
                break;

            case "/staff/booking/view-bookings":
                viewBookings(request, response);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath() + "/Homepage.jsp");
                break;
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {

            case "/booking/create-booking":
                createBooking(request, response);
                break;

            case "/booking/cancel-booking":
                cancelBooking(request, response);
                break;

            case "/staff/booking/verify":
                verifyBooking(request, response);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath() + "/Homepage.jsp");
                break;
        }
    }

    // Guest creates a new pending booking.
    private void createBooking(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=unauthorized");
            return;
        }

        Guest loggedGuest =
                (Guest) session.getAttribute("loggedGuest");

        /*
         * The login flow must store loggedGuest in session.
         * Example:
         * session.setAttribute("loggedGuest", guest);
         */
        if (loggedGuest == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=guestSessionMissing");
            return;
        }

        String accommodationID =
                request.getParameter("accommodationID");

        String checkInDate =
                request.getParameter("checkInDate");

        String checkOutDate =
                request.getParameter("checkOutDate");

        String numberOfPaxParam =
                request.getParameter("numberOfPax");

        String pricePerNightParam =
                request.getParameter("pricePerNight");

        if (isBlank(accommodationID)
                || isBlank(checkInDate)
                || isBlank(checkOutDate)
                || isBlank(numberOfPaxParam)
                || isBlank(pricePerNightParam)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Homepage.jsp?booking=failed&reason=missingField");
            return;
        }

        try {
            int numberOfPax =
                    Integer.parseInt(numberOfPaxParam.trim());

            double pricePerNight =
                    Double.parseDouble(pricePerNightParam.trim());

            LocalDate checkIn =
                    LocalDate.parse(checkInDate.trim());

            LocalDate checkOut =
                    LocalDate.parse(checkOutDate.trim());

            long numberOfNights =
                    ChronoUnit.DAYS.between(checkIn, checkOut);

            if (numberOfPax < 1
                    || pricePerNight < 0
                    || numberOfNights < 1) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Homepage.jsp?booking=failed&reason=invalidValue");
                return;
            }

            double totalPrice =
                    numberOfNights * pricePerNight;

            Booking booking = new Booking();

            booking.setCheckInDate(
                    checkInDate.trim());

            booking.setCheckOutDate(
                    checkOutDate.trim());

            booking.setNumberOfPax(
                    numberOfPax);

            booking.setTotalPrice(
                    totalPrice);

            booking.setBookingStatus(
                    "PENDING");

            // Staff is assigned later when staff verifies the booking.
            booking.setStaffID(
                    null);

            booking.setGuestID(
                    loggedGuest.getGuestId());

            booking.setAccommodationID(
                    accommodationID.trim());

            String bookingID =
                    BookingDAO.createBooking(booking);

            if (bookingID != null) {

                session.setAttribute(
                        "bookingID",
                        bookingID);

                session.setAttribute(
                        "totalAmount",
                        totalPrice);

                session.setAttribute(
                        "selectedAccommodationID",
                        accommodationID.trim());

                session.setAttribute(
                        "bookingCheckIn",
                        checkInDate.trim());

                session.setAttribute(
                        "bookingCheckOut",
                        checkOutDate.trim());

                session.setAttribute(
                        "bookingPax",
                        numberOfPax);

                response.sendRedirect(
                        request.getContextPath()
                        + "/paymentPopUp.jsp");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Homepage.jsp?booking=failed&reason=dao");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Homepage.jsp?booking=failed&reason=invalidNumber");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/Homepage.jsp?booking=failed&reason=systemError");
        }
    }

    // Guest cancels a booking.
    private void cancelBooking(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String bookingID =
                request.getParameter("bookingID");

        if (isBlank(bookingID)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/booking/my-booking?cancel=failed");
            return;
        }

        Booking booking = new Booking();
        booking.setBookingID(bookingID.trim());

        BookingDAO bookingDAO = new BookingDAO();

        boolean success =
                bookingDAO.cancelBooking(booking);

        if (success) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/booking/my-booking?cancel=success");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                    + "/booking/my-booking?cancel=failed");
        }
    }

    // Display the logged-in guest's bookings.
    private void myBooking(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("loggedGuest") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        Guest loggedGuest =
                (Guest) session.getAttribute("loggedGuest");

        BookingDAO bookingDAO =
                new BookingDAO();

        List<Booking> list =
                bookingDAO.getBookingsByGuest(
                        loggedGuest.getGuestId());

        request.setAttribute(
                "bookingsList",
                list);

        request.getRequestDispatcher(
                "/myBooking.jsp")
               .forward(request, response);
    }

    // Staff verifies a booking.
    private void verifyBooking(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("loggedStaff") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        Staff loggedStaff =
                (Staff) session.getAttribute("loggedStaff");

        String bookingID =
                request.getParameter("bookingID");

        if (isBlank(bookingID)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/booking/view-bookings?verify=failed");
            return;
        }

        Booking booking = new Booking();

        booking.setBookingID(
                bookingID.trim());

        booking.setStaffID(
                loggedStaff.getStaffId());

        BookingDAO bookingDAO =
                new BookingDAO();

        boolean success =
                bookingDAO.verifyBooking(booking);

        if (success) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/booking/view-bookings?verify=success");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/booking/view-bookings?verify=failed");
        }
    }

    // Display all bookings for staff.
    private void viewBookings(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("loggedStaff") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        BookingDAO bookingDAO =
                new BookingDAO();

        List<Booking> masterList =
                bookingDAO.getAllBookings();

        request.setAttribute(
                "masterBookingsList",
                masterList);

        request.getRequestDispatcher(
                "/Staff/StaffBooking.jsp")
               .forward(request, response);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}