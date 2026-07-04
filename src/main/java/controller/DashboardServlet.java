package controller;

import dao.DashboardDAO;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DashboardDAO dashboardDAO;

    @Override
    public void init() throws ServletException {
        dashboardDAO = new DashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        viewDashboard(request, response);
    }

    private void viewDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedStaff") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int totalGuests = dashboardDAO.getTotalGuests();
        int activeBookings = dashboardDAO.getActiveBookings();
        int totalUnits = dashboardDAO.getTotalUnits();

        request.setAttribute("totalGuests", totalGuests);
        request.setAttribute("activeBookings", activeBookings);
        request.setAttribute("totalUnits", totalUnits);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}