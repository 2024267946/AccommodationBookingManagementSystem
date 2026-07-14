package controller;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.time.*;
import java.time.format.*;
import java.util.*;

import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
import util.AccommodationImageStore;

@MultipartConfig(maxFileSize = 10L * 1024 * 1024, maxRequestSize = 50L * 1024 * 1024)
@WebServlet(urlPatterns = {
    "/homestays",
    "/homestays/details",
    "/homestays/search",
    "/OwnerAccommodationListServlet",
    "/owner/accommodation/archive",
    "/owner/accommodation/restore",
    "/staff/accommodation",
    "/CreateAccommodationServlet",
    "/UpdateAccommodationServlet",
    "/UpdateAvailabilityServlet",
    "/accommodation-image"
})
public class AccommodationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final HomestayHandler homestayHandler = new HomestayHandler();
    private final SearchAvailabilityHandler searchHandler = new SearchAvailabilityHandler();
    private final OwnerAccommodationListHandler ownerListHandler = new OwnerAccommodationListHandler();
    private final StaffAccommodationHandler staffListHandler = new StaffAccommodationHandler();
    private final CreateAccommodationHandler createHandler = new CreateAccommodationHandler();
    private final UpdateAccommodationHandler updateHandler = new UpdateAccommodationHandler();
    private final UpdateAvailabilityHandler availabilityHandler = new UpdateAvailabilityHandler();

    @Override
    public void init() throws ServletException {
        staffListHandler.init();
        updateHandler.init();
        availabilityHandler.init();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        switch (request.getServletPath()) {
            case "/homestays":
            case "/homestays/details":
                homestayHandler.doGet(request, response);
                break;
            case "/homestays/search":
                searchHandler.doGet(request, response);
                break;
            case "/OwnerAccommodationListServlet":
            case "/owner/accommodation/archive":
            case "/owner/accommodation/restore":
                ownerListHandler.doGet(request, response);
                break;
            case "/staff/accommodation":
                staffListHandler.doGet(request, response);
                break;
            case "/UpdateAccommodationServlet":
                updateHandler.doGet(request, response);
                break;
            case "/UpdateAvailabilityServlet":
                availabilityHandler.doGet(request, response);
                break;
            case "/accommodation-image":
                serveAccommodationImage(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void serveAccommodationImage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String id = request.getParameter("id");
        int index;
        try {
            index = Integer.parseInt(request.getParameter("index"));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        java.nio.file.Path image = AccommodationImageStore.resolveStoredImage(id, index);
        if (image == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String contentType = java.nio.file.Files.probeContentType(image);
        response.setContentType(contentType == null ? "application/octet-stream" : contentType);
        response.setContentLengthLong(java.nio.file.Files.size(image));
        response.setHeader("Cache-Control", "public, max-age=3600");
        java.nio.file.Files.copy(image, response.getOutputStream());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        switch (request.getServletPath()) {
            case "/CreateAccommodationServlet":
                createHandler.doPost(request, response);
                break;
            case "/UpdateAccommodationServlet":
                updateHandler.doPost(request, response);
                break;
            case "/UpdateAvailabilityServlet":
                availabilityHandler.doPost(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private static class HomestayHandler extends HttpServlet {
        private static final long serialVersionUID = 1L;
    
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
    
            String path = request.getServletPath();
    
            switch (path) {
    
                case "/homestays":
                    homestaysPage(request, response);
                    break;
    
                case "/homestays/details":
                    homestaysDetails(request, response);
                    break;
    
                default:
                    response.sendRedirect(
                            request.getContextPath() + "/Homepage.jsp");
                    break;
            }
        }
    
        private void homestaysPage(
                HttpServletRequest request,
                HttpServletResponse response)
                throws ServletException, IOException {
    
            AccommodationDAO dao = new AccommodationDAO();
            AmenityDAO amenityDAO = new AmenityDAO();
    
            List<Accommodation> accommodationList = dao.getAllAccommodation();
            List<Amenity> amenitiesList = amenityDAO.getAllActiveAmenities();
    
            Map<String, List<Amenity>> amenityByAccom = new HashMap<>();
    
            for(Amenity amenity : amenitiesList){
                String accomId = amenity.getAccommodationId();
                List<Amenity> accomAmenities = amenityByAccom.getOrDefault(accomId, new ArrayList<>());
                accomAmenities.add(amenity);
                amenityByAccom.put(accomId, accomAmenities);
            }
    
    
            request.setAttribute("accommodationList", accommodationList);
            request.setAttribute("amenitiesMap", amenityByAccom);
    
            request.getRequestDispatcher("/homestays.jsp")
                   .forward(request, response);
        }
    
        private void homestaysDetails(
                HttpServletRequest request,
                HttpServletResponse response)
                throws ServletException, IOException {
    
                String id = request.getParameter("id");
                
                AccommodationDAO accommodationDAO = new AccommodationDAO();
                Accommodation accommodation = accommodationDAO.getAccommodationById(id);
    
                if(accommodation == null){
                    request.getRequestDispatcher("/homestayDetails.jsp?error=-1").forward(request, response);
                }else{
                    request.setAttribute("accomodation", accommodation);
                    request.getRequestDispatcher("/homestayDetails.jsp").forward(request, response);
                }
        }
    }

    private static class SearchAvailabilityHandler extends HttpServlet {
        private static final long serialVersionUID = 1L;
    
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
    
            String checkIn = request.getParameter("checkIn");
            String checkOut = request.getParameter("checkOut");
            String paxParam = request.getParameter("pax");
            String accomId = request.getParameter("id");
            String availability = request.getParameter("availability");
            String error = request.getParameter("error");
    
            if (accomId != null && (availability != null || error != null)) {
                AccommodationDAO dao = new AccommodationDAO();
                Accommodation accom = dao.getAccommodationById(accomId);
                request.setAttribute("accomodationChoosen", accom);
                request.getRequestDispatcher("/searchAvailability.jsp")
                       .forward(request, response);
                return;
            }
    
            if (checkIn == null || checkOut == null ||  paxParam == null ||
                checkIn.trim().isEmpty() ||  checkOut.trim().isEmpty() || paxParam.trim().isEmpty()) {
    
                if(accomId == null){
                    request.getRequestDispatcher("/searchAvailability.jsp").forward(request, response);
                    return;
                }else{
                    AccommodationDAO dao = new AccommodationDAO();
                    Accommodation accom = dao.getAccommodationById(accomId);
                    request.setAttribute("accomodationChoosen", accom);
                    request.getRequestDispatcher("/searchAvailability.jsp").forward(request, response);
                    return;
                }
    
            }
    
            int pax = Integer.parseInt(paxParam);
    
            if(accomId == null){
                AccommodationDAO dao = new AccommodationDAO();
                List<Accommodation> accommodationList = dao.searchAvailability(checkIn, checkOut, pax);
    
                request.setAttribute("accommodationList", accommodationList);
                request.setAttribute("checkIn", checkIn);
                request.setAttribute("checkOut", checkOut);
                request.setAttribute("pax", paxParam);
    
                request.getRequestDispatcher("/searchAvailability.jsp").forward(request, response);
            }else{
                AccommodationDAO dao = new AccommodationDAO();
                List<Accommodation> accommodationList =
                        dao.searchAvailability(checkIn, checkOut, pax);
    
                boolean accommodationIsAvailable = false;
    
                for (Accommodation accommodation : accommodationList) {
                    if (accomId.equals(accommodation.getAccommodationId())) {
                        accommodationIsAvailable = true;
                        break;
                    }
                }
    
                String encodedAccomId = URLEncoder.encode(
                        accomId,
                        StandardCharsets.UTF_8);
    
                response.sendRedirect(
                        request.getContextPath()
                        + "/homestays/search?id="
                        + encodedAccomId
                        + "&availability="
                        + (accommodationIsAvailable ? "True" : "False")
                        + "&checkIn=" + URLEncoder.encode(checkIn, StandardCharsets.UTF_8)
                        + "&checkOut=" + URLEncoder.encode(checkOut, StandardCharsets.UTF_8)
                        + "&pax=" + URLEncoder.encode(paxParam, StandardCharsets.UTF_8));
            }
    
        }
    }

    private static class OwnerAccommodationListHandler extends HttpServlet {
        private static final long serialVersionUID = 1L;
    
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("role") == null
                    || !"OWNER".equalsIgnoreCase(session.getAttribute("role").toString())) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
                return;
            }

            AccommodationDAO dao = new AccommodationDAO();

            String path = request.getServletPath();
            if ("/owner/accommodation/archive".equals(path)
                    || "/owner/accommodation/restore".equals(path)) {
                String id = request.getParameter("id");
                if (id == null || id.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath()
                            + "/OwnerAccommodationListServlet?error=missingId");
                    return;
                }

                boolean restoring = "/owner/accommodation/restore".equals(path);
                boolean success = restoring
                        ? dao.restoreAccommodation(id.trim())
                        : dao.archiveAccommodation(id.trim());
                response.sendRedirect(request.getContextPath()
                        + "/OwnerAccommodationListServlet?tab="
                        + (restoring ? "archived" : "active")
                        + (success
                            ? "&message=" + (restoring ? "restoreSuccess" : "archiveSuccess")
                            : "&error=statusUpdateFailed"));
                return;
            }

            request.setAttribute("accommodationList", dao.getAllAccommodation());
            request.setAttribute("archivedAccommodationList", dao.getArchivedAccommodation());
    
            request.getRequestDispatcher("/Owner/Accommodation.jsp")
                   .forward(request, response);
        }
    }

    private static class StaffAccommodationHandler extends HttpServlet {
    
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
                request.setAttribute("staffView", Boolean.TRUE);
                request.getRequestDispatcher(
                    "/Owner/Accommodation.jsp"
                ).forward(request, response);
    
            } catch (Exception e) {
    
                e.printStackTrace();
    
                request.setAttribute(
                    "errorMessage",
                    "Unable to load accommodation records."
                );
                request.setAttribute("staffView", Boolean.TRUE);
                request.getRequestDispatcher(
                    "/Owner/Accommodation.jsp"
                ).forward(request, response);
            }
        }
    }

    private static class CreateAccommodationHandler extends HttpServlet {
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
            String numberOfRoomsParam = request.getParameter("numberOfRooms");
            String hasLivingHall = request.getParameter("hasLivingHall");
            String roomNumber = request.getParameter("roomNumber");
            String floorLevel = request.getParameter("floorLevel");
            String chaletCategory = request.getParameter("chaletCategory");
    
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

            String normalizedType = accommodationType.trim().toUpperCase(Locale.ROOT);
            boolean isHomestay = "HOMESTAY".equals(normalizedType);
            boolean isChalet = "CHALET".equals(normalizedType);
            boolean validHomestay = isHomestay
                    && numberOfRoomsParam != null && !numberOfRoomsParam.trim().isEmpty()
                    && ("YES".equalsIgnoreCase(hasLivingHall) || "NO".equalsIgnoreCase(hasLivingHall));
            boolean validCategory = "STANDARD".equalsIgnoreCase(chaletCategory)
                    || "PREMIUM".equalsIgnoreCase(chaletCategory)
                    || "LUXURY".equalsIgnoreCase(chaletCategory);
            boolean validChalet = isChalet
                    && roomNumber != null && !roomNumber.trim().isEmpty()
                    && floorLevel != null && !floorLevel.trim().isEmpty()
                    && validCategory;

            if ((!isHomestay && !isChalet) || (isHomestay && !validHomestay)
                    || (isChalet && !validChalet)) {
                response.sendRedirect(request.getContextPath()
                        + "/Owner/CreateAccommodation.jsp?error=subtypeField");
                return;
            }
    
            try {
    
                int maxCapacity = Integer.parseInt(maxCapacityParam);
                double pricePerNight = Double.parseDouble(pricePerNightParam);
                Integer numberOfRooms = isHomestay
                        ? Integer.valueOf(numberOfRoomsParam.trim()) : null;

                if (maxCapacity < 1 || pricePerNight < 0
                        || (numberOfRooms != null && numberOfRooms < 1)) {
                    throw new NumberFormatException("Values must be within the allowed range");
                }
    
                // ==============================
                // Store data into Accommodation Bean
                // ==============================
    
                Accommodation acc = new Accommodation();
    
                // Accommodation ID will be generated automatically in DAO
                acc.setAccommodationName(accommodationName.trim());
                acc.setAccommodationType(normalizedType);
                acc.setMaxCapacity(maxCapacity);
                acc.setPricePerNight(pricePerNight);
                acc.setLocation(location.trim());
                acc.setDescription(description.trim());
    
                // ==============================
                // Call DAO to insert accommodation
                // ==============================
    
                AccommodationDAO dao = new AccommodationDAO();
    
                boolean success = dao.createAccommodation(
                        acc,
                        numberOfRooms,
                        isHomestay ? hasLivingHall.toUpperCase(Locale.ROOT) : null,
                        isChalet ? roomNumber.trim() : null,
                        isChalet ? floorLevel.trim() : null,
                        isChalet ? chaletCategory.toUpperCase(Locale.ROOT) : null);
    
                if (success) {
                    try {
                        AccommodationImageStore.saveUploadedImages(request,
                                acc.getAccommodationId());
                    } catch (Exception imageError) {
                        imageError.printStackTrace();
                    }
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

    private static class UpdateAccommodationHandler extends HttpServlet {
    
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
            request.setAttribute("subtypeDetails",
                    accommodationDAO.getAccommodationSubtype(
                            accommodation.getAccommodationId(), accommodation.getAccommodationType()));
    
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
            String numberOfRoomsParam = request.getParameter("numberOfRooms");
            String hasLivingHall = request.getParameter("hasLivingHall");
            String roomNumber = request.getParameter("roomNumber");
            String floorLevel = request.getParameter("floorLevel");
            String chaletCategory = request.getParameter("chaletCategory");
    
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
                String normalizedType = accommodationType.trim().toUpperCase(Locale.ROOT);
                boolean homestay = "HOMESTAY".equals(normalizedType);
                boolean chalet = "CHALET".equals(normalizedType);
                Integer numberOfRooms = homestay && !isBlank(numberOfRoomsParam)
                        ? Integer.valueOf(numberOfRoomsParam.trim()) : null;
                boolean validSubtype = homestay
                        ? numberOfRooms != null && numberOfRooms > 0
                            && ("YES".equalsIgnoreCase(hasLivingHall) || "NO".equalsIgnoreCase(hasLivingHall))
                        : chalet && !isBlank(roomNumber) && !isBlank(floorLevel)
                            && ("STANDARD".equalsIgnoreCase(chaletCategory)
                                || "PREMIUM".equalsIgnoreCase(chaletCategory)
                                || "LUXURY".equalsIgnoreCase(chaletCategory));
                if (!validSubtype) {
                    redirectBackToEdit(request, response, accommodationId, "subtypeField");
                    return;
                }
    
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
                        normalizedType);
    
                accommodation.setLocation(
                        location.trim());
    
                accommodation.setPricePerNight(
                        pricePerNight);
    
                accommodation.setMaxCapacity(
                        maxCapacity);
    
                accommodation.setDescription(
                        description.trim());
    
                boolean accommodationUpdated =
                        accommodationDAO.updateAccommodation(accommodation, numberOfRooms,
                                homestay ? hasLivingHall.toUpperCase(Locale.ROOT) : null,
                                chalet ? roomNumber.trim() : null,
                                chalet ? floorLevel.trim() : null,
                                chalet ? chaletCategory.toUpperCase(Locale.ROOT) : null);
    
                if (!accommodationUpdated) {
                    redirectBackToEdit(
                            request,
                            response,
                            accommodationId,
                            "updateFailed");
                    return;
                }

                try {
                    AccommodationImageStore.saveUploadedImages(request,
                            accommodation.getAccommodationId());
                } catch (Exception imageError) {
                    imageError.printStackTrace();
                    redirectBackToEdit(request, response, accommodationId, "imageFailed");
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

    private static class UpdateAvailabilityHandler extends HttpServlet {
        private static final long serialVersionUID = 1L;
        private AccommodationDAO accommodationDAO;
    
        @Override
        public void init() {
            accommodationDAO = new AccommodationDAO();
        }
    
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
    
            String role = authorizedRole(request, response);
            if (role == null) return;
    
            String accommodationID = request.getParameter("accommodationID");
            if (isBlank(accommodationID)) {
                redirectToAccommodationList(request, response, role,
                        "error=missingAccommodationID");
                return;
            }
    
            accommodationID = accommodationID.trim();
            Accommodation accommodation =
                    accommodationDAO.getAccommodationById(accommodationID);
    
            if (accommodation == null) {
                redirectToAccommodationList(request, response, role,
                        "error=accommodationNotFound");
                return;
            }
    
            request.setAttribute("accommodation", accommodation);
            request.setAttribute("accommodationID", accommodationID);
            request.setAttribute("unavailableDates",
                    accommodationDAO.getUnavailableDates(accommodationID));
            request.setAttribute("role", role);
            request.getRequestDispatcher("/availabilityCalendar.jsp")
                   .forward(request, response);
        }
    
        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
    
            String role = authorizedRole(request, response);
            if (role == null) return;
    
            String accommodationID = request.getParameter("accommodationID");
            String submittedDates = request.getParameter("unavailableDates");
    
            if (isBlank(accommodationID)) {
                redirectToAccommodationList(request, response, role,
                        "error=missingAccommodationID");
                return;
            }
    
            String normalizedDates;
            try {
                normalizedDates = normalizeDates(submittedDates);
            } catch (IllegalArgumentException e) {
                redirectBackToCalendar(request, response, accommodationID,
                        "error=invalidDates");
                return;
            }
    
            if (normalizedDates.length() > 4000) {
                redirectBackToCalendar(request, response, accommodationID,
                        "error=tooManyDates");
                return;
            }
    
            if (accommodationDAO.updateUnavailableDates(
                    accommodationID.trim(), normalizedDates)) {
                redirectToAccommodationList(request, response, role,
                        "message=availabilityUpdateSuccess");
            } else {
                redirectBackToCalendar(request, response, accommodationID,
                        "error=failed");
            }
        }
    
        private String normalizeDates(String submittedDates) {
            if (submittedDates == null || submittedDates.isBlank()) return "";
    
            Set<String> dates = new TreeSet<>();
            for (String value : submittedDates.split(",")) {
                String date = value.trim();
                if (date.isEmpty()) continue;
    
                try {
                    LocalDate parsedDate = LocalDate.parse(date);
                    if (!parsedDate.isBefore(LocalDate.now())) {
                        dates.add(parsedDate.toString());
                    }
                } catch (DateTimeParseException e) {
                    throw new IllegalArgumentException("Invalid date", e);
                }
            }
            return String.join(",", dates);
        }
    
        private String authorizedRole(
                HttpServletRequest request,
                HttpServletResponse response) throws IOException {
    
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("role") == null) {
                response.sendRedirect(request.getContextPath()
                        + "/login.jsp?error=unauthorized");
                return null;
            }
    
            String role = session.getAttribute("role").toString().trim();
            if (!"OWNER".equalsIgnoreCase(role)
                    && !"STAFF".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath()
                        + "/login.jsp?error=unauthorized");
                return null;
            }
            return role;
        }
    
        private void redirectBackToCalendar(
                HttpServletRequest request,
                HttpServletResponse response,
                String accommodationID,
                String message) throws IOException {
    
            response.sendRedirect(request.getContextPath()
                    + "/UpdateAvailabilityServlet?accommodationID="
                    + encode(accommodationID) + "&" + message);
        }
    
        private void redirectToAccommodationList(
                HttpServletRequest request,
                HttpServletResponse response,
                String role,
                String message) throws IOException {
    
            String path = "OWNER".equalsIgnoreCase(role)
                    ? "/OwnerAccommodationListServlet"
                    : "/staff/accommodation";
            response.sendRedirect(request.getContextPath() + path + "?" + message);
        }
    
        private String encode(String value) {
            return URLEncoder.encode(value == null ? "" : value.trim(),
                    StandardCharsets.UTF_8);
        }
    
        private boolean isBlank(String value) {
            return value == null || value.trim().isEmpty();
        }
    }
}
