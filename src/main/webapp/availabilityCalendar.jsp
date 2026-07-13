<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Accommodation" %>
<%!
private String escapeJs(String value) {
    if (value == null) return "";
    return value.replace("\\", "\\\\").replace("\"", "\\\"")
            .replace("\r", "").replace("\n", "");
}
%>
<%
Accommodation accommodation = (Accommodation) request.getAttribute("accommodation");
String accommodationID = (String) request.getAttribute("accommodationID");
String unavailableDates = (String) request.getAttribute("unavailableDates");
String role = (String) request.getAttribute("role");
boolean owner = "OWNER".equalsIgnoreCase(role);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Availability Calendar | Cuti Murah Melaka</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <style>
        .calendar-page { width: min(1120px, 100%); margin: 0; }
        .calendar-card { padding: 30px; background:#fff; border:1px solid #e4dcd2; border-radius:18px; box-shadow:0 10px 28px rgba(15,45,36,.07); }
        .calendar-toolbar { display:flex; justify-content:space-between; align-items:center; gap:18px; margin-bottom:22px; }
        .calendar-toolbar h2 { margin:0; color:#123a30; font-family:"Playfair Display",Georgia,serif; font-size:30px; }
        .month-button { width:46px; height:42px; border:1px solid #d8d0c6; border-radius:9px; background:#f8f5f0; color:#173f34; font-size:22px; cursor:pointer; }
        .calendar-legend { display:flex; gap:20px; flex-wrap:wrap; margin-bottom:22px; color:#625f5a; font-weight:600; }
        .legend-dot { display:inline-block; width:13px; height:13px; margin-right:7px; border-radius:4px; vertical-align:-1px; }
        .legend-available { background:#dff3e7; border:1px solid #75bd91; }
        .legend-unavailable { background:#f9d9d6; border:1px solid #d97770; }
        .calendar-weekdays, .calendar-grid { display:grid; grid-template-columns:repeat(7,1fr); gap:9px; }
        .calendar-weekdays { margin-bottom:9px; color:#77716b; text-align:center; font-size:12px; font-weight:800; text-transform:uppercase; }
        .calendar-day { min-height:88px; padding:12px; border:1px solid #9acdad; border-radius:11px; background:#e9f7ee; color:#185c3f; text-align:left; font:inherit; font-weight:800; cursor:pointer; transition:.18s ease; }
        .calendar-day:hover { transform:translateY(-2px); box-shadow:0 6px 14px rgba(15,45,36,.12); }
        .calendar-day.unavailable { border-color:#db8b84; background:#fbe3e0; color:#a4342c; }
        .calendar-day.past { border-color:#e1ddd7; background:#f2f0ed; color:#aaa49d; cursor:not-allowed; opacity:.72; }
        .calendar-day.past:hover { transform:none; box-shadow:none; }
        .calendar-day.range-start { outline:3px solid #d3a02b; outline-offset:1px; }
        .calendar-blank { min-height:88px; }
        .calendar-actions { display:flex; align-items:center; justify-content:space-between; gap:16px; margin-top:26px; flex-wrap:wrap; }
        .selection-note { color:#77716b; font-size:14px; }
        .save-button, .cancel-button { display:inline-flex; align-items:center; justify-content:center; min-height:48px; padding:0 25px; border-radius:9px; font-weight:800; text-decoration:none; cursor:pointer; }
        .save-button { border:0; background:#003d2f; color:#fff; }
        .cancel-button { background:#eee9e1; color:#4d4a46; }
        .message-error { margin-bottom:20px; padding:14px 18px; border:1px solid #efbbb6; border-radius:10px; background:#fff0ee; color:#9e3229; font-weight:700; }
        @media(max-width:700px){ .calendar-card{padding:18px}.calendar-day,.calendar-blank{min-height:58px;padding:8px}.calendar-grid,.calendar-weekdays{gap:5px} }
    </style>
</head>
<body class="admin-body">
<% if (owner) { %>
    <jsp:include page="Owner/ownerNavbar.jsp" />
<% } else { %>
    <jsp:include page="Staff/StaffNavbar.jsp" />
<% } %>
<div class="admin-layout">
<% if (owner) { %>
    <jsp:include page="Owner/sidebar.jsp" />
<% } else { %>
    <jsp:include page="Staff/StaffSidebar.jsp" />
<% } %>
<main class="main-content">
<div class="container calendar-page">
    <div class="page-header" style="text-align:left;margin-bottom:24px;">
        <h1>Availability Calendar</h1>
        <p class="text-muted"><strong><%= accommodation.getAccommodationName() %></strong> · <%= accommodationID %></p>
    </div>
    <% if (request.getParameter("error") != null) { %>
        <div class="message-error">The availability dates could not be saved. Please try again.</div>
    <% } %>
    <form action="${pageContext.request.contextPath}/UpdateAvailabilityServlet" method="post" id="availability-form">
        <input type="hidden" name="accommodationID" value="<%= accommodationID %>">
        <input type="hidden" name="unavailableDates" id="unavailable-dates-input">
        <section class="calendar-card">
            <div class="calendar-toolbar">
                <button type="button" class="month-button" id="previous-month" aria-label="Previous month">&lsaquo;</button>
                <h2 id="calendar-month"></h2>
                <button type="button" class="month-button" id="next-month" aria-label="Next month">&rsaquo;</button>
            </div>
            <div class="calendar-legend">
                <span><i class="legend-dot legend-available"></i>Available</span>
                <span><i class="legend-dot legend-unavailable"></i>Unavailable</span>
            </div>
            <div class="calendar-weekdays"><span>Sun</span><span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span></div>
            <div class="calendar-grid" id="calendar-grid"></div>
            <div class="calendar-actions">
                <span class="selection-note" id="selection-note">Click a date, then another date to mark a range unavailable. Click a red date to make it available.</span>
                <div style="display:flex;gap:12px;">
                    <a class="cancel-button" href="<%= request.getContextPath() %>/<%= owner ? "OwnerAccommodationListServlet" : "staff/accommodation" %>">Cancel</a>
                    <button type="submit" class="save-button">Save</button>
                </div>
            </div>
        </section>
    </form>
</div>
</main>
</div>
<script>
const today = new Date();
today.setHours(0, 0, 0, 0);
const todayIso = today.getFullYear() + "-" + String(today.getMonth()+1).padStart(2,"0") + "-" + String(today.getDate()).padStart(2,"0");
const unavailableDates = new Set("<%= escapeJs(unavailableDates) %>".split(",").map(value => value.trim()).filter(value => value && value >= todayIso));
const hiddenInput = document.getElementById("unavailable-dates-input");
const calendarGrid = document.getElementById("calendar-grid");
const monthTitle = document.getElementById("calendar-month");
const selectionNote = document.getElementById("selection-note");
let rangeStart = null;
let visibleMonth = new Date();
visibleMonth = new Date(visibleMonth.getFullYear(), visibleMonth.getMonth(), 1);

function isoDate(year, month, day) {
    return year + "-" + String(month + 1).padStart(2, "0") + "-" + String(day).padStart(2, "0");
}

function saveToInput() {
    hiddenInput.value = Array.from(unavailableDates).sort().join(",");
}

function addRange(start, end) {
    const firstValue = start < end ? start : end;
    const lastValue = start < end ? end : start;
    let current = new Date(firstValue + "T00:00:00");
    const finish = new Date(lastValue + "T00:00:00");
    while (current <= finish) {
        unavailableDates.add(current.getFullYear() + "-" + String(current.getMonth()+1).padStart(2,"0") + "-" + String(current.getDate()).padStart(2,"0"));
        current.setDate(current.getDate() + 1);
    }
}

function selectDate(date) {
    if (unavailableDates.has(date)) {
        unavailableDates.delete(date);
        rangeStart = null;
        selectionNote.textContent = date + " is now available.";
    } else if (rangeStart === null) {
        rangeStart = date;
        selectionNote.textContent = "Range starts on " + date + ". Select the end date.";
    } else {
        addRange(rangeStart, date);
        selectionNote.textContent = "Selected range is now unavailable.";
        rangeStart = null;
    }
    saveToInput();
    renderCalendar();
}

function renderCalendar() {
    calendarGrid.innerHTML = "";
    const year = visibleMonth.getFullYear();
    const month = visibleMonth.getMonth();
    monthTitle.textContent = visibleMonth.toLocaleDateString("en-AU", {month:"long", year:"numeric"});
    const firstWeekday = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    for (let i = 0; i < firstWeekday; i++) {
        const blank = document.createElement("div");
        blank.className = "calendar-blank";
        calendarGrid.appendChild(blank);
    }

    for (let day = 1; day <= daysInMonth; day++) {
        const date = isoDate(year, month, day);
        const button = document.createElement("button");
        button.type = "button";
        button.className = "calendar-day";
        const isPast = date < todayIso;
        if (isPast) {
            button.classList.add("past");
            button.disabled = true;
        } else if (unavailableDates.has(date)) {
            button.classList.add("unavailable");
        }
        if (!isPast && rangeStart === date) button.classList.add("range-start");
        button.textContent = day;
        button.setAttribute("aria-label", date + (unavailableDates.has(date) ? " unavailable" : " available"));
        if (!isPast) button.addEventListener("click", () => selectDate(date));
        calendarGrid.appendChild(button);
    }
}

document.getElementById("previous-month").addEventListener("click", () => { visibleMonth.setMonth(visibleMonth.getMonth()-1); renderCalendar(); });
document.getElementById("next-month").addEventListener("click", () => { visibleMonth.setMonth(visibleMonth.getMonth()+1); renderCalendar(); });
document.getElementById("availability-form").addEventListener("submit", saveToInput);
saveToInput();
renderCalendar();
</script>
</body>
</html>
