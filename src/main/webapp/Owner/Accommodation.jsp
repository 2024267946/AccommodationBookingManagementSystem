<%@ page import="java.util.List" %>
<%@ page import="model.Accommodation" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Accommodation> accommodationList =
        (List<Accommodation>) request.getAttribute("accommodationList");

    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accommodation Management | Owner</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        .accommodation-page {
            max-width: 1180px;
            margin: 0;
        }

        .accommodation-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-bottom: 26px;
        }

        .accommodation-toolbar h1 {
            margin: 0 0 6px;
        }

        .toolbar-text {
            margin: 0;
            color: #77716b;
        }

        .btn-create,
        .btn-edit,
        .btn-date,
        .btn-archive {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 0 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            font-size: 13px;
            letter-spacing: 0.04em;
            white-space: nowrap;
        }

        .btn-create {
            background: #003d2f;
            color: #ffffff;
            min-height: 48px;
            padding: 0 22px;
        }

        .btn-edit {
            background: #0f5c49;
            color: #ffffff;
        }

        .btn-date {
            background: #e8f0ec;
            color: #174a3c;
            border: 1px solid #c9ddd5;
        }

        .btn-archive {
            background: #fff1f1;
            color: #a52626;
            border: 1px solid #efc4c4;
        }

        .summary-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            padding: 16px 20px;
            margin-bottom: 22px;
            background: #ffffff;
            border: 1px solid #e6ded4;
            border-radius: 12px;
        }

        .summary-bar strong {
            color: #173f34;
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

        .accommodation-list {
            display: grid;
            gap: 20px;
        }

        .accommodation-card {
            display: grid;
            grid-template-columns: 220px minmax(0, 1fr) auto;
            gap: 24px;
            align-items: center;
            padding: 22px;
            background: #ffffff;
            border: 1px solid #e6ded4;
            border-radius: 16px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
        }

        .image-box {
            width: 100%;
            height: 155px;
            overflow: hidden;
            border-radius: 12px;
            background: #eee9e1;
        }

        .image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .accommodation-info h3 {
            margin: 0 0 10px;
            font-size: 22px;
            color: #1b1b1b;
        }

        .description {
            margin: 0 0 16px;
            color: #6d6964;
            line-height: 1.65;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 10px 18px;
        }

        .detail-item {
            padding: 10px 12px;
            background: #f8f5f0;
            border-radius: 8px;
            color: #5e5a55;
            font-size: 14px;
        }

        .detail-item strong {
            color: #222222;
        }

        .price {
            color: #0b624b !important;
        }

        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-width: 120px;
        }

        .empty-card {
            padding: 44px 24px;
            text-align: center;
            color: #77716b;
            background: #ffffff;
            border: 1px dashed #d8cec2;
            border-radius: 14px;
        }


        .system-header {
            margin-bottom: 0;
        }

        .system-header h1 {
            margin: 0;
            color: #102f29;
            font-size: 38px;
            line-height: 1.2;
        }

        .module-tabs {
            display: flex;
            align-items: center;
            gap: 28px;
            margin: 12px 0 28px;
            border-bottom: 1px solid #ded7ce;
        }

        .module-tab {
            position: relative;
            padding: 0 0 14px;
            color: #697b75;
            font-size: 17px;
            font-weight: 600;
            text-decoration: none;
        }

        .module-tab:hover {
            color: #003d2f;
        }

        .module-tab.active {
            color: #003d2f;
        }

        .module-tab.active::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: -1px;
            height: 2px;
            background: #003d2f;
        }

        @media (max-width: 980px) {
            .accommodation-card {
                grid-template-columns: 180px minmax(0, 1fr);
            }

            .action-buttons {
                grid-column: 1 / -1;
                flex-direction: row;
                flex-wrap: wrap;
            }
        }

        @media (max-width: 700px) {
            .accommodation-toolbar {
                align-items: stretch;
                flex-direction: column;
            }

            .btn-create {
                width: 100%;
            }

            .summary-bar {
                align-items: flex-start;
                flex-direction: column;
            }

            .accommodation-card {
                grid-template-columns: 1fr;
            }

            .image-box {
                height: 210px;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                grid-column: auto;
                flex-direction: column;
            }

            .btn-edit,
            .btn-date,
            .btn-archive {
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

            <div class="container accommodation-page">

                <div class="system-header">
                    <h1>Accommodation Systems</h1>
                </div>

                <div class="module-tabs">

                    <a href="${pageContext.request.contextPath}/OwnerAccommodationListServlet"
                       class="module-tab active">
                        Accommodation
                    </a>

                    <a href="${pageContext.request.contextPath}/Owner/amenity.jsp"
                       class="module-tab">
                        Amenity
                    </a>

                </div>

                <div class="accommodation-toolbar">

                    <div>
                        <h2 style="margin:0 0 6px;">Accommodation Management</h2>
                        <p class="toolbar-text">
                            Create, edit and update accommodation records.
                        </p>
                    </div>

                    <a href="${pageContext.request.contextPath}/Owner/CreateAccommodation.jsp"
                       class="btn-create">
                        Create Accommodation
                    </a>

                </div>

                <% if ("updateSuccess".equals(message)) { %>
                    <div class="message message-success">
                        Accommodation successfully updated.
                    </div>
                <% } else if ("availabilityUpdateSuccess".equals(message)) { %>
                    <div class="message message-success">
                        Availability successfully updated.
                    </div>
                <% } %>

                <% if (error != null) { %>
                    <div class="message message-error">
                        The requested operation could not be completed.
                    </div>
                <% } %>

                <div class="summary-bar">
                    <span>
                        Accommodation records available in the system
                    </span>

                    <strong>
                        Total:
                        <%= accommodationList == null
                                ? 0
                                : accommodationList.size() %>
                    </strong>
                </div>

                <div class="accommodation-list">

                    <%
                        if (accommodationList != null
                                && !accommodationList.isEmpty()) {

                            for (Accommodation acc : accommodationList) {
                    %>

                    <div class="accommodation-card">

                        <div class="image-box">
                            <img src="${pageContext.request.contextPath}/images/chalet1.png"
                                 alt="Accommodation image">
                        </div>

                        <div class="accommodation-info">

                            <h3><%= acc.getAccommodationName() %></h3>

                            <p class="description">
                                <%
                                    String description = acc.getDescription();

                                    if (description == null
                                            || description.trim().isEmpty()) {
                                %>
                                    No description is available for this accommodation.
                                <% } else { %>
                                    <%= description %>
                                <% } %>
                            </p>

                            <div class="details-grid">

                                <div class="detail-item">
                                    ID:
                                    <strong><%= acc.getAccommodationId() %></strong>
                                </div>

                                <div class="detail-item">
                                    Type:
                                    <strong><%= acc.getAccommodationType() %></strong>
                                </div>

                                <div class="detail-item">
                                    Location:
                                    <strong><%= acc.getLocation() %></strong>
                                </div>

                                <div class="detail-item">
                                    Capacity:
                                    <strong><%= acc.getMaxCapacity() %> Pax</strong>
                                </div>

                                <div class="detail-item">
                                    Price:
                                    <strong class="price">
                                        RM <%= String.format(
                                                "%.2f",
                                                acc.getPricePerNight()) %> / night
                                    </strong>
                                </div>

                            </div>

                        </div>

                        <div class="action-buttons">

                            <a href="${pageContext.request.contextPath}/UpdateAccommodationServlet?accommodationId=<%= acc.getAccommodationId() %>"
                               class="btn-edit">
                                Edit
                            </a>

                            <a href="${pageContext.request.contextPath}/UpdateAvailabilityServlet?accommodationID=<%= acc.getAccommodationId() %>"
                               class="btn-date">
                                Availability
                            </a>


                        </div>

                    </div>

                    <%
                            }

                        } else {
                    %>

                    <div class="empty-card">
                        No accommodation records were found in the database.
                    </div>

                    <%
                        }
                    %>

                </div>

            </div>

        </main>

    </div>

</body>
</html>