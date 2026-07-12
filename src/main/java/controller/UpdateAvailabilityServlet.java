package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateAvailabilityServlet")
public class UpdateAvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    // Open the correct availability form according to the logged-in role.
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String role = session.getAttribute("role").toString().trim();

        if (!"OWNER".equalsIgnoreCase(role)
                && !"STAFF".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String accommodationID =
                request.getParameter("accommodationID");

        if (accommodationID == null
                || accommodationID.trim().isEmpty()) {

            redirectToAccommodationList(
                    request,
                    response,
                    role,
                    "error=missingAccommodationID");
            return;
        }

        request.setAttribute(
                "accommodationID",
                accommodationID.trim());

        if ("OWNER".equalsIgnoreCase(role)) {

            request.getRequestDispatcher(
                    "/Owner/OwnerUpdateAvailability.jsp")
                   .forward(request, response);

        } else {

            request.getRequestDispatcher(
                    "/Staff/StaffUpdateAvailability.jsp")
                   .forward(request, response);
        }
    }

    // Save the availability update.
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String role = session.getAttribute("role").toString().trim();

        if (!"OWNER".equalsIgnoreCase(role)
                && !"STAFF".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String accommodationID =
                request.getParameter("accommodationID");
        String checkIn =
                request.getParameter("checkIn");
        String checkOut =
                request.getParameter("checkOut");
        String status =
                request.getParameter("status");

        String staffID = null;

        if (session.getAttribute("staffID") != null) {
            staffID = session.getAttribute("staffID")
                             .toString()
                             .trim();
        }

        if (accommodationID == null
                || accommodationID.trim().isEmpty()
                || checkIn == null
                || checkIn.trim().isEmpty()
                || checkOut == null
                || checkOut.trim().isEmpty()
                || status == null
                || status.trim().isEmpty()
                || staffID == null
                || staffID.isEmpty()) {

            redirectBackToForm(
                    request,
                    response,
                    accommodationID,
                    "error=missing");
            return;
        }

        try {
            boolean success = bookingDAO.updateAvailability(
                    accommodationID.trim(),
                    staffID,
                    checkIn.trim(),
                    checkOut.trim(),
                    status.trim());

            if (success) {
                redirectToAccommodationList(
                        request,
                        response,
                        role,
                        "message=availabilityUpdateSuccess");
            } else {
                redirectBackToForm(
                        request,
                        response,
                        accommodationID,
                        "error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();

            redirectBackToForm(
                    request,
                    response,
                    accommodationID,
                    "error=systemError");
        }
    }

    private void redirectBackToForm(
            HttpServletRequest request,
            HttpServletResponse response,
            String accommodationID,
            String queryMessage)
            throws IOException {

        String safeID = accommodationID == null
                ? ""
                : URLEncoder.encode(
                        accommodationID.trim(),
                        StandardCharsets.UTF_8);

        response.sendRedirect(
                request.getContextPath()
                + "/UpdateAvailabilityServlet"
                + "?accommodationID=" + safeID
                + "&" + queryMessage);
    }

    private void redirectToAccommodationList(
            HttpServletRequest request,
            HttpServletResponse response,
            String role,
            String queryMessage)
            throws IOException {

        if ("OWNER".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/OwnerAccommodationListServlet"
                    + "?" + queryMessage);

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/accommodation"
                    + "?" + queryMessage);
        }
    }
}
