package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

import dao.BookingDAO;
import dao.AccommodationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Accommodation;
import model.Guest;
import model.Staff;

@WebServlet(urlPatterns = {
    "/booking",
    "/booking/create-booking",
    "/booking/cancel-booking",
    "/booking/my-booking",
    "/staff/booking/verify",
    "/owner/booking/verify",
    "/staff/booking/view-bookings",
    "/owner/booking/view-bookings"
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

            case "/booking":
                openBookingPage(request, response);
                break;

            case "/booking/my-booking":
                myBooking(request, response);
                break;

            case "/staff/booking/view-bookings":
                request.setAttribute("roles", "staff");
                viewBookings(request, response);
                break;

            case "/owner/booking/view-bookings":
                request.setAttribute("roles", "owner");
                viewBookings(request, response);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath() + "/Homepage.jsp");
                break;
        }
    }

    private void openBookingPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accommodationId = request.getParameter("id");
        if (isBlank(accommodationId)) {
            response.sendRedirect(request.getContextPath()
                    + "/homestays/search?error=missingAccommodation");
            return;
        }

        Accommodation accommodation = new AccommodationDAO()
                .getAccommodationById(accommodationId.trim());
        if (accommodation == null) {
            response.sendRedirect(request.getContextPath()
                    + "/homestays/search?error=accommodationNotFound");
            return;
        }

        request.setAttribute("bookingAccommodation", accommodation);
        request.getRequestDispatcher("/booking.jsp").forward(request, response);
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

            case "/owner/booking/verify":
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

        if (isBlank(accommodationID)
                || isBlank(checkInDate)
                || isBlank(checkOutDate)
                || isBlank(numberOfPaxParam)) {

            redirectBookingFailure(request, response, "missingField");
            return;
        }

        try {
            int numberOfPax =
                    Integer.parseInt(numberOfPaxParam.trim());

            Accommodation accommodation = new AccommodationDAO()
                    .getAccommodationById(accommodationID.trim());
            if (accommodation == null) {
                redirectBookingFailure(request, response, "accommodationNotFound");
                return;
            }
            double pricePerNight = accommodation.getPricePerNight();

            LocalDate checkIn =
                    LocalDate.parse(checkInDate.trim());

            LocalDate checkOut =
                    LocalDate.parse(checkOutDate.trim());

            long numberOfNights =
                    ChronoUnit.DAYS.between(checkIn, checkOut);

            if (numberOfPax < 1
                    || pricePerNight < 0
                    || numberOfNights < 1) {

                redirectBookingFailure(request, response, "invalidValue");
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

                redirectBookingFailure(request, response, "dao");
            }

        } catch (NumberFormatException e) {

            redirectBookingFailure(request, response, "invalidNumber");

        } catch (Exception e) {

            e.printStackTrace();

            redirectBookingFailure(request, response, "systemError");
        }
    }

    private void redirectBookingFailure(
            HttpServletRequest request,
            HttpServletResponse response,
            String reason)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/homestays/search?error=bookingFailed"
                + "&reason=" + encode(reason)
                + "&id=" + encode(request.getParameter("accommodationID"))
                + "&checkIn=" + encode(request.getParameter("checkInDate"))
                + "&checkOut=" + encode(request.getParameter("checkOutDate"))
                + "&pax=" + encode(request.getParameter("numberOfPax")));
    }

    private String encode(String value) {
        return URLEncoder.encode(
                value == null ? "" : value,
                StandardCharsets.UTF_8);
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

        boolean ownerRequest =
                "/owner/booking/verify".equals(request.getServletPath());

        String returnPath = ownerRequest
                ? "/owner/booking/view-bookings"
                : "/staff/booking/view-bookings";

        if (isBlank(bookingID)) {
            response.sendRedirect(
                    request.getContextPath()
                    + returnPath + "?verify=failed");
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
                    + returnPath + "?verify=success");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                    + returnPath + "?verify=failed");
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

        String roles = (String) request.getAttribute("roles");

        if(roles.equals("owner"))
                request.getRequestDispatcher(
                        "/Owner/manageBookings.jsp")
                .forward(request, response);
        else{
                request.getRequestDispatcher(
                        "/Staff/manageBookings.jsp")
                .forward(request, response);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
