package controller;

import java.io.IOException;
import java.util.List;

import dao.AccommodationDAO;
import dao.AmenityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Accommodation;
import model.Amenity;

@WebServlet(urlPatterns = {
    "/amenity",
    "/amenity/create",
    "/amenity/update",
    "/amenity/archive"
})
public class AmenityServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AmenityDAO amenityDAO;
    private AccommodationDAO accommodationDAO;

    @Override
    public void init() {
        amenityDAO = new AmenityDAO();
        accommodationDAO = new AccommodationDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
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
                response.sendRedirect(
                        request.getContextPath() + "/amenity");
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

            case "/amenity/create":
                executeCreate(request, response);
                break;

            case "/amenity/update":
                executeUpdate(request, response);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath() + "/amenity");
                break;
        }
    }

    private void listAmenities(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Amenity> amenityList =
                amenityDAO.getAllActiveAmenities();

        List<Accommodation> accommodationList =
                accommodationDAO.getAllAccommodation();

        request.setAttribute(
                "amenityList",
                amenityList);

        request.setAttribute(
                "accommodationList",
                accommodationList);

        request.getRequestDispatcher(
                "/Owner/amenity.jsp")
               .forward(request, response);
    }

    private void executeCreate(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String amenityName =
                request.getParameter("amenityName");

        String accommodationId =
                request.getParameter("accommodationId");

        if (isBlank(amenityName)
                || isBlank(accommodationId)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/amenity?error=missingField");
            return;
        }

        boolean success =
                amenityDAO.addAmenityToAccommodation(
                        amenityName.trim(),
                        accommodationId.trim());

        if (success) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/amenity?message=createSuccess");

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/amenity?error=createFailed");
        }
    }

    private void executeUpdate(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String amenityIdParam =
                request.getParameter("amenityId");

        String amenityName =
                request.getParameter("amenityName");

        if (isBlank(amenityIdParam)
                || isBlank(amenityName)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/amenity?error=missingField");
            return;
        }

        try {
            int amenityId =
                    Integer.parseInt(amenityIdParam);

            Amenity amenity =
                    new Amenity();

            amenity.setAmenityId(
                    amenityId);

            amenity.setAmenityName(
                    amenityName.trim());

            boolean success =
                    amenityDAO.updateAmenity(amenity);

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/amenity?message=updateSuccess");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/amenity?error=updateFailed");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/amenity?error=invalidId");
        }
    }

    private void executeArchive(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String amenityIdParam =
                request.getParameter("id");

        if (isBlank(amenityIdParam)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/amenity?error=missingId");
            return;
        }

        try {
            int amenityId =
                    Integer.parseInt(amenityIdParam);

            boolean success =
                    amenityDAO.archiveAmenity(amenityId);

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/amenity?message=archiveSuccess");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/amenity?error=archiveFailed");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/amenity?error=invalidId");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}