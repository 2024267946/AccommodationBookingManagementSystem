package controller;

import java.io.IOException;

import dao.AccommodationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Accommodation;

@WebServlet("/CreateAccommodationServlet")
public class CreateAccommodationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ==============================
        // Check user session
        // Only OWNER is allowed to create accommodation
        // ==============================

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String role = session.getAttribute("role").toString().trim();

        if (!role.equalsIgnoreCase("OWNER")) {
            response.sendRedirect(request.getContextPath() + "/OwnerAccommodationListServlet?error=unauthorized");
            return;
        }

        // ==============================
        // Get data from CreateAccommodation.jsp
        // ==============================

        String accommodationName = request.getParameter("accommodationName");
        String accommodationType = request.getParameter("accommodationType");
        String maxCapacityParam = request.getParameter("maxCapacity");
        String pricePerNightParam = request.getParameter("pricePerNight");
        String location = request.getParameter("location");
        String description = request.getParameter("description");

        // ==============================
        // Basic validation
        // ==============================

        if (accommodationName == null || accommodationName.trim().isEmpty()
                || accommodationType == null || accommodationType.trim().isEmpty()
                || maxCapacityParam == null || maxCapacityParam.trim().isEmpty()
                || pricePerNightParam == null || pricePerNightParam.trim().isEmpty()
                || location == null || location.trim().isEmpty()
                || description == null || description.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath()
                    + "/Owner/CreateAccommodation.jsp?error=emptyField");
            return;
        }

        try {

            int maxCapacity = Integer.parseInt(maxCapacityParam);
            double pricePerNight = Double.parseDouble(pricePerNightParam);

            // ==============================
            // Store data into Accommodation Bean
            // ==============================

            Accommodation acc = new Accommodation();

            // Accommodation ID will be generated automatically in DAO
            acc.setAccommodationName(accommodationName.trim());
            acc.setAccommodationType(accommodationType.trim());
            acc.setMaxCapacity(maxCapacity);
            acc.setPricePerNight(pricePerNight);
            acc.setLocation(location.trim());
            acc.setDescription(description.trim());

            // ==============================
            // Call DAO to insert accommodation
            // ==============================

            AccommodationDAO dao = new AccommodationDAO();

            boolean success = dao.createAccommodation(acc);

            if (success) {

                System.out.println("Accommodation created successfully.");

                response.sendRedirect(
                        request.getContextPath()
                        + "/OwnerAccommodationListServlet?message=createSuccess");

            } else {
            	response.sendRedirect(
                        request.getContextPath()
                        + "/Owner/CreateAccommodation.jsp?error=createFailed");
            }

        } catch (NumberFormatException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/Owner/CreateAccommodation.jsp?error=invalidNumber");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/Owner/CreateAccommodation.jsp?error=systemError");
        }
    }
}
            