package controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

import dao.GuestDAO;
import dao.DashboardDAO;
import dao.StaffDAO;
import dao.ProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Staff;
import model.Profile;

@WebServlet(urlPatterns = { "/owner/dashboard", "/owner/dashboard/report", "/owner/view-staff", "/owner/view-guest",
		"/owner/create-staff", "/owner/archive-staff", "/owner/view-archived-staff", "/owner/restore-staff",
		"/owner/archive-guest", "/owner/view-archived-guest", "/owner/restore-guest",
		"/Owner/myProfile", "/owner/update-profile",

		"/staff/dashboard", "/staff/dashboard/report", "/staff/my-profile", "/staff/user-management",
		"/staff/archived-staff", "/staff/archived-guest", "/staff/update-profile" })
public class StaffServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private StaffDAO staffDAO;
	private GuestDAO guestDAO;
	private DashboardDAO dashboardDAO;
	private ProfileDAO profileDAO;

	@Override
	public void init() {
		staffDAO = new StaffDAO();
		guestDAO = new GuestDAO();
		dashboardDAO = new DashboardDAO();
		profileDAO = new ProfileDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getServletPath();

		switch (path) {
		case "/Owner/myProfile":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}
			openManagementProfile(request, response, "OWNER");
			break;

		case "/owner/dashboard":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			openDashboard(request, response, "OWNER");
			break;

		case "/owner/dashboard/report":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}
			downloadDashboardReport(response, "OWNER");
			break;

		case "/owner/view-staff":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			request.setAttribute("staffList", staffDAO.getAllStaff());

			request.setAttribute("guestList", guestDAO.getAllGuest());

			request.getRequestDispatcher("/Owner/userManagement.jsp").forward(request, response);
			break;

		case "/owner/view-guest":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			request.setAttribute("staffList", staffDAO.getAllStaff());

			request.setAttribute("guestList", guestDAO.getAllGuest());

			request.getRequestDispatcher("/Owner/userManagement.jsp").forward(request, response);
			break;

		case "/owner/create-staff":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			request.getRequestDispatcher("/Owner/createStaff.jsp").forward(request, response);
			break;

		case "/owner/view-archived-staff":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			viewArchivedStaff(request, response);
			break;

		case "/owner/archive-staff":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			archiveStaff(request, response);
			break;

		case "/owner/view-archived-guest":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			viewArchivedGuest(request, response);
			break;

		case "/owner/archive-guest":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			archiveGuest(request, response);
			break;

		case "/staff/dashboard":
			if (!isRole(request, "STAFF")) {
				redirectUnauthorized(request, response);
				return;
			}

			openDashboard(request, response, "STAFF");
			break;

		case "/staff/dashboard/report":
			if (!isRole(request, "STAFF")) {
				redirectUnauthorized(request, response);
				return;
			}
			downloadDashboardReport(response, "STAFF");
			break;

		case "/staff/my-profile":
			if (!isRole(request, "STAFF")) {
				redirectUnauthorized(request, response);
				return;
			}
			openManagementProfile(request, response, "STAFF");
			break;

		case "/staff/user-management":
			if (!isRole(request, "STAFF")) {
				redirectUnauthorized(request, response);
				return;
			}
			request.setAttribute("staffList", staffDAO.getAllStaff());
			request.setAttribute("guestList", guestDAO.getAllGuest());
			// Fixed: Added the /Staff/ folder directory prefix
			request.getRequestDispatcher("/Staff/StaffUserManagement.jsp").forward(request, response);
			break;

		case "/staff/archived-staff":
			if (!isRole(request, "STAFF")) {
				redirectUnauthorized(request, response);
				return;
			}
			request.setAttribute("archivedStaffList", staffDAO.getArchivedStaff());
			// Fixed: Added the /Staff/ folder directory prefix
			request.getRequestDispatcher("/Staff/StaffArchivedStaff.jsp").forward(request, response);
			break;

		case "/staff/archived-guest":
			if (!isRole(request, "STAFF")) {
				redirectUnauthorized(request, response);
				return;
			}
			request.setAttribute("archivedGuestList", guestDAO.getArchivedGuests());
			// Fixed: Added the /Staff/ folder directory prefix
			request.getRequestDispatcher("/Staff/StaffArchivedGuest.jsp").forward(request, response);
			break;

		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			break;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getServletPath();

		switch (path) {
		case "/owner/update-profile":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}
			updateManagementProfile(request, response, "OWNER");
			break;

		case "/owner/create-staff":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			createStaff(request, response);
			break;

		case "/owner/restore-staff":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			restoreStaff(request, response);
			break;

		case "/owner/restore-guest":
			if (!isRole(request, "OWNER")) {
				redirectUnauthorized(request, response);
				return;
			}

			restoreGuest(request, response);
			break;

		case "/staff/update-profile":
			if (!isRole(request, "STAFF")) {
				redirectUnauthorized(request, response);
				return;
			}
			updateManagementProfile(request, response, "STAFF");
			break;

		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			break;
		}
	}

	private void openManagementProfile(HttpServletRequest request, HttpServletResponse response,
			String role) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		String staffId = session == null ? null : (String) session.getAttribute("staffID");
		Profile profile = staffId == null ? null : profileDAO.getProfileById(staffId, role);
		if (profile == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp?error=profileNotFound");
			return;
		}
		request.setAttribute("profile", profile);
		if ("STAFF".equalsIgnoreCase(role)) {
			Staff loggedStaff = (Staff) session.getAttribute("loggedStaff");
			if (loggedStaff != null) {
				loggedStaff.setStaffName(profile.getName());
				loggedStaff.setStaffEmail(profile.getEmail());
				loggedStaff.setStaffPhoneNumber(profile.getPhone());
			}
			request.getRequestDispatcher("/Staff/StaffMyProfile.jsp").forward(request, response);
		} else {
			request.getRequestDispatcher("/Owner/myProfile.jsp").forward(request, response);
		}
	}

	private void updateManagementProfile(HttpServletRequest request, HttpServletResponse response,
			String role) throws IOException {
		HttpSession session = request.getSession(false);
		String staffId = session == null ? null : (String) session.getAttribute("staffID");
		String returnPath = "OWNER".equalsIgnoreCase(role) ? "/Owner/myProfile" : "/staff/my-profile";
		String name = request.getParameter("fullName");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");
		if (staffId == null || isBlank(name) || isBlank(phone) || isBlank(email)) {
			response.sendRedirect(request.getContextPath() + returnPath + "?error=invalidProfile");
			return;
		}
		if (staffDAO.isEmailTaken(email.trim(), staffId)) {
	        response.sendRedirect(request.getContextPath() + returnPath + "?error=emailAlreadyTaken");
	        return;
	    }
		ProfileDAO profileDAO = new ProfileDAO(); // Make sure you have this or use your existing instance
	    if (profileDAO.isEmailTaken(email.trim(), staffId)) {
	        response.sendRedirect(request.getContextPath() + returnPath + "?error=emailAlreadyTaken");
	        return;
	    }
		boolean changingPassword = !isBlank(newPassword) || !isBlank(confirmPassword);
		if (changingPassword && (isBlank(newPassword) || isBlank(confirmPassword)
				|| newPassword.length() < 6 || !newPassword.equals(confirmPassword))) {
			response.sendRedirect(request.getContextPath() + returnPath + "?error=passwordMismatch");
			return;
		}
		Profile profile = new Profile();
		profile.setId(staffId);
		profile.setName(name.trim());
		profile.setPhone(phone.trim());
		profile.setEmail(email.trim());
		profile.setPassword(changingPassword ? newPassword : null);
		profile.setRole(role);
		if (!profileDAO.updateProfile(profile)) {
			response.sendRedirect(request.getContextPath() + returnPath + "?error=updateFailed");
			return;
		}
		Object logged = session.getAttribute("loggedStaff");
		if (logged instanceof Staff) {
			Staff staff = (Staff) logged;
			staff.setStaffName(profile.getName());
			staff.setStaffEmail(profile.getEmail());
			staff.setStaffPhoneNumber(profile.getPhone());
		}
		session.setAttribute("staffName", profile.getName());
		response.sendRedirect(request.getContextPath() + returnPath + "?updateSuccess=true");
	}

	private void createStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String staffName = request.getParameter("staffName");
		String staffPassword = request.getParameter("staffPassword");
		String confirmStaffPassword = request.getParameter("confirmStaffPassword");
		String staffEmail = request.getParameter("staffEmail");
		String staffPhoneNumber = request.getParameter("staffPhoneNumber");

		if (isBlank(staffName) || isBlank(staffPassword) || isBlank(confirmStaffPassword) || isBlank(staffEmail)
				|| isBlank(staffPhoneNumber)) {
			response.sendRedirect(request.getContextPath() + "/owner/create-staff?error=missingField");
			return;
		}

		if (!staffPassword.equals(confirmStaffPassword)) {
			response.sendRedirect(request.getContextPath() + "/owner/create-staff?error=passwordMismatch");
			return;
		}

		if (staffPassword.length() < 6) {
			response.sendRedirect(request.getContextPath() + "/owner/create-staff?error=invalidPassword");
			return;
		}

		Staff staff = new Staff();

		staff.setStaffName(staffName.trim());

		staff.setStaffPassword(staffPassword);

		staff.setStaffEmail(staffEmail.trim());

		staff.setStaffPhoneNumber(staffPhoneNumber.trim());

		staff.setStaffRoles("STAFF");
		staff.setStatus("ACTIVE");

		boolean success = staffDAO.addStaff(staff);

		if (success) {
			response.sendRedirect(request.getContextPath() + "/owner/view-staff?notification=staffCreated");
		} else {
			response.sendRedirect(request.getContextPath() + "/owner/create-staff?error=createFailed");
		}
	}

	private void viewArchivedStaff(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Staff> archivedStaffList = staffDAO.getArchivedStaff();

		request.setAttribute("archivedStaffList", archivedStaffList);

		request.getRequestDispatcher("/Owner/ArchivedStaff.jsp").forward(request, response);
	}

	private void viewArchivedGuest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setAttribute("archivedGuestList", guestDAO.getArchivedGuests());

		request.getRequestDispatcher("/Owner/ArchivedGuest.jsp").forward(request, response);
	}

	private void openStaffProfileUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("loggedStaff") == null) {

			redirectUnauthorized(request, response);
			return;
		}

		Staff loggedStaff = (Staff) session.getAttribute("loggedStaff");

		Staff staff = staffDAO.getStaffByID(loggedStaff.getStaffId());

		request.setAttribute("staff", staff);

		request.getRequestDispatcher("/Staff/StaffUpdateProfile.jsp").forward(request, response);
	}

	private void updateOwnStaffProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("loggedStaff") == null) {
			redirectUnauthorized(request, response);
			return;
		}

		Staff loggedStaff = (Staff) session.getAttribute("loggedStaff");
		Staff staff = new Staff();

		staff.setStaffId(loggedStaff.getStaffId());
		staff.setStaffName(request.getParameter("staffName"));
		staff.setStaffEmail(request.getParameter("staffEmail"));
		staff.setStaffPhoneNumber(request.getParameter("staffPhoneNumber"));
		staff.setStaffRoles(loggedStaff.getStaffRoles());
		staff.setStatus("ACTIVE");

		boolean success = staffDAO.updateStaff(staff);

		if (success) {
			session.setAttribute("loggedStaff", staff);
			session.setAttribute("staffID", staff.getStaffId());
			session.setAttribute("staffName", staff.getStaffName());
			response.sendRedirect(request.getContextPath() + "/staff/my-profile?updateSuccess=true");
		} else {
			response.sendRedirect(request.getContextPath() + "/staff/my-profile?error=true");
		}

	}

	private void archiveStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {

	    String staffID = request.getParameter("staffID");

	    // Handle invalid ID case first
	    if (staffID == null || staffID.trim().isEmpty()) {
	        request.getSession().setAttribute("errorMessage", "Invalid staff ID.");
	        response.sendRedirect(request.getContextPath() + "/owner/view-staff");
	        return; // STOP execution here
	    }

	    // Fetch the staff object
	    Staff staffToArchive = staffDAO.getStaffByID(staffID.trim());

	    // Check if that staff member is an OWNER
	    if (staffToArchive != null && "OWNER".equalsIgnoreCase(staffToArchive.getStaffRoles())) {
	        request.getSession().setAttribute("errorMessage", "Security Alert: Owners cannot be archived.");
	        response.sendRedirect(request.getContextPath() + "/owner/view-staff");
	        return; // STOP execution here
	    }

	    // Perform the archive action
	    boolean success = staffDAO.archiveStaff(staffID.trim());
	    if (success) {
	        response.sendRedirect(request.getContextPath() + "/owner/view-staff?notification=staffArchived");
	    } else {
	        response.sendRedirect(request.getContextPath() + "/owner/view-staff?error=archiveFailed");
	    }
	    
	    // NO final redirect here, because all paths above end with a return
	}

	private void restoreStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String staffID = request.getParameter("staffID");

		boolean success = staffID != null && !staffID.trim().isEmpty() && staffDAO.restoreStaff(staffID.trim());

		if (success) {
			request.getSession().setAttribute("successMessage", "Staff restored successfully.");
		} else {
			request.getSession().setAttribute("errorMessage", "Unable to restore this staff.");
		}

		response.sendRedirect(request.getContextPath() + "/owner/view-archived-staff");
	}

	private void archiveGuest(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String guestID = request.getParameter("guestID");

		boolean success = guestID != null && !guestID.trim().isEmpty() && guestDAO.archiveGuest(guestID.trim());

		if (success) {
			request.getSession().setAttribute("successMessage", "Account Archived.");
	        response.sendRedirect(request.getContextPath() + "/owner/view-guest?notification=guestArchived");
	        return;
		} else {
			request.getSession().setAttribute("errorMessage", "Unable to archive this guest.");
	        response.sendRedirect(request.getContextPath() + "/owner/view-guest?error=archiveFailed");
	        return;
		}
	}

	private void restoreGuest(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String guestID = request.getParameter("guestID");

		boolean success = guestID != null && !guestID.trim().isEmpty() && guestDAO.restoreGuest(guestID.trim());

		if (success) {
			request.getSession().setAttribute("successMessage", "Guest restored successfully.");
		} else {
			request.getSession().setAttribute("errorMessage", "Unable to restore this guest.");
		}

		response.sendRedirect(request.getContextPath() + "/owner/view-archived-guest");
	}

	private boolean isRole(HttpServletRequest request, String requiredRole) {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("role") == null) {
			return false;
		}

		String role = session.getAttribute("role").toString().trim();

		return requiredRole.equalsIgnoreCase(role);
	}

	private void openDashboard(HttpServletRequest request, HttpServletResponse response, String role)
			throws ServletException, IOException {

		request.setAttribute("dashboardAnalytics", dashboardDAO.getDashboardAnalytics());
		request.setAttribute("dashboardRole", role);
		request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
	}

	private void downloadDashboardReport(HttpServletResponse response, String role) throws IOException {
		Map<String, Object> analytics = dashboardDAO.getDashboardAnalytics();
		byte[] pdf = createDashboardPdf(analytics, role);
		String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

		response.setContentType("application/pdf");
		response.setHeader("Content-Disposition", "attachment; filename=dashboard-report-" + date + ".pdf");
		response.setContentLength(pdf.length);
		response.getOutputStream().write(pdf);
	}

	@SuppressWarnings("unchecked")
	private byte[] createDashboardPdf(Map<String, Object> data, String role) throws IOException {
		List<Map<String, Object>> revenueRows = (List<Map<String, Object>>) data.get("revenueByAccommodation");
		List<Map<String, Object>> stayRows = (List<Map<String, Object>>) data.get("stayLengthByAccommodation");
		long weekdays = number(data, "weekdayNights").longValue();
		long weekends = number(data, "weekendNights").longValue();
		long totalNights = weekdays + weekends;
		double weekdayPercent = totalNights == 0 ? 0 : weekdays * 100.0 / totalNights;
		double weekendPercent = totalNights == 0 ? 0 : weekends * 100.0 / totalNights;

		StringBuilder html = new StringBuilder();
		html.append("<!DOCTYPE html><html><head><meta charset='UTF-8'/><style>").append(
				"@page{size:A4;margin:22mm 18mm 18mm;}*{box-sizing:border-box}body{font-family:Arial,sans-serif;color:#20352f;margin:0;font-size:10px}")
				.append(".hero{background:#073e31;color:white;padding:28px;border-radius:14px;margin-bottom:18px}.brand{font-size:10px;letter-spacing:2px;text-transform:uppercase;color:#bcd7ce}.hero h1{font-size:27px;margin:8px 0 6px}.hero p{margin:0;color:#d8e7e2}")
				.append(".section-title{font-size:16px;color:#073e31;margin:22px 0 10px;border-bottom:2px solid #d5a64c;padding-bottom:7px}.metrics{width:100%;border-spacing:8px;border-collapse:separate;margin:-8px}.metric{width:25%;background:#f4f7f5;border:1px solid #dce7e2;border-radius:9px;padding:13px;vertical-align:top}.label{font-size:8px;color:#6d7975;text-transform:uppercase;letter-spacing:.7px}.value{font-size:18px;font-weight:bold;color:#073e31;margin-top:6px}.note{font-size:8px;color:#8b918f;margin-top:3px}")
				.append(".ranking{width:100%;border-collapse:collapse}.ranking th{background:#073e31;color:white;text-align:left;padding:9px}.ranking td{padding:9px;border-bottom:1px solid #e5e9e7}.rank{width:34px;color:#b18435;font-weight:bold}.number{text-align:right;font-weight:bold}.bar-bg{height:6px;background:#e7eeeb;border-radius:4px;margin-top:5px}.bar{height:6px;background:#1b7057;border-radius:4px}")
				.append(".day-table{width:100%;border-spacing:12px;border-collapse:separate;margin:-12px}.day-card{width:50%;padding:17px;border-radius:10px;background:#f4f7f5;border-left:5px solid #17634d}.day-card.weekend{border-left-color:#d5a64c}.day-value{font-size:25px;font-weight:bold;color:#073e31}.share{height:18px;background:#e8eeeb;border-radius:9px;overflow:hidden;margin-top:12px}.weekday-share{height:18px;background:#17634d;float:left}.weekend-share{height:18px;background:#d5a64c;float:left}")
				.append(".footer{margin-top:26px;padding-top:9px;border-top:1px solid #dce3df;color:#7b8581;font-size:8px;text-align:center}tr{page-break-inside:avoid}")
				.append("</style></head><body>")
				.append("<div class='hero'><div class='brand'>Cuti Murah Melaka</div><h1>").append(escapeHtml(role))
				.append(" Dashboard Report</h1><p>Generated on ")
				.append(LocalDateTime.now()
						.format(DateTimeFormatter.ofPattern("dd MMMM yyyy, hh:mm a", Locale.ENGLISH)))
				.append("</p></div><h2 class='section-title'>Performance Overview</h2>")
				.append("<table class='metrics'><tr>")
				.append(metric("Total Bookings", number(data, "totalBookings").intValue(), "All recorded bookings"))
				.append(metric("Total Revenue", "RM " + money(number(data, "totalRevenue").doubleValue()),
						"Paid payments"))
				.append(metric("Cancelled", number(data, "totalCancelled").intValue(), "Cancelled bookings"))
				.append(metric("Active Customers", number(data, "activeCustomers").intValue(), "Active guest accounts"))
				.append("</tr><tr>")
				.append(metric("Active Staff", number(data, "activeStaff").intValue(), "Active staff accounts"))
				.append(metric("Upcoming Stays", number(data, "upcomingStays").intValue(), "Future and current stays"))
				.append(metric("Average Booking", "RM " + money(number(data, "averageBookingAmount").doubleValue()),
						"Excluding cancellations"))
				.append(metric("Average Stay",
						String.format(Locale.US, "%.1f nights", number(data, "averageBookedDays").doubleValue()),
						"Nights per booking"))
				.append("</tr></table><h2 class='section-title'>Top 5 Highest Average Revenue</h2>")
				.append(rankingTable(revenueRows, true))
				.append("<h2 class='section-title'>Top 5 Longest Average Booked Days</h2>")
				.append(rankingTable(stayRows, false))
				.append("<h2 class='section-title'>Weekday vs Weekend</h2><table class='day-table'><tr><td class='day-card'><div class='label'>Weekday Nights</div><div class='day-value'>")
				.append(weekdays).append("</div><div>").append(String.format(Locale.US, "%.1f%%", weekdayPercent))
				.append(" of booked nights</div></td><td class='day-card weekend'><div class='label'>Weekend Nights</div><div class='day-value'>")
				.append(weekends).append("</div><div>").append(String.format(Locale.US, "%.1f%%", weekendPercent))
				.append(" of booked nights</div></td></tr></table><div class='share'><div class='weekday-share' style='width:")
				.append(String.format(Locale.US, "%.2f", weekdayPercent))
				.append("%'></div><div class='weekend-share' style='width:")
				.append(String.format(Locale.US, "%.2f", weekendPercent)).append("%'></div></div>")
				.append("<div class='footer'>Confidential management report | Cuti Murah Melaka</div></body></html>");

		try (ByteArrayOutputStream output = new ByteArrayOutputStream()) {
			PdfRendererBuilder builder = new PdfRendererBuilder();
			builder.useFastMode();
			builder.withHtmlContent(html.toString(), null);
			builder.toStream(output);
			builder.run();
			return output.toByteArray();
		}
	}

	private Number number(Map<String, Object> data, String key) {
		Object value = data.get(key);
		return value instanceof Number ? (Number) value : 0;
	}

	private String money(double value) {
		return String.format(Locale.US, "%,.2f", value);
	}

	private String metric(String label, Object value, String note) {
		return "<td class='metric'><div class='label'>" + escapeHtml(label) + "</div><div class='value'>"
				+ escapeHtml(String.valueOf(value)) + "</div><div class='note'>" + escapeHtml(note) + "</div></td>";
	}

	private String rankingTable(List<Map<String, Object>> rows, boolean currency) {
		StringBuilder table = new StringBuilder(
				"<table class='ranking'><tr><th>#</th><th>Accommodation</th><th style='text-align:right'>Average</th></tr>");
		if (rows == null || rows.isEmpty()) {
			return table.append("<tr><td colspan='3'>No data available.</td></tr></table>").toString();
		}
		double max = rows.stream().mapToDouble(row -> ((Number) row.get("value")).doubleValue()).max().orElse(1);
		int rank = 1;
		for (Map<String, Object> row : rows) {
			double value = ((Number) row.get("value")).doubleValue();
			double width = max <= 0 ? 0 : value * 100 / max;
			table.append("<tr><td class='rank'>").append(rank++).append("</td><td>")
					.append(escapeHtml(String.valueOf(row.get("label"))))
					.append("<div class='bar-bg'><div class='bar' style='width:")
					.append(String.format(Locale.US, "%.2f", width)).append("%'></div></div></td><td class='number'>")
					.append(currency ? "RM " + money(value) : String.format(Locale.US, "%.2f nights", value))
					.append("</td></tr>");
		}
		return table.append("</table>").toString();
	}

	private String escapeHtml(String value) {
		if (value == null)
			return "";
		return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;")
				.replace("'", "&#39;");
	}

	private boolean isBlank(String value) {
		return value == null || value.trim().isEmpty();
	}

	private void redirectUnauthorized(HttpServletRequest request, HttpServletResponse response) throws IOException {

		response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
	}
}
