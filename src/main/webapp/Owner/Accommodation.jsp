<%@ page import="java.util.List" %>
<%@ page import="model.Accommodation" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    boolean staffView = Boolean.TRUE.equals(request.getAttribute("staffView"));
    List<Accommodation> accommodationList =
        (List<Accommodation>) request.getAttribute("accommodationList");
    List<Accommodation> archivedAccommodationList =
        (List<Accommodation>) request.getAttribute("archivedAccommodationList");

    String message = request.getParameter("message");
    String error = request.getParameter("error");
    boolean archivedTab = !staffView && "archived".equalsIgnoreCase(request.getParameter("tab"));
    List<Accommodation> displayedAccommodationList =
        archivedTab ? archivedAccommodationList : accommodationList;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accommodation Management | <%= staffView ? "Staff" : "Owner" %></title>

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

        .record-tabs {
            display: flex;
            gap: 8px;
            margin: 0 0 22px;
        }

        .record-tab {
            padding: 10px 20px;
            border: 1px solid #d7cec3;
            border-radius: 999px;
            color: #5f6f69;
            background: #ffffff;
            font-weight: 700;
            text-decoration: none;
        }

        .record-tab.active {
            border-color: #003d2f;
            background: #003d2f;
            color: #ffffff;
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
            padding: 22px;
            background: #ffffff;
            border: 1px solid #e6ded4;
            border-radius: 16px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
            cursor: pointer;
            transition: border-color .2s ease, box-shadow .2s ease, transform .2s ease;
        }

        .accommodation-card:hover,
        .accommodation-card:focus-visible {
            border-color: #88bd82;
            box-shadow: 0 10px 28px rgba(15, 65, 50, 0.12);
            outline: none;
        }

        .accommodation-summary {
            display: grid;
            grid-template-columns: 260px minmax(0, 1fr) auto;
            gap: 26px;
            align-items: center;
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
            margin: 0 0 6px;
            font-size: 27px;
            color: #1b1b1b;
        }

        .accommodation-type { margin:0 0 18px; color:#52635d; font-size:16px; }
        .accommodation-id { display:inline-flex;align-items:center;gap:8px;min-width:180px;padding:12px 15px;margin-bottom:16px;background:#f5f1eb;border:1px solid #e3dbd1;border-radius:9px;color:#50605a; }
        .accommodation-id::before { content:"\1F511"; }

        .description {
            margin: 0;
            padding-top: 14px;
            border-top: 1px solid #ece5dc;
            color: #6d6964;
            line-height: 1.65;
        }

        .expand-indicator { display:flex;align-items:center;gap:8px;color:#476058;font-weight:700;font-size:13px;white-space:nowrap; }
        .expand-indicator::after { content:"+";display:grid;place-items:center;width:30px;height:30px;border-radius:50%;background:#edf4f0;color:#0f5c49;font-size:20px; }
        .accommodation-card.is-expanded .expand-indicator::after { content:"\2212"; }

        .expand-panel { display:none;margin-top:22px;padding-top:20px;border-top:1px solid #e6ded4;cursor:default; }
        .accommodation-card.is-expanded .expand-panel { display:grid;grid-template-columns:minmax(0,1fr) auto;gap:24px;align-items:end; }

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
            flex-direction: row;
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
                padding:18px;
            }
            .accommodation-summary { grid-template-columns:180px minmax(0,1fr); }
            .expand-indicator { grid-column:1 / -1;justify-self:end; }
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

            .accommodation-summary { grid-template-columns:1fr; }

            .image-box {
                height: 210px;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }

            .accommodation-card.is-expanded .expand-panel { grid-template-columns:1fr; }
            .action-buttons { flex-direction:column; }

            .btn-edit,
            .btn-date,
            .btn-archive {
                width: 100%;
            }
        }
    </style>
</head>

<body class="admin-body">

    <% if (staffView) { %><jsp:include page="../Staff/StaffNavbar.jsp" /><% } else { %><jsp:include page="ownerNavbar.jsp" /><% } %>

    <div class="admin-layout">

        <% if (staffView) { %><jsp:include page="../Staff/StaffSidebar.jsp" /><% } else { %><jsp:include page="sidebar.jsp" /><% } %>

        <main class="main-content">

            <div class="container accommodation-page">

                <div class="system-header">
                    <h1>Accommodation Systems</h1>
                </div>

                <% if (!staffView) { %><div class="module-tabs">

                    <a href="${pageContext.request.contextPath}/OwnerAccommodationListServlet"
                       class="module-tab active">
                        Accommodation
                    </a>

                    <a href="${pageContext.request.contextPath}/owner/amenity"
                       class="module-tab">
                        Amenity
                    </a>

                </div><% } %>

                <div class="accommodation-toolbar">

                    <div>
                        <h2 style="margin:0 0 6px;">Accommodation Management</h2>
                        <p class="toolbar-text">
                            <%= staffView ? "View and update accommodation records." : "Create, edit and update accommodation records." %>
                        </p>
                    </div>

                    <% if (!staffView) { %><a href="${pageContext.request.contextPath}/Owner/CreateAccommodation.jsp"
                       class="btn-create">
                        Create Accommodation
                    </a><% } %>

                </div>

                <% if ("updateSuccess".equals(message)) { %>
                    <div class="message message-success">
                        Accommodation successfully updated.
                    </div>
                <% } else if ("availabilityUpdateSuccess".equals(message)) { %>
                    <div class="message message-success">
                        Availability successfully updated.
                    </div>
                <% } else if ("archiveSuccess".equals(message)) { %>
                    <div class="message message-success">Accommodation successfully archived.</div>
                <% } else if ("restoreSuccess".equals(message)) { %>
                    <div class="message message-success">Accommodation successfully restored.</div>
                <% } %>

                <% if (error != null) { %>
                    <div class="message message-error">
                        The requested operation could not be completed.
                    </div>
                <% } %>

                <% if (!staffView) { %><div class="record-tabs">
                    <a class="record-tab <%= !archivedTab ? "active" : "" %>"
                       href="${pageContext.request.contextPath}/OwnerAccommodationListServlet?tab=active">Active</a>
                    <a class="record-tab <%= archivedTab ? "active" : "" %>"
                       href="${pageContext.request.contextPath}/OwnerAccommodationListServlet?tab=archived">Archived</a>
                </div><% } %>

                <div class="summary-bar">
                    <span>
                        <%= archivedTab ? "Archived accommodation records" : "Active accommodation records" %>
                    </span>

                    <strong>
                        Total:
                        <%= displayedAccommodationList == null
                                ? 0
                                : displayedAccommodationList.size() %>
                    </strong>
                </div>

                <div class="accommodation-list">

                    <%
                        if (displayedAccommodationList != null
                                && !displayedAccommodationList.isEmpty()) {

                            for (Accommodation acc : displayedAccommodationList) {
                    %>

                    <div class="accommodation-card" role="button" tabindex="0" aria-expanded="false">

                        <div class="accommodation-summary">

                        <div class="image-box">
                            <img src="${pageContext.request.contextPath}/images/<%= "HOMESTAY".equalsIgnoreCase(acc.getAccommodationType()) ? "cmm1.jpg" : "chalet1.png" %>"
                                 alt="Accommodation image">
                        </div>

                        <div class="accommodation-info">

                            <h3><%= acc.getAccommodationName() %></h3>

                            <p class="accommodation-type"><%= acc.getAccommodationType() %></p>

                            <div class="accommodation-id">ID: <strong><%= acc.getAccommodationId() %></strong></div>

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

                        </div>

                        <span class="expand-indicator">View details</span>

                        </div>

                        <div class="expand-panel">

                            <div class="details-grid">

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

                        <div class="action-buttons">

                            <% if (!archivedTab) { %>

                            <a href="${pageContext.request.contextPath}/UpdateAccommodationServlet?accommodationId=<%= acc.getAccommodationId() %>"
                               class="btn-edit">
                                Edit
                            </a>

                            <a href="${pageContext.request.contextPath}/UpdateAvailabilityServlet?accommodationID=<%= acc.getAccommodationId() %>"
                               class="btn-date">
                                Date
                            </a>

                            <% if (!staffView) { %><a href="${pageContext.request.contextPath}/owner/accommodation/archive?id=<%= acc.getAccommodationId() %>"
                               class="btn-archive"
                               data-confirm-message="Archive this accommodation?">
                                Archive
                            </a><% } %>

                            <% } else { %>
                            <a href="${pageContext.request.contextPath}/owner/accommodation/restore?id=<%= acc.getAccommodationId() %>"
                               class="btn-edit">
                                Restore
                            </a>
                            <% } %>

                        </div>

                        </div>

                    </div>

                    <%
                            }

                        } else {
                    %>

                    <div class="empty-card">
                        No <%= archivedTab ? "archived" : "active" %> accommodation records were found.
                    </div>

                    <%
                        }
                    %>

                </div>

            </div>

        </main>

    </div>

    <% if ("createSuccess".equals(message) || "updated".equals(request.getParameter("success"))) { %><script>showAppNotification("Accommodation <%= "createSuccess".equals(message) ? "Created" : "Updated" %> Successfully","The accommodation information has been saved.","success",3500);</script><% } %>

<script src="${pageContext.request.contextPath}/js/app-modal.js"></script>
<script>
document.querySelectorAll('.accommodation-card').forEach(function(card) {
    function toggleCard() {
        const expanded = card.classList.toggle('is-expanded');
        card.setAttribute('aria-expanded', expanded ? 'true' : 'false');
        const label = card.querySelector('.expand-indicator');
        if (label) label.textContent = expanded ? 'Hide details' : 'View details';
    }
    card.addEventListener('click', function(event) {
        if (event.target.closest('a, button, form')) return;
        toggleCard();
    });
    card.addEventListener('keydown', function(event) {
        if (event.target.closest('a, button, form')) return;
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault();
            toggleCard();
        }
    });
});
</script>
</body>
</html>
