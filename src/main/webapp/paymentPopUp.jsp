<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Payment</title>
    <script src="https://sandbox.web.squarecdn.com/v1/square.js"></script>
</head>

<body>

<h2>Payment Pop Up</h2>

<form action="PaymentServlet" method="post">

    Booking ID:
	<input type="text" name="bookingID" value="B001">    <br><br>

    Payment Date:
    <input type="date" name="paymentDate">
    <br><br>

    Total Amount:
    <input type="text" name="totalAmount" value="350.00">
    <br><br>

    Security Deposit:
    <input type="text" name="securityDeposit" value="100.00">
    <br><br>

   <input type="hidden" name="sourceId" id="sourceId">
	<div id="card-container"></div>
	<button type="button" id="card-button">Pay Now</button>
    <br><br>


</form>
<script>
const appId = "sandbox-sq0idb-hIbgn8gMdngcuTniWjBLbg";
const locationId = "L4DYM9B0X4V4E";

async function main() {
    const payments = Square.payments(appId, locationId);
    const card = await payments.card();
    await card.attach('#card-container');

    document.getElementById('card-button').addEventListener('click', async function () {
        const result = await card.tokenize();

        if (result.status === 'OK') {
            document.getElementById('sourceId').value = result.token;
            document.querySelector('form').submit();
        } else {
            alert("Payment failed");
        }
    });
}

main();
</script>
</body>
</html>