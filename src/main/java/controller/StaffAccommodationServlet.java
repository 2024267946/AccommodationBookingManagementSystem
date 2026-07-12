package controller;

import java.io.IOException;
import java.util.List;

import dao.AccommodationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Accommodation;

@WebServlet("/staff/accommodation")
public class StaffAccommodationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AccommodationDAO accommodationDAO;

    @Override
    public void init() {
        accommodationDAO = new AccommodationDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Pastikan user sudah login
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String role = (String) session.getAttribute("role");

        if (!"STAFF".equalsIgnoreCase(role)) {
            response.sendRedirect(
                request.getContextPath() + "/Owner/dashboard.jsp"
            );
            return;
        }
        
        try {
            List<Accommodation> accommodationList =
                    accommodationDAO.getAllAccommodation();

            request.setAttribute(
                "accommodationList",
                accommodationList
            );

            request.getRequestDispatcher(
                "/Staff/StaffAccommodation.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                "errorMessage",
                "Unable to load accommodation records."
            );

            request.getRequestDispatcher(
                "/Staff/StaffAccommodation.jsp"
            ).forward(request, response);
        }
    }
}