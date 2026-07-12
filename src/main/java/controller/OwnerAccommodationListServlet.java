package controller;

import java.io.IOException;
import java.util.List;

import dao.AccommodationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Accommodation;

@WebServlet("/OwnerAccommodationListServlet")
public class OwnerAccommodationListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AccommodationDAO dao = new AccommodationDAO();

        List<Accommodation> accommodationList = dao.getAllAccommodation();

        request.setAttribute("accommodationList", accommodationList);

        request.getRequestDispatcher("/Owner/Accommodation.jsp")
               .forward(request, response);
    }
}