package controller;

import java.io.*;
import jakarta.servlet.http.HttpSession;
import java.net.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    private static final String SECRET_KEY = "qlp9i554-uc58-ej30-urd4-60ko8r3joprp";
    private static final String CATEGORY_CODE = "0b6zvz2n";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingID = request.getParameter("bookingID");
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

        int amountInSen = (int) (totalAmount * 100);

        HttpSession session = request.getSession();
        session.setAttribute("bookingID", bookingID);
        session.setAttribute("totalAmount", totalAmount);

        String baseUrl = request.getScheme() + "://" +
                request.getServerName() + ":" +
                request.getServerPort() +
                request.getContextPath();

        String params =
                "userSecretKey=" + URLEncoder.encode(SECRET_KEY, "UTF-8") +
                "&categoryCode=" + URLEncoder.encode(CATEGORY_CODE, "UTF-8") +
                "&billName=" + URLEncoder.encode("DG Rimbun Booking Payment", "UTF-8") +
                "&billDescription=" + URLEncoder.encode("Payment for Booking " + bookingID, "UTF-8") +
                "&billPriceSetting=1" +
                "&billPayorInfo=1" +
                "&billAmount=" + amountInSen +
                "&billReturnUrl=" + URLEncoder.encode(baseUrl + "/PaymentReturnServlet", "UTF-8") +
                "&billCallbackUrl=" + URLEncoder.encode(baseUrl + "/PaymentCallbackServlet", "UTF-8") +
                "&billExternalReferenceNo=" + URLEncoder.encode(bookingID, "UTF-8") +
                "&billTo=" + URLEncoder.encode("Guest", "UTF-8") +
                "&billEmail=" + URLEncoder.encode("guest@email.com", "UTF-8") +
                "&billPhone=" + URLEncoder.encode("0123456789", "UTF-8") +
                "&billSplitPayment=0" +
                "&billPaymentChannel=0" +
                "&billContentEmail=" + URLEncoder.encode("Thank you for payment.", "UTF-8") +
                "&billChargeToCustomer=1";

        URL url = new URL("https://dev.toyyibpay.com/index.php/api/createBill");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes("UTF-8"));
        }

        BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream())
        );
        String result = br.readLine();

        System.out.println("ToyyibPay Response: " + result);

        if (!result.contains("BillCode")) {
            response.sendRedirect(request.getContextPath() + "/paymentPopUp.jsp?error=toyyibpay");
            return;
        }

        String billCode = result.split("\"BillCode\":\"")[1].split("\"")[0];

        session.setAttribute("bookingID", bookingID);
        session.setAttribute("totalAmount", totalAmount);

        response.sendRedirect("https://dev.toyyibpay.com/" + billCode);
    }
}