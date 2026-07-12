<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %>
<%@ page import="model.Guest" %>

<%
    List<Staff> staffList =
            (List<Staff>) request.getAttribute("staffList");

    List<Guest> guestList =
            (List<Guest>) request.getAttribute("guestList");

    List<Staff> archivedStaffList =
            (List<Staff>) request.getAttribute("archivedStaffList");

    List<Guest> archivedGuestList =
            (List<Guest>) request.getAttribute("archivedGuestList");

    Integer archivedStaffCount =
            (Integer) request.getAttribute("archivedStaffCount");

    Integer archivedGuestCount =
            (Integer) request.getAttribute("archivedGuestCount");

    int activeStaffCount =
            staffList == null ? 0 : staffList.size();

    int activeGuestCount =
            guestList == null ? 0 : guestList.size();

    int inactiveStaffCount =
            archivedStaffCount == null ? 0 : archivedStaffCount;

    int inactiveGuestCount =
            archivedGuestCount == null ? 0 : archivedGuestCount;

    String successMessage =
            (String) session.getAttribute("successMessage");

    String errorMessage =
            (String) session.getAttribute("errorMessage");

    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>Owner Dashboard | Cuti Murah Melaka</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        .dashboard-page {
            max-width: 1240px;
            margin: 0;
        }

        .dashboard-heading {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 30px;
        }

        .dashboard-heading h1 {
            margin: 0 0 8px;
            color: #123a30;
            font-size: 38px;
        }

        .dashboard-heading p {
            margin: 0;
            color: #77716b;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 34px;
        }

        .summary-card {
            position: relative;
            overflow: hidden;
            padding: 24px;
            background: #ffffff;
            border: 1px solid #e4dcd2;
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(15, 45, 36, 0.05);
        }

        .summary-card::after {
            content: "";
            position: absolute;
            top: -30px;
            right: -30px;
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: rgba(0, 61, 47, 0.07);
        }

        .summary-label {
            display: block;
            margin-bottom: 12px;
            color: #6e7772;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.10em;
            text-transform: uppercase;
        }

        .summary-value {
            display: block;
            color: #123a30;
            font-size: 36px;
            font-weight: 800;
            line-height: 1;
        }

        .summary-note {
            display: block;
            margin-top: 10px;
            color: #8a847d;
            font-size: 13px;
        }

        .archive-card .summary-value {
            color: #8b5d2e;
        }

        .message {
            margin-bottom: 24px;
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

        .dashboard-section {
            margin-bottom: 32px;
            overflow: hidden;
            background: #ffffff;
            border: 1px solid #e4dcd2;
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(15, 45, 36, 0.05);
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            padding: 22px 25px;
            border-bottom: 1px solid #e6ded4;
        }

        .section-header h2 {
            margin: 0 0 5px;
            color: #123a30;
            font-size: 25px;
        }

        .section-header p {
            margin: 0;
            color: #7b756f;
            font-size: 14px;
        }

        .count-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 42px;
            height: 34px;
            padding: 0 12px;
            border-radius: 999px;
            background: #edf4f1;
            color: #174b3c;
            font-weight: 800;
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .dashboard-table {
            width: 100%;
            min-width: 760px;
            border-collapse: collapse;
        }

        .dashboard-table th,
        .dashboard-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #ece5dc;
            text-align: left;
            vertical-align: middle;
        }

        .dashboard-table th {
            background: #f4f0ea;
            color: #2c3d37;
            font-size: 13px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .dashboard-table tr:last-child td {
            border-bottom: 0;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 82px;
            min-height: 30px;
            padding: 0 11px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.07em;
            text-transform: uppercase;
        }

        .status-active {
            color: #17633a;
            background: #eaf7ef;
            border: 1px solid #b8dfc7;
        }

        .status-inactive {
            color: #8b5d2e;
            background: #fff4e7;
            border: 1px solid #efd1a8;
        }

        .empty-state {
            padding: 32px 20px !important;
            color: #807a73;
            text-align: center !important;
            font-style: italic;
        }

        .dashboard-link {
            color: #0c5a45;
            font-weight: 700;
            text-decoration: none;
        }

        @media (max-width: 980px) {
            .summary-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 620px) {
            .dashboard-heading,
            .section-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .dashboard-page {
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

            <div class="container dashboard-page">

                <div class="dashboard-heading">

                    <div>
                        <h1>Owner Dashboard</h1>
                        <p>
                            Monitor active and archived user accounts.
                        </p>
                    </div>

                </div>

                <% if (successMessage != null) { %>
                    <div class="message message-success">
                        <%= successMessage %>
                    </div>
                <% } %>

                <% if (errorMessage != null) { %>
                    <div class="message message-error">
                        <%= errorMessage %>
                    </div>
                <% } %>

                <section class="summary-grid">

                    <article class="summary-card">
                        <span class="summary-label">Active Staff</span>
                        <span class="summary-value"><%= activeStaffCount %></span>
                        <span class="summary-note">Currently usable staff accounts</span>
                    </article>

                    <article class="summary-card">
                        <span class="summary-label">Active Guests</span>
                        <span class="summary-value"><%= activeGuestCount %></span>
                        <span class="summary-note">Currently usable guest accounts</span>
                    </article>

                    <article class="summary-card archive-card">
                        <span class="summary-label">Archived Staff</span>
                        <span class="summary-value"><%= inactiveStaffCount %></span>
                        <span class="summary-note">Staff accounts marked inactive</span>
                    </article>

                    <article class="summary-card archive-card">
                        <span class="summary-label">Archived Guests</span>
                        <span class="summary-value"><%= inactiveGuestCount %></span>
                        <span class="summary-note">Guest accounts marked inactive</span>
                    </article>

                </section>

</body>
</html>