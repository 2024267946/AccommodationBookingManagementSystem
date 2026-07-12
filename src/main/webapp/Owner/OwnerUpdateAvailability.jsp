<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String accommodationID =
            (String) request.getAttribute("accommodationID");

    if (accommodationID == null) {
        accommodationID = request.getParameter("accommodationID");
    }

    if (accommodationID == null) {
        accommodationID = "";
    }

    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Availability | Owner</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        .form-page {
            max-width: 1120px;
            margin: 0;
        }

        .form-card {
            background: #ffffff;
            border: 1px solid #e7dfd5;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.06);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px 26px;
        }

        .form-group {
            margin: 0;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 9px;
            font-weight: 600;
            color: #171717;
        }

        .form-control {
            width: 100%;
            box-sizing: border-box;
            padding: 14px 16px;
            border: 1px solid #d9d1c7;
            border-radius: 10px;
            background: #ffffff;
            font: inherit;
            color: #222222;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control:focus {
            border-color: #163f34;
            box-shadow: 0 0 0 4px rgba(22, 63, 52, 0.10);
        }

        textarea.form-control {
            min-height: 130px;
            resize: vertical;
        }

        .readonly-input {
            background: #f5f2ed;
            color: #555555;
        }

        .form-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 28px;
        }

        .page-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 48px;
            padding: 0 26px;
            border: 0;
            border-radius: 8px;
            font: inherit;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            text-decoration: none;
            cursor: pointer;
        }

        .page-btn-primary {
            background: #003d2f;
            color: #ffffff;
        }

        .page-btn-secondary {
            background: #eee9e1;
            color: #4d4a46;
        }

        .message {
            margin-bottom: 24px;
            padding: 16px 20px;
            border-radius: 10px;
            font-weight: 600;
        }

        .message-error {
            color: #a61b1b;
            background: #fff0f0;
            border: 1px solid #f3b7b7;
        }

        .message-success {
            color: #17633a;
            background: #eef9f2;
            border: 1px solid #b8dfc7;
        }

        @media (max-width: 800px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            .form-card {
                padding: 22px;
            }

            .page-btn {
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

        <div class="container form-page">

            <div class="page-header" style="text-align:left; margin-bottom:28px;">
                <h1>Update Availability</h1>
                <p class="text-muted">
                    Set the availability period and status for this accommodation.
                </p>
            </div>

            <% if ("true".equals(success)) { %>
                <div class="message message-success">
                    Availability successfully updated.
                </div>
            <% } %>

            <% if (error != null) { %>
                <div class="message message-error">
                    Failed to update availability. Please check your input.
                </div>
            <% } %>

            <div class="form-card">

                <form action="${pageContext.request.contextPath}/UpdateAvailabilityServlet"
                      method="post">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label for="accommodationID">Accommodation ID</label>
                            <input id="accommodationID"
                                   class="form-control readonly-input"
                                   type="text"
                                   value="<%= accommodationID %>"
                                   readonly>

                            <input type="hidden"
                                   name="accommodationID"
                                   value="<%= accommodationID %>">
                        </div>

                        <div class="form-group">
                            <label for="checkIn">Check-in Date</label>
                            <input id="checkIn"
                                   class="form-control"
                                   type="date"
                                   name="checkIn"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="checkOut">Check-out Date</label>
                            <input id="checkOut"
                                   class="form-control"
                                   type="date"
                                   name="checkOut"
                                   required>
                        </div>

                        <div class="form-group full-width">
                            <label for="status">Availability Status</label>
                            <select id="status"
                                    class="form-control"
                                    name="status"
                                    required>
                                <option value="">-- Select Status --</option>
                                <option value="Unavailable">Unavailable</option>
                                <option value="Available">Available</option>
                            </select>
                        </div>

                    </div>

                    <div class="form-actions">
                        <button type="submit"
                                class="page-btn page-btn-primary">
                            Update Availability
                        </button>

                        <a href="${pageContext.request.contextPath}/OwnerAccommodationListServlet"
                           class="page-btn page-btn-secondary">
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