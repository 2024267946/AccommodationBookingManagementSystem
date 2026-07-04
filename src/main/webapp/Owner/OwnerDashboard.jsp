<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Owner Dashboard</title>

<style>

body{
    font-family:Arial;
    margin:40px;
}

.card{

    display:inline-block;

    width:220px;

    padding:20px;

    margin:15px;

    border-radius:10px;

    background:#f5f5f5;

    box-shadow:0 0 5px gray;

    text-align:center;

}

.card h1{

    color:#0d6efd;

}

button{

    padding:10px 20px;

    margin:10px;

}

</style>

</head>

<body>

<h1>Owner Dashboard</h1>

<div class="card">

    <h3>Total Staff</h3>

    <h1>${totalStaff}</h1>

</div>

<div class="card">

    <h3>Total Guest</h3>

    <h1>${totalGuest}</h1>

</div>

<hr>

<h2>Management</h2>

<button onclick="location.href='${pageContext.request.contextPath}/staff/create-staff'">
Create Staff
</button>

<button onclick="location.href='${pageContext.request.contextPath}/staff/view-staff'">
View Staff
</button>

<button onclick="location.href='${pageContext.request.contextPath}/staff/view-guest'">
View Guest
</button>

</body>

</html>