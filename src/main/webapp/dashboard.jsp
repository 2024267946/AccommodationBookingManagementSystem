<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%!
private String js(String value) {
    if (value == null) return "";
    return value.replace("\\", "\\\\").replace("\"", "\\\"")
            .replace("\r", "").replace("\n", " ").replace("<", "\\u003c");
}
%>
<%
Map<String,Object> analytics = (Map<String,Object>) request.getAttribute("dashboardAnalytics");
if (analytics == null) analytics = new java.util.HashMap<>();
String dashboardRole = (String) request.getAttribute("dashboardRole");
boolean owner = "OWNER".equalsIgnoreCase(dashboardRole);

List<Map<String,Object>> revenueRows = (List<Map<String,Object>>) analytics.get("revenueByAccommodation");
List<Map<String,Object>> stayRows = (List<Map<String,Object>>) analytics.get("stayLengthByAccommodation");

Number totalBookings = (Number) analytics.getOrDefault("totalBookings", 0);
Number totalRevenue = (Number) analytics.getOrDefault("totalRevenue", 0d);
Number totalCancelled = (Number) analytics.getOrDefault("totalCancelled", 0);
Number activeCustomers = (Number) analytics.getOrDefault("activeCustomers", 0);
Number activeStaff = (Number) analytics.getOrDefault("activeStaff", 0);
Number upcomingStays = (Number) analytics.getOrDefault("upcomingStays", 0);
Number averageBookingAmount = (Number) analytics.getOrDefault("averageBookingAmount", 0d);
Number averageBookedDays = (Number) analytics.getOrDefault("averageBookedDays", 0d);
Number weekdayNights = (Number) analytics.getOrDefault("weekdayNights", 0L);
Number weekendNights = (Number) analytics.getOrDefault("weekendNights", 0L);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= owner ? "Owner" : "Staff" %> Dashboard | Cuti Murah Melaka</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
    <style>
        .analytics-page{width:min(1280px,100%);margin:0}.analytics-heading{display:flex;align-items:center;justify-content:space-between;gap:20px;margin-bottom:28px;text-align:left}.analytics-heading h1{margin:0 0 7px;color:#123a30;font-size:38px}.analytics-heading p{margin:0;color:#77716b}.report-button{display:inline-flex;align-items:center;justify-content:center;min-height:46px;padding:0 21px;border-radius:9px;background:#003d2f;color:#fff;font-size:13px;font-weight:800;letter-spacing:.06em;text-decoration:none;text-transform:uppercase;white-space:nowrap}
        .metric-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:18px;margin-bottom:30px}.metric-card{padding:22px;background:#fff;border:1px solid #e4dcd2;border-radius:15px;box-shadow:0 6px 18px rgba(15,45,36,.05);border-top:4px solid #1b6a53}.metric-label{display:block;margin-bottom:10px;color:#747b77;font-size:11px;font-weight:800;letter-spacing:.1em;text-transform:uppercase}.metric-value{display:block;color:#123a30;font-size:31px;font-weight:800;line-height:1.15}.metric-note{display:block;margin-top:7px;color:#989088;font-size:12px}
        .chart-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:22px}.chart-card{min-width:0;padding:24px;background:#fff;border:1px solid #e4dcd2;border-radius:16px;box-shadow:0 6px 18px rgba(15,45,36,.05)}.chart-card h2{margin:0 0 5px;color:#123a30;font-size:21px}.chart-card p{margin:0 0 20px;color:#807970;font-size:13px}.chart-wrap{position:relative;height:330px}.pie-card{grid-column:1/-1}.pie-card .chart-wrap{height:350px;max-width:560px;margin:0 auto}
        @media(max-width:1000px){.metric-grid{grid-template-columns:repeat(2,1fr)}}@media(max-width:760px){.metric-grid,.chart-grid{grid-template-columns:1fr}.pie-card{grid-column:auto}.analytics-heading{align-items:stretch;flex-direction:column}.analytics-heading h1{font-size:32px}.report-button{width:100%;box-sizing:border-box}}
    </style>
</head>
<body class="admin-body">
<% if (owner) { %><jsp:include page="Owner/ownerNavbar.jsp" /><% } else { %><jsp:include page="Staff/StaffNavbar.jsp" /><% } %>
<div class="admin-layout">
<% if (owner) { %><jsp:include page="Owner/sidebar.jsp" /><% } else { %><jsp:include page="Staff/StaffSidebar.jsp" /><% } %>
<main class="main-content"><div class="container analytics-page">
    <header class="analytics-heading"><div><h1>Dashboard Overview</h1><p>Booking, revenue, customer and accommodation performance at a glance.</p></div><a class="report-button" href="${pageContext.request.contextPath}/<%= owner ? "owner" : "staff" %>/dashboard/report">Download Report</a></header>
    <section class="metric-grid">
        <article class="metric-card"><span class="metric-label">Total Bookings</span><span class="metric-value"><%= totalBookings.intValue() %></span><span class="metric-note">All recorded bookings</span></article>
        <article class="metric-card"><span class="metric-label">Total Revenue</span><span class="metric-value">RM <%= String.format("%,.2f", totalRevenue.doubleValue()) %></span><span class="metric-note">Paid payments</span></article>
        <article class="metric-card"><span class="metric-label">Total Cancelled</span><span class="metric-value"><%= totalCancelled.intValue() %></span><span class="metric-note">Cancelled bookings</span></article>
        <article class="metric-card"><span class="metric-label">Active Customers</span><span class="metric-value"><%= activeCustomers.intValue() %></span><span class="metric-note">Active guest accounts</span></article>
        <article class="metric-card"><span class="metric-label">Active Staff</span><span class="metric-value"><%= activeStaff.intValue() %></span><span class="metric-note">Active staff accounts</span></article>
        <article class="metric-card"><span class="metric-label">Upcoming Stays</span><span class="metric-value"><%= upcomingStays.intValue() %></span><span class="metric-note">Future/current check-ins</span></article>
        <article class="metric-card"><span class="metric-label">Average Booking Amount</span><span class="metric-value">RM <%= String.format("%,.2f", averageBookingAmount.doubleValue()) %></span><span class="metric-note">Excluding cancellations</span></article>
        <article class="metric-card"><span class="metric-label">Average Days Booked</span><span class="metric-value"><%= String.format("%.1f", averageBookedDays.doubleValue()) %></span><span class="metric-note">Nights per booking</span></article>
    </section>
    <section class="chart-grid">
        <article class="chart-card"><h2>Highest Average Revenue</h2><p>Top five accommodations by average paid amount.</p><div class="chart-wrap"><canvas id="revenue-chart"></canvas></div></article>
        <article class="chart-card"><h2>Longest Average Stay</h2><p>Top five accommodations by average booked nights.</p><div class="chart-wrap"><canvas id="stay-chart"></canvas></div></article>
        <article class="chart-card pie-card"><h2>Weekday vs Weekend</h2><p>Share of non-cancelled booked nights.</p><div class="chart-wrap"><canvas id="day-share-chart"></canvas></div></article>
    </section>
</div></main></div>
<script>
const revenueLabels=[<% if(revenueRows!=null) for(Map<String,Object> row:revenueRows){ %>"<%= js(String.valueOf(row.get("label"))) %>",<% } %>];
const revenueValues=[<% if(revenueRows!=null) for(Map<String,Object> row:revenueRows){ %><%= ((Number)row.get("value")).doubleValue() %>,<% } %>];
const stayLabels=[<% if(stayRows!=null) for(Map<String,Object> row:stayRows){ %>"<%= js(String.valueOf(row.get("label"))) %>",<% } %>];
const stayValues=[<% if(stayRows!=null) for(Map<String,Object> row:stayRows){ %><%= ((Number)row.get("value")).doubleValue() %>,<% } %>];

const commonOptions={responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{y:{beginAtZero:true,grid:{color:"rgba(20,60,48,.08)"}},x:{grid:{display:false}}}};
new Chart(document.getElementById("revenue-chart"),{type:"bar",data:{labels:revenueLabels,datasets:[{data:revenueValues,backgroundColor:"#17634d",borderRadius:8}]},options:commonOptions});
new Chart(document.getElementById("stay-chart"),{type:"bar",data:{labels:stayLabels,datasets:[{data:stayValues,backgroundColor:"#b58a42",borderRadius:8}]},options:commonOptions});
new Chart(document.getElementById("day-share-chart"),{type:"doughnut",data:{labels:["Weekdays","Weekends"],datasets:[{data:[<%= weekdayNights.longValue() %>,<%= weekendNights.longValue() %>],backgroundColor:["#17634d","#d9a647"],borderWidth:0}]},options:{responsive:true,maintainAspectRatio:false,cutout:"62%",plugins:{legend:{position:"bottom"}}}});
</script>
</body></html>
