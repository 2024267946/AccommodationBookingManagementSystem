<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice</title>
    <jsp:include page="header.jsp" />
    
</head>
<body class="invoice-page-body">
    <jsp:include page="navbar.jsp" />
    <div class="container" style="max-width: 800px; margin: 0 auto;">
        
        <!-- Action bar (Hidden when printing) -->
        <div class="no-print" style="margin-bottom: 1.5rem; display: flex; justify-content: space-between;">
            <a href="profile.jsp" class="btn-clear" style="text-decoration: none;">&larr; Back to Profile</a>
            <button onclick="window.print()" class="btn-primary"><i class="fas fa-print"></i> Print / Save PDF</button>
        </div>

        <!-- The Invoice Paper -->
        <div class="invoice-card">
            <div class="invoice-header">
                <div>
                    <h2 style="color: var(--primary-color);">Cuti Murah Melaka</h2>
                    <p class="text-muted">Melaka, Malaysia</p>
                </div>
                <div style="text-align: right;">
                    <h2>INVOICE</h2>
                    <p><strong>Booking ID:</strong> #BK-1001</p>
                    <p><strong>Issue Date:</strong> 2026-06-10</p>
                </div>
            </div>

            <div class="invoice-body">
                <div class="invoice-customer">
                    <h3>Billed To:</h3>
                    <p style="font-weight: bold;">Jane Doe</p>
                    <p>jane@email.com</p>
                    <p>+6012-345-6789</p>
                </div>

                <table class="data-table" style="margin-top: 2rem; width: 100%;">
                    <thead>
                        <tr>
                            <th>Description</th>
                            <th>Dates</th>
                            <th>Nights</th>
                            <th style="text-align: right;">Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Standard Chalet A1</td>
                            <td>20 Jun 2026 - 22 Jun 2026</td>
                            <td>2</td>
                            <td style="text-align: right;">RM 300.00</td>
                        </tr>
                        <tr>
                            <td>Cleaning Fee</td>
                            <td>-</td>
                            <td>-</td>
                            <td style="text-align: right;">RM 50.00</td>
                        </tr>
                    </tbody>
                </table>

                <div class="invoice-total">
                    <p><strong>Total Amount:</strong> <span class="price">RM 350.00</span></p>
                </div>
                
                <div style="text-align: center; margin-top: 4rem; color: var(--text-muted);">
                    <p>Thank you for choosing Cuti Murah Melaka!</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>