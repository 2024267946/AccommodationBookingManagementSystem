package controller;

import java.io.IOException;
import java.util.List;

import dao.AccommodationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Accommodation;

@WebServlet("/SearchAvailabilityServlet")
public class SearchAvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      System.out.println("SEARCH AVAILABILITY SERVLET CALLED");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String paxParam = request.getParameter("pax");

        if (checkIn == null || checkOut == null ||  paxParam == null ||
            checkIn.trim().isEmpty() ||  checkOut.trim().isEmpty() || paxParam.trim().isEmpty()) {

            request.setAttribute("message", "Please select check-in date, check-out date, and number of pax.");
            request.getRequestDispatcher("searchAvailability.jsp").forward(request, response);
            return;
        }

        int pax = Integer.parseInt(paxParam);

        AccommodationDAO dao = new AccommodationDAO();
        List<Accommodation> accommodationList = dao.searchAvailability(checkIn, checkOut, pax);

        request.setAttribute("accommodationList", accommodationList);
        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("pax", paxParam);

        request.getRequestDispatcher("searchAvailability.jsp").forward(request, response);
    }
}