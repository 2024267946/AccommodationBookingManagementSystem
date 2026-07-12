<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="model.Accommodation" %>

<%
    Accommodation accommodation =
            (Accommodation) request.getAttribute("accommodation");

    if (accommodation == null) {
        response.sendRedirect(
                request.getContextPath() + "/staff/accommodation"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Accommodation | Staff</title>

    <link rel="stylesheet"
          type="text/css"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          type="text/css"
          href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        .form-card {
            padding: 35px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-sizing: border-box;
            font: inherit;
            background: #fff;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color, #7f9572);
            box-shadow: 0 0 0 3px rgba(127, 149, 114, 0.15);
        }

        textarea.form-control {
            min-height: 130px;
            resize: vertical;
        }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .btn-cancel {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            background: #f3f0e8;
            color: #555;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            .form-card {
                padding: 24px;
            }
        }
    </style>
</head>

<body class="admin-body">

    <jsp:include page="StaffNavbar.jsp" />

    <div class="admin-layout">

        <jsp:include page="StaffSidebar.jsp" />

        <main class="main-content">

            <div class="container" style="max-width: 900px; margin: 0;">

                <div class="page-header"
                     style="margin-bottom: 30px; text-align: left;">

                    <h1>Edit Accommodation</h1>

                    <p class="text-muted">
                        Update the accommodation details below.
                    </p>
                </div>

                <div class="table-card form-card">

                    <form action="${pageContext.request.contextPath}/UpdateAccommodationServlet"
                          method="post">

                        <input type="hidden"
                               name="accommodationId"
                               value="<%= accommodation.getAccommodationId() %>">

                        <div class="form-grid">

                            <div class="form-group">
                                <label class="form-label">Accommodation ID</label>

                                <input type="text"
                                       class="form-control"
                                       value="<%= accommodation.getAccommodationId() %>"
                                       readonly>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Accommodation Name</label>

                                <input type="text"
                                       class="form-control"
                                       name="accommodationName"
                                       value="<%= accommodation.getAccommodationName() %>"
                                       required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Accommodation Type</label>

                                <select name="accommodationType"
                                        class="form-control"
                                        required>

                                    <option value="HOMESTAY"
                                        <%= "HOMESTAY".equalsIgnoreCase(
                                                accommodation.getAccommodationType())
                                                ? "selected" : "" %>>
                                        HOMESTAY
                                    </option>

                                    <option value="CHALET"
                                        <%= "CHALET".equalsIgnoreCase(
                                                accommodation.getAccommodationType())
                                                ? "selected" : "" %>>
                                        CHALET
                                    </option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Location</label>

                                <input type="text"
                                       class="form-control"
                                       name="location"
                                       value="<%= accommodation.getLocation() %>"
                                       required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Price Per Night (RM)</label>

                                <input type="number"
                                       class="form-control"
                                       name="pricePerNight"
                                       step="0.01"
                                       min="0"
                                       value="<%= accommodation.getPricePerNight() %>"
                                       required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Maximum Capacity</label>

                                <input type="number"
                                       class="form-control"
                                       name="maxCapacity"
                                       min="1"
                                       value="<%= accommodation.getMaxCapacity() %>"
                                       required>
                            </div>

                            <div class="form-group full-width">
                                <label class="form-label">Description</label>

                                <textarea name="description"
                                          class="form-control"
                                          required><%= accommodation.getDescription() == null
                                                  ? ""
                                                  : accommodation.getDescription() %></textarea>
                            </div>
                        </div>

                        <div class="button-group">

                            <button type="submit"
                                    class="btn-primary"
                                    style="padding: 12px 24px; border-radius: 8px;">
                                Update Accommodation
                            </button>

                            <a href="${pageContext.request.contextPath}/staff/accommodation"
                               class="btn-cancel">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
