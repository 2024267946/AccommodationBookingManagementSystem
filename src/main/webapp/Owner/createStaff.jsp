<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Staff</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f8f7f3;
}

.container {
    margin-left: 260px;
    padding: 40px;
}

.card {
    background: white;
    width: 600px;
    padding: 30px;
    border-radius: 16px;
    box-shadow: 0 4px 14px rgba(0,0,0,0.08);
}

h1 {
    margin-bottom: 25px;
}

label {
    font-weight: bold;
    display: block;
    margin-top: 15px;
}

input, select {
    width: 100%;
    padding: 13px;
    margin-top: 8px;
    border: 1px solid #ccc;
    border-radius: 10px;
    box-sizing: border-box;
}

.btn-row {
    margin-top: 25px;
}

.btn {
    padding: 12px 25px;
    border: none;
    border-radius: 10px;
    text-decoration: none;
    cursor: pointer;
    font-weight: bold;
}

.btn-save {
    background: #8fa482;
    color: white;
}

.btn-cancel {
    background: #ddd;
    color: #333;
    margin-left: 10px;
}
</style>
</head>

<body>

<div class="container">
    <h1>Create Staff</h1>

    <div class="card">
        <form action="<%=request.getContextPath()%>/staff/create-staff" method="post">

            <label>Staff Name</label>
            <input type="text" name="staffName" required>

            <label>Email</label>
            <input type="email" name="staffEmail" required>

            <label>Password</label>
            <input type="password" name="staffPassword" required>

            <label>Phone Number</label>
            <input type="text" name="staffPhoneNumber" required>

            <label>Role</label>
            <select name="staffRoles" required>
                <option value="STAFF">STAFF</option>
                <option value="OWNER">OWNER</option>
            </select>

            <div class="btn-row">
                <button type="submit" class="btn btn-save">Create Staff</button>
                <a href="<%=request.getContextPath()%>/staff/view-staff" class="btn btn-cancel">Cancel</a>
            </div>

        </form>
    </div>
</div>

</body>
</html>