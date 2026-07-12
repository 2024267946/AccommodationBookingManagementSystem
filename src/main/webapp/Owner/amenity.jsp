<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="model.Amenity" %>
<%@ page import="model.Accommodation" %>

<%
    List<Amenity> amenityList =
            (List<Amenity>) request.getAttribute("amenityList");

    List<Accommodation> accommodationList =
            (List<Accommodation>) request.getAttribute("accommodationList");

    String message =
            request.getParameter("message");

    String error =
            request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>Manage Amenities | Cuti Murah Melaka</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        .amenity-page {
            max-width: 1180px;
            margin: 0;
        }

        .system-header h1 {
            margin: 0;
            color: #102f29;
            font-size: 38px;
        }

        .module-tabs {
            display: flex;
            gap: 28px;
            margin: 12px 0 28px;
            border-bottom: 1px solid #ded7ce;
        }

        .module-tab {
            position: relative;
            padding-bottom: 14px;
            color: #697b75;
            font-size: 17px;
            font-weight: 600;
            text-decoration: none;
        }

        .module-tab.active {
            color: #003d2f;
        }

        .module-tab.active::after {
            content: "";
            position: absolute;
            right: 0;
            bottom: -1px;
            left: 0;
            height: 2px;
            background: #003d2f;
        }

        .amenity-layout {
            display: grid;
            grid-template-columns: minmax(280px, 0.8fr) minmax(0, 1.6fr);
            gap: 28px;
            align-items: start;
        }

        .panel-card {
            overflow: hidden;
            background: #ffffff;
            border: 1px solid #e5ddd3;
            border-radius: 15px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
        }

        .panel-header {
            padding: 24px 26px;
            border-bottom: 1px solid #e5ddd3;
        }

        .panel-header h2 {
            margin: 0;
            color: #102f29;
            font-size: 25px;
        }

        .create-panel-body {
            padding: 25px 26px 28px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 9px;
            color: #171717;
            font-weight: 600;
        }

        .amenity-input {
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
            padding: 13px 15px;
            border: 1px solid #d9d1c7;
            border-radius: 9px;
            background: #ffffff;
            color: #222222;
            font: inherit;
            outline: none;
        }

        .amenity-input:focus {
            border-color: #164c3d;
            box-shadow: 0 0 0 4px rgba(22, 76, 61, 0.10);
        }

        .primary-action,
        .update-action,
        .archive-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-sizing: border-box;
            min-height: 43px;
            padding: 0 17px;
            border-radius: 8px;
            font: inherit;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-decoration: none;
            text-transform: uppercase;
            cursor: pointer;
        }

        .primary-action {
            width: 100%;
            border: 0;
            background: #003d2f;
            color: #ffffff;
        }

        .update-action {
            flex: 0 0 auto;
            border: 0;
            background: #003d2f;
            color: #ffffff;
        }

        .archive-action {
            background: #fff0f0;
            color: #a12626;
            border: 1px solid #efc0c0;
        }

        .message {
            margin-bottom: 22px;
            padding: 15px 18px;
            border-radius: 10px;
            font-weight: 600;
        }

        .message-success {
            color: #17633a;
            background: #eef9f2;
            border: 1px solid #b8dfc7;
        }

        .message-error {
            color: #a61b1b;
            background: #fff0f0;
            border: 1px solid #f3b7b7;
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .amenity-table {
            width: 100%;
            min-width: 620px;
            border-collapse: collapse;
        }

        .amenity-table th,
        .amenity-table td {
            padding: 17px 19px;
            border-bottom: 1px solid #e5ddd3;
            vertical-align: middle;
        }

        .amenity-table th {
            background: #f1ede7;
            color: #121212;
            text-align: left;
            font-size: 14px;
        }

        .amenity-table th:first-child,
        .amenity-table td:first-child {
            width: 75px;
        }

        .amenity-table th:last-child,
        .amenity-table td:last-child {
            width: 125px;
            text-align: center;
        }

        .amenity-update-form {
            display: flex;
            align-items: center;
            gap: 11px;
            width: 100%;
            margin: 0;
        }

        .amenity-update-form .amenity-input {
            flex: 1;
            min-width: 0;
        }

        .empty-state {
            padding: 35px 20px !important;
            color: #77716b;
            text-align: center;
            font-style: italic;
        }

        @media (max-width: 900px) {
            .amenity-layout {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 650px) {
            .system-header h1 {
                font-size: 31px;
            }

            .amenity-update-form {
                align-items: stretch;
                flex-direction: column;
            }

            .update-action {
                width: 100%;
            }
        }
    </style>
</head>

<body class="admin-body">

    <jsp:include page="ownerNavbar.jsp" />

    <div class="admin-layout">

        <jsp:include page="sidebar.jsp" />

        <main class="main-content">

            <div class="container amenity-page">

                <div class="system-header">
                    <h1>Accommodation Systems</h1>
                </div>

                <div class="module-tabs">

                    <a href="${pageContext.request.contextPath}/OwnerAccommodationListServlet"
                       class="module-tab">
                        Accommodation
                    </a>

                    <a href="${pageContext.request.contextPath}/amenity"
                       class="module-tab active">
                        Amenity
                    </a>

                </div>

                <% if ("createSuccess".equals(message)) { %>
                    <div class="message message-success">
                        Amenity successfully added to the selected accommodation.
                    </div>
                <% } else if ("updateSuccess".equals(message)) { %>
                    <div class="message message-success">
                        Amenity successfully updated.
                    </div>
                <% } else if ("archiveSuccess".equals(message)) { %>
                    <div class="message message-success">
                        Amenity successfully archived.
                    </div>
                <% } %>

                <% if (error != null) { %>
                    <div class="message message-error">
                        The amenity operation could not be completed.
                    </div>
                <% } %>

                <div class="amenity-layout">

                    <section class="panel-card">

                        <div class="panel-header">
                            <h2>Add New Amenity</h2>
                        </div>

                        <div class="create-panel-body">

                            <form action="${pageContext.request.contextPath}/amenity/create"
                                  method="post">

                                <div class="form-group">

                                    <label for="amenityName">
                                        Amenity Name
                                    </label>

                                    <input id="amenityName"
                                           type="text"
                                           name="amenityName"
                                           class="amenity-input"
                                           placeholder="Example: Wi-Fi"
                                           required>

                                </div>

                                <div class="form-group">

                                    <label for="accommodationId">
                                        Accommodation
                                    </label>

                                    <select id="accommodationId"
                                            name="accommodationId"
                                            class="amenity-input"
                                            required>

                                        <option value="">
                                            Select Accommodation
                                        </option>

                                        <%
                                            if (accommodationList != null) {

                                                for (Accommodation accommodation
                                                        : accommodationList) {
                                        %>

                                            <option value="<%= accommodation.getAccommodationId() %>">
                                                <%= accommodation.getAccommodationId() %>
                                                -
                                                <%= accommodation.getAccommodationName() %>
                                            </option>

                                        <%
                                                }
                                            }
                                        %>

                                    </select>

                                </div>

                                <button type="submit"
                                        class="primary-action">
                                    Save Amenity
                                </button>

                            </form>

                        </div>

                    </section>

                    <section class="panel-card">

                        <div class="panel-header">
                            <h2>Active System Amenities</h2>
                        </div>

                        <div class="table-responsive">

                            <table class="amenity-table">

                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Amenity Name</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <%
                                        if (amenityList != null
                                                && !amenityList.isEmpty()) {

                                            for (Amenity amenity : amenityList) {
                                    %>

                                        <tr>

                                            <td>
                                                <strong>
                                                    #<%= amenity.getAmenityId() %>
                                                </strong>
                                            </td>

                                            <td>

                                                <form action="${pageContext.request.contextPath}/amenity/update"
                                                      method="post"
                                                      class="amenity-update-form">

                                                    <input type="hidden"
                                                           name="amenityId"
                                                           value="<%= amenity.getAmenityId() %>">

                                                    <input type="text"
                                                           name="amenityName"
                                                           class="amenity-input"
                                                           value="<%= amenity.getAmenityName() %>"
                                                           required>

                                                    <button type="submit"
                                                            class="update-action">
                                                        Update
                                                    </button>

                                                </form>

                                            </td>

                                            <td>

                                                <a href="${pageContext.request.contextPath}/amenity/archive?id=<%= amenity.getAmenityId() %>"
                                                   class="archive-action">
                                                    Archive
                                                </a>

                                            </td>

                                        </tr>

                                    <%
                                            }

                                        } else {
                                    %>

                                        <tr>
                                            <td colspan="3"
                                                class="empty-state">
                                                No active amenities found.
                                            </td>
                                        </tr>

                                    <%
                                        }
                                    %>

                                </tbody>

                            </table>

                        </div>

                    </section>

                </div>

            </div>

        </main>

    </div>

</body>
</html>