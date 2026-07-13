<%@ page import="java.util.List" %>
<%@ page import="model.Accommodation" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Accommodation> accommodationList =
            (List<Accommodation>) request.getAttribute("accommodationList");

    String errorMessage =
            (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>View Accommodation | Staff</title>

    <link rel="stylesheet"
          type="text/css"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          type="text/css"
          href="${pageContext.request.contextPath}/css/theme.css">
</head>

<body class="admin-body">
    <style>.accom-success-modal{position:fixed;z-index:3000;inset:0;display:flex;align-items:center;justify-content:center;padding:24px;background:rgba(8,28,22,.62)}.accom-success-card{width:min(420px,100%);padding:34px;border-radius:18px;background:#fff;text-align:center;box-shadow:0 24px 70px rgba(0,0,0,.22)}.accom-success-icon{display:flex;align-items:center;justify-content:center;width:62px;height:62px;margin:0 auto 18px;border-radius:50%;background:#eaf7ef;color:#17633a;font-size:28px;font-weight:bold}.accom-success-card h2{margin:0 0 9px;color:#123a30}.accom-success-card p{margin:0 0 22px;color:#746f69}</style>

    <!-- Staff top navigation -->
    <jsp:include page="StaffNavbar.jsp" />

    <div class="admin-layout">

        <!-- Staff sidebar -->
        <jsp:include page="StaffSidebar.jsp" />

        <main class="main-content">

            <div class="container"
                 style="max-width: 1200px; margin: 0;">

                <!-- Page title -->
                <div class="page-header"
                     style="margin-bottom: 30px; text-align: left;">

                    <h1>Accommodation List</h1>

                    <p class="text-muted">
                        View all accommodation records available at
                        Cuti Murah Melaka.
                    </p>

                </div>

                <!-- Error message -->
                <% if (errorMessage != null) { %>

                    <div style="
                        padding: 15px 20px;
                        margin-bottom: 25px;
                        background-color: #fee2e2;
                        color: #991b1b;
                        border: 1px solid #fecaca;
                        border-radius: 8px;
                        font-size: 14px;
                    ">
                        <%= errorMessage %>
                    </div>

                <% } %>

                <!-- Accommodation table card -->
                <div class="table-card">

                    <div class="table-header"
                         style="
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                         ">

                        <div>
                            <h3 style="margin: 0;">
                                Available Accommodations
                            </h3>

                            <p class="text-muted"
                               style="margin: 5px 0 0;">
                                Staff members can only view accommodation
                                information.
                            </p>
                        </div>

                        <span style="
                            font-size: 0.85rem;
                            color: var(--text-muted);
                            font-weight: 600;
                            white-space: nowrap;
                        ">
                            Total:
                            <%= accommodationList == null
                                    ? 0
                                    : accommodationList.size() %>
                        </span>

                    </div>

                    <div class="table-responsive">

                        <table class="data-table">

                            <thead>
                                <tr>
                                    <th>Accommodation ID</th>
                                    <th>Name</th>
                                    <th>Type</th>
                                    <th>Location</th>
                                    <th>Price Per Night</th>
                                    <th>Maximum Capacity</th>
                                    <th>Description</th>
                                    <th>Access</th>
                                </tr>
                            </thead>

                            <tbody>

                                <% if (accommodationList == null
                                        || accommodationList.isEmpty()) { %>

                                    <tr>
                                        <td colspan="8"
                                            style="
                                                padding: 30px;
                                                text-align: center;
                                                color: var(--text-muted);
                                            ">
                                            No accommodation records found.
                                        </td>
                                    </tr>

                                <% } else {

                                    for (Accommodation accommodation
                                            : accommodationList) {
                                %>

                                    <tr>

                                        <td class="font-medium">
                                            <%= accommodation
                                                    .getAccommodationId() %>
                                        </td>

                                        <td>
                                            <%= accommodation
                                                    .getAccommodationName() %>
                                        </td>

                                        <td>
                                            <span class="badge badge-none">
                                                <%= accommodation
                                                        .getAccommodationType() %>
                                            </span>
                                        </td>

                                        <td>
                                            <%= accommodation.getLocation() %>
                                        </td>

                                        <td class="font-medium">
                                            RM
                                            <%= String.format(
                                                    "%.2f",
                                                    accommodation
                                                        .getPricePerNight()
                                                ) %>
                                        </td>

                                        <td>
                                            <%= accommodation
                                                    .getMaxCapacity() %>
                                            pax
                                        </td>

                                        <td>
                                            <%
                                                String description =
                                                        accommodation
                                                            .getDescription();

                                                if (description == null
                                                        || description
                                                            .trim()
                                                            .isEmpty()) {
                                            %>

                                                <span class="text-muted italic">
                                                    No description
                                                </span>

                                            <% } else { %>

                                                <%= description %>

                                            <% } %>
                                        </td>

                                        <td>
    <div style="display: flex; gap: 8px; flex-wrap: wrap;">

        <a href="${pageContext.request.contextPath}/UpdateAccommodationServlet?accommodationId=<%= accommodation.getAccommodationId() %>"
       class="btn-edit">
        Edit
    </a>
<a href="${pageContext.request.contextPath}/UpdateAvailabilityServlet?accommodationID=<%= accommodation.getAccommodationId() %>"
   class="btn-date">
    Date
</a>
    </div>
</td>
                                    </tr>

                                <%
                                    }
                                }
                                %>

                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

        </main>

    </div>

    <% if ("updated".equals(request.getParameter("success"))) { %>
    <div class="accom-success-modal"><div class="accom-success-card"><div class="accom-success-icon">✓</div><h2>Accommodation Updated Successfully</h2><p>The accommodation information has been saved.</p><a class="btn-primary" href="${pageContext.request.contextPath}/staff/accommodation" style="display:inline-flex;text-decoration:none;">Done</a></div></div>
    <% } %>

</body>
</html>
