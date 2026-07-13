package controller;

import java.io.IOException;
import java.util.*;

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
    "/owner/amenity",
    "/owner/amenity/create",
    "/owner/amenity/update",
    "/owner/amenity/archive",
    "/owner/amenity/restore",
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

            case "/owner/amenity":
                listAmenities(request, response);
                break;

            case "/owner/amenity/archive":
                executeArchive(request, response);
                break;

            case "/owner/amenity/restore":
                executeRestore(request, response);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath() + "/owner/amenity");
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

            case "/owner/amenity/create":
                executeCreate(request, response);
                break;

            case "/owner/amenity/update":
                executeUpdate(request, response);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath() + "/owner/amenity");
                break;
        }
    }

    private void listAmenities(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Amenity> amenityList =
                amenityDAO.getAllActiveAmenities();

        List<Amenity> archivedAmenityList =
                amenityDAO.getArchivedAmenities();

        List<Accommodation> accommodationList =
                accommodationDAO.getAllAccommodation();

        List<Accommodation> allAccommodationList =
                accommodationDAO.getAllAccommodationIncludingArchived();

        Map<String, Map<String, Object>> amenityAccomodation =
                mapAmenities(amenityList, allAccommodationList);
        Map<String, Map<String, Object>> archivedAmenityAccommodation =
                mapAmenities(archivedAmenityList, allAccommodationList);

        request.setAttribute("amenityList", amenityAccomodation);
        request.setAttribute("archivedAmenityList", archivedAmenityAccommodation);
        request.setAttribute("accommodationList", accommodationList);

        request.getRequestDispatcher("/Owner/amenity.jsp").forward(request, response);
    }

    private Map<String, Map<String, Object>> mapAmenities(
            List<Amenity> amenities, List<Accommodation> accommodations) {
        Map<String, Map<String, Object>> result = new LinkedHashMap<>();

        for (Amenity amenity : amenities) {
                String accomID = amenity.getAccommodationId();
                String accomName = "Unknown";

                for (Accommodation accom : accommodations) {
                        if (accom.getAccommodationId().equals(accomID)) {
                            accomName = accom.getAccommodationName();
                            break;
                        }
                }

                Map<String,Object> res = new HashMap<>();
                res.put("amenity", amenity);
                res.put("accomName", accomName);
                result.put(String.valueOf(amenity.getAmenityId()), res);
        }
        return result;
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
                    + "/owner/amenity?error=missingField");
            return;
        }

        boolean success =
                amenityDAO.addAmenityToAccommodation(
                        amenityName.trim(),
                        accommodationId.trim());

        if (success) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/owner/amenity?message=createSuccess");

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/owner/amenity?error=createFailed");
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
                    + "/owner/amenity?error=missingField");
            return;
        }

        try {
            String amenityId =
                    amenityIdParam;

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
                        + "/owner/amenity?message=updateSuccess");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/owner/amenity?error=updateFailed");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/owner/amenity?error=invalidId");
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
                    + "/owner/amenity?error=missingId");
            return;
        }

        try {
            String amenityId = amenityIdParam.trim();

            boolean success =
                    amenityDAO.archiveAmenity(amenityId);

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/owner/amenity?message=archiveSuccess");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/owner/amenity?error=archiveFailed");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/owner/amenity?error=invalidId");
        }
    }

    private void executeRestore(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String amenityId = request.getParameter("id");
        if (isBlank(amenityId)) {
            response.sendRedirect(request.getContextPath()
                    + "/owner/amenity?tab=archived&error=missingId");
            return;
        }

        boolean success = amenityDAO.restoreAmenity(amenityId.trim());
        response.sendRedirect(request.getContextPath()
                + "/owner/amenity?tab=archived&"
                + (success ? "message=restoreSuccess" : "error=restoreFailed"));
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
