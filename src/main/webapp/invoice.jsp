<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Invoice - DG Rimbun</title>
    <!-- Tailwind CSS Script -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome for standard HTML Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#16a34a',
                        accent: '#dcfce7',
                        border: '#e5e7eb',
                        'muted-foreground': '#6b7280'
                    }
                }
            }
        }
    </script>
    <style>
      /* Ensures background colors print correctly on the PDF */
      @media print {
        body {
          -webkit-print-color-adjust: exact;
          print-color-adjust: exact;
        }
      }
    </style>
</head>
<body class="min-h-screen bg-gradient-to-b from-accent/10 to-white pt-20 print:pt-0 print:bg-white">

    <!-- Navigation Bar (Hidden when printing) -->
    <nav class="bg-white/90 backdrop-blur-md fixed w-full z-50 top-0 border-b border-border shadow-sm print:hidden">
      <div class="container mx-auto px-4">
        <div class="flex justify-between items-center h-20">
          <a href="index.jsp" class="flex items-center gap-2 text-2xl font-bold text-primary">
            <i class="fas fa-leaf"></i> DG Rimbun
          </a>
          <div class="hidden md:flex items-center space-x-10">
            <div class="flex items-center space-x-8">
              <a href="index.jsp" class="text-gray-500 hover:text-[#859f8a] font-medium transition-colors">
                <i class="fas fa-home mr-1"></i> Home
              </a>
              <a href="homestays.jsp" class="text-gray-500 hover:text-[#859f8a] font-medium transition-colors">
                <i class="fas fa-bed mr-1"></i> Homestays
              </a>
              <a href="booking.jsp" class="text-gray-500 hover:text-[#859f8a] font-medium transition-colors">
                <i class="fas fa-calendar-check mr-1"></i> My Bookings
              </a>
            </div>
            <div class="flex items-center space-x-6">
              <span class="font-medium text-gray-700">Welcome, Alysa!</span>
              <form action="LogoutServlet" method="POST" class="m-0">
                  <button type="submit" class="flex items-center gap-2 bg-red-50 text-red-600 hover:bg-red-100 px-5 py-2 rounded-md font-medium transition-colors">
                      <i class="fas fa-sign-out-alt"></i> Logout
                  </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <div class="container mx-auto px-4 py-8 max-w-4xl print:py-0">
      
      <!-- Header Actions (Hidden when printing) -->
      <div class="mb-8 print:hidden">
        <a href="booking.jsp" class="inline-flex items-center text-gray-600 hover:text-primary font-medium mb-6 transition-colors">
          <i class="fas fa-arrow-left mr-2"></i> Back to Bookings
        </a>
        
        <div class="flex items-center justify-between flex-wrap gap-4">
          <div>
            <h1 class="text-3xl font-bold mb-2">Booking Invoice</h1>
            <p class="text-muted-foreground">Review your booking details and proceed to payment</p>
          </div>
          <div class="flex items-center gap-3">
            <button onclick="window.print()" class="inline-flex items-center border border-primary text-primary hover:bg-primary/10 px-4 py-2 rounded-md font-medium transition-colors">
              <i class="fas fa-download mr-2"></i> View PDF
            </button>
            <span class="inline-flex items-center bg-blue-50 text-blue-700 border border-blue-200 font-medium px-4 py-2 rounded-md">
              <i class="fas fa-file-invoice mr-2"></i> Invoice
            </span>
          </div>
        </div>
      </div>

      <!-- Main Invoice Card -->
      <div class="bg-white rounded-xl shadow-lg border border-border print:shadow-none print:border-none overflow-hidden">
        
        <!-- Invoice Header -->
        <div class="border-b border-border bg-accent/5 p-6">
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-2xl font-bold text-gray-900">Homestay DG Rimbun</h2>
              <p class="text-sm text-muted-foreground mt-1">Booking ID: #BK982341</p>
              <p class="text-sm text-muted-foreground">Invoice Date: Oct 01, 2026</p>
            </div>
            <!-- Status Badge for PDF -->
            <div class="text-right">
                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-800 border border-yellow-200">
                  Pending Payment
                </span>
            </div>
          </div>
        </div>
        
        <div class="p-8 space-y-8">
          
          <!-- Homestay Details -->
          <div class="space-y-4">
            <h3 class="text-lg font-semibold flex items-center gap-2 text-gray-800">
              <i class="fas fa-map-marker-alt text-primary"></i> Homestay Details
            </h3>
            <div class="bg-accent/10 rounded-lg p-6 space-y-3 border border-border/50">
              <div>
                <p class="font-bold text-lg text-gray-900">DG Rimbun - Family Suite</p>
                <p class="text-sm text-muted-foreground mt-1">A spacious suite perfect for larger families, featuring beautiful views of the surrounding nature reserve.</p>
              </div>
              <div class="flex items-center gap-2 text-gray-600 mt-3 pt-3 border-t border-border/50">
                <i class="fas fa-users"></i>
                <span class="text-sm font-medium">4 Guests</span>
              </div>
            </div>
          </div>

          <!-- Booking Information -->
          <div class="space-y-4">
            <h3 class="text-lg font-semibold flex items-center gap-2 text-gray-800">
              <i class="fas fa-calendar-alt text-primary"></i> Booking Information
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="bg-accent/10 rounded-lg p-5 border border-border/50">
                <p class="text-sm text-muted-foreground mb-1 uppercase tracking-wider font-semibold">Check-in Date</p>
                <p class="font-bold text-gray-900 text-lg">Thu, Oct 15, 2026</p>
                <p class="text-xs text-primary font-medium mt-1">After 3:00 PM</p>
              </div>
              <div class="bg-accent/10 rounded-lg p-5 border border-border/50">
                <p class="text-sm text-muted-foreground mb-1 uppercase tracking-wider font-semibold">Check-out Date</p>
                <p class="font-bold text-gray-900 text-lg">Sun, Oct 18, 2026</p>
                <p class="text-xs text-red-500 font-medium mt-1">Before 12:00 PM</p>
              </div>
            </div>
            <div class="bg-primary/5 rounded-lg p-4 border-l-4 border-primary">
              <p class="font-bold text-primary text-lg">Total Duration: 3 Nights</p>
            </div>
          </div>

          <!-- Guest Information -->
          <div class="space-y-4">
            <h3 class="text-lg font-semibold flex items-center gap-2 text-gray-800">
              <i class="fas fa-user-circle text-primary"></i> Guest Information
            </h3>
            <div class="bg-accent/10 rounded-lg p-6 space-y-3 border border-border/50">
              <div class="flex justify-between border-b border-border/50 pb-2">
                <span class="text-muted-foreground">Name:</span>
                <span class="font-bold text-gray-900">Alysa Binti Ali</span>
              </div>
              <div class="flex justify-between border-b border-border/50 pb-2">
                <span class="text-muted-foreground">Email:</span>
                <span class="font-medium text-gray-900">Alysa@email.com</span>
              </div>
              <div class="flex justify-between border-b border-border/50 pb-2">
                <span class="text-muted-foreground">Phone:</span>
                <span class="font-medium text-gray-900">+6012-345-6789</span>
              </div>
              <div class="flex justify-between pt-1">
                <span class="text-muted-foreground">Number of Guests:</span>
                <span class="font-medium text-gray-900">4 Pax</span>
              </div>
            </div>
          </div>

          <!-- Price Breakdown -->
          <div class="space-y-4">
            <h3 class="text-lg font-semibold flex items-center gap-2 text-gray-800">
              <i class="fas fa-credit-card text-primary"></i> Price Breakdown
            </h3>
            <div class="bg-accent/10 rounded-lg p-6 space-y-3 border border-border/50">
              <div class="flex justify-between items-center pb-2">
                <span class="text-muted-foreground">RM250 × 3 nights</span>
                <span class="font-medium text-gray-900">RM 750.00</span>
              </div>
              <div class="flex justify-between items-center pb-2">
                <span class="text-muted-foreground">Service Fee (5%)</span>
                <span class="font-medium text-gray-900">RM 37.50</span>
              </div>
              <div class="flex justify-between items-center pb-4 border-b border-border">
                <span class="text-muted-foreground">Tax (6%)</span>
                <span class="font-medium text-gray-900">RM 45.00</span>
              </div>
              <div class="flex justify-between items-center pt-2">
                <span class="text-lg font-bold text-gray-900">Total Amount</span>
                <span class="text-3xl font-bold text-primary">RM 832.50</span>
              </div>
            </div>
          </div>

          <!-- Terms & Conditions -->
          <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-5">
            <h4 class="font-bold text-yellow-800 mb-2">Important Notes:</h4>
            <ul class="text-sm text-yellow-700 space-y-1.5 list-disc list-inside">
              <li>Check-in time is after 3:00 PM, check-out time is before 12:00 PM.</li>
              <li>Please bring a valid ID/IC/Passport for verification upon arrival.</li>
              <li>Cancellation policy applies as per terms and conditions.</li>
              <li>Full payment is required to confirm your booking and secure the dates.</li>
            </ul>
          </div>

          <!-- Proceed to Payment Button (Hidden on Print) -->
          <div class="pt-6 print:hidden">
            <button onclick="openPaymentModal()" class="w-full h-14 text-lg bg-primary hover:bg-primary/90 text-white font-bold rounded-lg shadow-lg flex items-center justify-center transition-colors">
              <i class="fas fa-lock mr-2"></i> Proceed to Secure Payment
            </button>
          </div>

        </div>
      </div>
    </div>

    <!-- ==========================================
         MODALS (Hidden by default, controlled via JS)
         ========================================== -->

    <!-- 1. Payment Selection Modal -->
    <div id="paymentModal" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[60] flex items-center justify-center p-4 print:hidden">
      <div class="bg-white rounded-xl shadow-2xl max-w-lg w-full p-8 animate-[fadeIn_0.2s_ease-out]">
        <h2 class="text-2xl font-bold text-center mb-2">Choose Payment Method</h2>
        <p class="text-muted-foreground text-center mb-8">Select your preferred way to complete the booking.</p>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
          <!-- FPX -->
          <button onclick="processPayment('FPX')" class="flex flex-col items-center justify-center p-6 rounded-xl border-2 border-gray-200 hover:border-primary hover:bg-accent/5 transition-all group">
            <div class="w-16 h-16 mb-4 bg-primary/10 rounded-full flex items-center justify-center group-hover:bg-primary/20 transition-colors">
              <i class="fas fa-mobile-alt text-3xl text-primary"></i>
            </div>
            <h3 class="font-bold text-lg text-gray-900">FPX</h3>
            <p class="text-xs text-muted-foreground text-center mt-1">Online Banking</p>
          </button>

          <!-- QR -->
          <button onclick="processPayment('QR')" class="flex flex-col items-center justify-center p-6 rounded-xl border-2 border-gray-200 hover:border-primary hover:bg-accent/5 transition-all group">
            <div class="w-16 h-16 mb-4 bg-primary/10 rounded-full flex items-center justify-center group-hover:bg-primary/20 transition-colors">
              <i class="fas fa-qrcode text-3xl text-primary"></i>
            </div>
            <h3 class="font-bold text-lg text-gray-900">QR Code</h3>
            <p class="text-xs text-muted-foreground text-center mt-1">Scan & Pay</p>
          </button>
        </div>
        
        <div class="border-t border-border pt-6 mb-6">
          <div class="flex justify-between items-center">
            <span class="font-semibold text-gray-600">Total Due:</span>
            <span class="text-2xl font-bold text-primary">RM 832.50</span>
          </div>
        </div>

        <button onclick="closeModal('paymentModal')" class="w-full py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors">
          Cancel
        </button>
      </div>
    </div>

    <!-- 2. Loading Spinner Modal -->
    <div id="loadingModal" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[70] flex items-center justify-center p-4 print:hidden">
      <div class="bg-white rounded-xl shadow-2xl p-10 max-w-sm w-full text-center">
        <i class="fas fa-circle-notch fa-spin text-6xl text-primary mb-6"></i>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Processing Payment</h2>
        <p class="text-muted-foreground">Please do not close this window or click back.</p>
      </div>
    </div>

    <!-- 3. Success Checkmark Modal -->
    <div id="successModal" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[80] flex items-center justify-center p-4 print:hidden">
      <div class="bg-white rounded-xl shadow-2xl p-8 max-w-md w-full text-center transform scale-100 transition-transform">
        <div class="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
          <i class="fas fa-check-circle text-5xl text-green-600"></i>
        </div>
        <h2 class="text-3xl font-bold text-gray-900 mb-2">Payment Successful!</h2>
        <p class="text-muted-foreground mb-6">Your booking #BK982341 is now Confirmed.</p>
        
        <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
          <p class="text-sm text-blue-800">
            <i class="fas fa-envelope mr-2"></i> We've sent the confirmation and occupancy details to <strong>Alysa@email.com</strong>
          </p>
        </div>

        <p class="text-sm text-gray-400 mb-4 animate-pulse">Redirecting to your dashboard...</p>
      </div>
    </div>

    <!-- JavaScript to Handle the Modals & Animations -->
    <script>
      function openPaymentModal() {
        document.getElementById('paymentModal').classList.remove('hidden');
      }

      function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
      }

      // Mimics the payment processing and auto-redirects back to bookings
      function processPayment(method) {
        closeModal('paymentModal');
        const loader = document.getElementById('loadingModal');
        loader.classList.remove('hidden');

        // Simulate 2 seconds of banking API processing
        setTimeout(() => {
          loader.classList.add('hidden');
          document.getElementById('successModal').classList.remove('hidden');
          
          // Wait 3 seconds so the user can read the success message, then redirect
          setTimeout(() => {
              window.location.href = 'booking.jsp';
          }, 3000);

        }, 2000);
      }
    </script>
</body>
</html>