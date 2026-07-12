package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import dao.AccommodationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Accommodation;

@WebServlet("/UpdateAccommodationServlet")
public class UpdateAccommodationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AccommodationDAO accommodationDAO;

    @Override
    public void init() {
        accommodationDAO = new AccommodationDAO();
    }

    // Open the correct edit form according to the logged-in role.
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=unauthorized");
            return;
        }

        String role =
                session.getAttribute("role").toString().trim();

        if (!"OWNER".equalsIgnoreCase(role)
                && !"STAFF".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=unauthorized");
            return;
        }

        String accommodationId =
                request.getParameter("accommodationId");

        if (accommodationId == null
                || accommodationId.trim().isEmpty()) {

            redirectToAccommodationList(
                    request,
                    response,
                    role,
                    "error=missingId");
            return;
        }

        Accommodation accommodation =
                accommodationDAO.getAccommodationById(
                        accommodationId.trim());

        if (accommodation == null) {

            redirectToAccommodationList(
                    request,
                    response,
                    role,
                    "error=notFound");
            return;
        }

        request.setAttribute(
                "accommodation",
                accommodation);

        if ("OWNER".equalsIgnoreCase(role)) {

            request.getRequestDispatcher(
                    "/Owner/EditAccommodation.jsp")
                   .forward(request, response);

        } else {

            request.getRequestDispatcher(
                    "/Staff/StaffEditAccommodation.jsp")
                   .forward(request, response);
        }
    }

    // Update accommodation and insert up to three amenities.
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=unauthorized");
            return;
        }

        String role =
                session.getAttribute("role").toString().trim();

        if (!"OWNER".equalsIgnoreCase(role)
                && !"STAFF".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=unauthorized");
            return;
        }

        String accommodationId =
                request.getParameter("accommodationId");

        String accommodationName =
                request.getParameter("accommodationName");

        String accommodationType =
                request.getParameter("accommodationType");

        String location =
                request.getParameter("location");

        String pricePerNightParam =
                request.getParameter("pricePerNight");

        String maxCapacityParam =
                request.getParameter("maxCapacity");

        String description =
                request.getParameter("description");

        if (isBlank(accommodationId)
                || isBlank(accommodationName)
                || isBlank(accommodationType)
                || isBlank(location)
                || isBlank(pricePerNightParam)
                || isBlank(maxCapacityParam)
                || isBlank(description)) {

            redirectBackToEdit(
                    request,
                    response,
                    accommodationId,
                    "emptyField");
            return;
        }

        try {
            double pricePerNight =
                    Double.parseDouble(
                            pricePerNightParam.trim());

            int maxCapacity =
                    Integer.parseInt(
                            maxCapacityParam.trim());

            if (pricePerNight < 0 || maxCapacity < 1) {
                redirectBackToEdit(
                        request,
                        response,
                        accommodationId,
                        "invalidNumber");
                return;
            }

            Accommodation accommodation =
                    new Accommodation();

            accommodation.setAccommodationId(
                    accommodationId.trim());

            accommodation.setAccommodationName(
                    accommodationName.trim());

            accommodation.setAccommodationType(
                    accommodationType.trim());

            accommodation.setLocation(
                    location.trim());

            accommodation.setPricePerNight(
                    pricePerNight);

            accommodation.setMaxCapacity(
                    maxCapacity);

            accommodation.setDescription(
                    description.trim());

            boolean accommodationUpdated =
                    accommodationDAO.updateAccommodation(
                            accommodation);

            if (!accommodationUpdated) {
                redirectBackToEdit(
                        request,
                        response,
                        accommodationId,
                        "updateFailed");
                return;
            }
            
         // SUCCESS
            redirectToAccommodationList(
                    request,
                    response,
                    role,
                    "success=updated");
            return;
            
        } catch (NumberFormatException e) {

            redirectBackToEdit(
                    request,
                    response,
                    accommodationId,
                    "invalidNumber");

        } catch (Exception e) {

            e.printStackTrace();

            redirectBackToEdit(
                    request,
                    response,
                    accommodationId,
                    "systemError");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void redirectBackToEdit(
            HttpServletRequest request,
            HttpServletResponse response,
            String accommodationId,
            String error)
            throws IOException {

        String safeId =
                accommodationId == null
                ? ""
                : URLEncoder.encode(
                        accommodationId.trim(),
                        StandardCharsets.UTF_8);

        response.sendRedirect(
                request.getContextPath()
                + "/UpdateAccommodationServlet"
                + "?accommodationId=" + safeId
                + "&error=" + error);
    }

    private void redirectToAccommodationList(
            HttpServletRequest request,
            HttpServletResponse response,
            String role,
            String query)
            throws IOException {

        if ("OWNER".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/OwnerAccommodationListServlet"
                    + "?" + query);

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/accommodation"
                    + "?" + query);
        }
    }
}