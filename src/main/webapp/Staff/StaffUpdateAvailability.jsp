<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String accommodationID = (String) request.getAttribute("accommodationID");

    if (accommodationID == null) {
        accommodationID = request.getParameter("accommodationID");
    }

    if (accommodationID == null || accommodationID.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/staff/accommodation");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Availability | Staff</title>

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

        .form-control[readonly] {
            background: #f5f5f5;
            color: #666;
            cursor: not-allowed;
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

        .message {
            padding: 14px 18px;
            margin-bottom: 22px;
            border-radius: 8px;
            font-weight: 500;
        }

        .message-success {
            background: #e8f5e9;
            color: #2e6b32;
            border: 1px solid #c8e6c9;
        }

        .message-error {
            background: #fdecec;
            color: #9b2c2c;
            border: 1px solid #f5c2c2;
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

                    <h1>Update Availability</h1>

                    <p class="text-muted">
                        Update the availability period and status for this accommodation.
                    </p>
                </div>

                <% if ("true".equals(request.getParameter("success"))) { %>
                    <div class="message message-success">
                        Availability successfully updated.
                    </div>
                <% } %>

                <% if (request.getParameter("error") != null) { %>
                    <div class="message message-error">
                        Failed to update availability. Please check your input.
                    </div>
                <% } %>

                <div class="table-card form-card">

                    <form action="${pageContext.request.contextPath}/UpdateAvailabilityServlet"
                          method="post">

                        <input type="hidden"
                               name="accommodationID"
                               value="<%= accommodationID %>">

                        <div class="form-grid">

                            <div class="form-group full-width">
                                <label class="form-label">Accommodation ID</label>

                                <input type="text"
                                       class="form-control"
                                       value="<%= accommodationID %>"
                                       readonly>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Check-in Date</label>

                                <input type="date"
                                       class="form-control"
                                       name="checkIn"
                                       required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Check-out Date</label>

                                <input type="date"
                                       class="form-control"
                                       name="checkOut"
                                       required>
                            </div>

                            <div class="form-group full-width">
                                <label class="form-label">Availability Status</label>

                                <select name="status"
                                        class="form-control"
                                        required>
                                    <option value="">-- Select Status --</option>
                                    <option value="Unavailable">Unavailable</option>
                                    <option value="Available">Available</option>
                                </select>
                            </div>
                        </div>

                        <div class="button-group">

                            <button type="submit"
                                    class="btn-primary"
                                    style="padding: 12px 24px; border-radius: 8px;">
                                Update Availability
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
