<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="model.Guest" %>

<%
    List<Guest> archivedGuestList =
            (List<Guest>) request.getAttribute("archivedGuestList");

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
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Archived Guest | Cuti Murah Melaka</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        .archived-page {
            width: 100%;
            max-width: 1240px;
            margin: 0;
        }

        .archived-card {
            overflow: hidden;
            background: #ffffff;
            border: 1px solid #e4dcd2;
            border-radius: 15px;
            box-shadow: 0 6px 18px rgba(15, 45, 36, 0.05);
        }

        .archived-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 26px 28px;
            border-bottom: 1px solid #e6ded4;
        }

        .archived-header h1 {
            margin: 0 0 8px;
            color: #123a30;
            font-size: 36px;
        }

        .archived-header p {
            margin: 0;
            color: #77716b;
            font-size: 15px;
        }

        .count-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 50px;
            height: 42px;
            padding: 0 16px;
            border-radius: 30px;
            color: #17483f;
            background: #edf3f1;
            font-size: 19px;
            font-weight: 800;
        }

        .message {
            margin: 20px 28px 0;
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

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .archived-table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
        }

        .archived-table thead {
            background: #f4f0ea;
        }

        .archived-table th {
            padding: 20px 25px;
            text-align: left;
            color: #173a34;
            font-size: 13px;
            font-weight: 800;
            letter-spacing: 0.08em;
            white-space: nowrap;
        }

        .archived-table td {
            padding: 20px 25px;
            color: #152724;
            font-size: 15px;
            vertical-align: middle;
            border-top: 1px solid #ebe5dd;
        }

        .archived-table tbody tr:hover {
            background: #fbfaf8;
        }

        .guest-id {
            color: #123a30;
            font-weight: 800;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 14px;
            color: #965d1b;
            background: #fff6eb;
            border: 1px solid #edc58e;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.05em;
        }

        .restore-form {
            margin: 0;
        }

        .restore-button {
            padding: 10px 17px;
            color: #ffffff;
            background: #17483f;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s ease;
        }

        .restore-button:hover {
            background: #0f342d;
        }

        .empty-message {
            padding: 50px 25px;
            text-align: center;
            color: #77716b;
            font-size: 16px;
        }

        @media (max-width: 800px) {
            .archived-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .archived-header h1 {
                font-size: 30px;
            }
        }
    </style>
</head>

<body class="admin-body">

    <jsp:include page="ownerNavbar.jsp" />

    <div class="admin-layout">

        <jsp:include page="sidebar.jsp" />

        <main class="main-content">

            <div class="container archived-page">

                <section class="archived-card">

                    <div class="archived-header">
                        <div>
                            <h1>Archived Guest</h1>
                            <p>
                                Guest accounts that have been changed to INACTIVE.
                            </p>
                        </div>

                        <span class="count-badge">
                            <%= archivedGuestList == null
                                    ? 0
                                    : archivedGuestList.size() %>
                        </span>
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

                    <% if (archivedGuestList != null
                            && !archivedGuestList.isEmpty()) { %>

                        <div class="table-wrapper">
                            <table class="archived-table">
                                <thead>
                                    <tr>
                                        <th>GUEST ID</th>
                                        <th>NAME</th>
                                        <th>EMAIL</th>
                                        <th>PHONE NUMBER</th>
                                        <th>STATUS</th>
                                        <th>ACTION</th>
                                    </tr>
                                </thead>

                                <tbody>
                                <% for (Guest guest : archivedGuestList) { %>
                                    <tr>
                                        <td class="guest-id">
                                            <%= guest.getGuestId() %>
                                        </td>

                                        <td>
                                            <%= guest.getGuestName() %>
                                        </td>

                                        <td>
                                            <%= guest.getGuestEmail() %>
                                        </td>

                                        <td>
                                            <%= guest.getGuestPhoneNumber() %>
                                        </td>


                                        <td>
                                            <span class="status-badge">
                                                <%= guest.getStatus() %>
                                            </span>
                                        </td>

                                        <td>
                                            <form class="restore-form"
                                                  method="post"
                                                  action="${pageContext.request.contextPath}/owner/restore-guest">

                                                <input type="hidden"
                                                       name="guestID"
                                                       value="<%= guest.getGuestId() %>">

                                                <button type="submit"
                                                        class="restore-button">
                                                    Restore
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>

                    <% } else { %>

                        <div class="empty-message">
                            No archived staff found.
                        </div>

                    <% } %>

                </section>

            </div>

        </main>

    </div>

</body>
</html>