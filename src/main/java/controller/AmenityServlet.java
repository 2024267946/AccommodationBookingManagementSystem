package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Amenity;
import dao.AmenityDAO;

@WebServlet(urlPatterns = {
    "/amenity",
    "/amenity/create",
    "/amenity/update",
    "/amenity/archive"
})
public class AmenityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AmenityDAO amenityDAO;

    public void init() {
        amenityDAO = new AmenityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case "/amenity":
                listAmenities(request, response);
                break;
            case "/amenity/archive":
                executeArchive(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/amenity");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        switch (path) {
            case "/amenity/create":
                executeCreate(request, response);
                break;
            case "/amenity/update":
                executeUpdate(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/amenity");
                break;
        }
    }

    private void listAmenities(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Amenity> activeAmenities = amenityDAO.getAllActiveAmenities();
        request.setAttribute("amenityList", activeAmenities);
        request.getRequestDispatcher("/amenity.jsp").forward(request, response);
    }

    private void executeCreate(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String name = request.getParameter("amenityName");

        Amenity newAmenity = new Amenity();
        newAmenity.setAmenityName(name);

        amenityDAO.createAmenity(newAmenity);
        response.sendRedirect(request.getContextPath() + "/amenity");
    }

    private void executeUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("amenityId"));
        String name = request.getParameter("amenityName");

        Amenity updatedAmenity = new Amenity();
        updatedAmenity.setAmenityId(id);
        updatedAmenity.setAmenityName(name);

        amenityDAO.updateAmenity(updatedAmenity);
        response.sendRedirect(request.getContextPath() + "/amenity");
    }

    private void executeArchive(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        amenityDAO.archiveAmenity(id);
        response.sendRedirect(request.getContextPath() + "/amenity");
    }
}