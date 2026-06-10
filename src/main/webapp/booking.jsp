<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bookings - DG Rimbun</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#16a34a',
                        accent: '#dcfce7',
                        border: '#e5e7eb',
                        destructive: '#ef4444',
                        'muted-foreground': '#6b7280'
                    }
                }
            }
        }
    </script>
</head>
<body class="min-h-screen bg-gradient-to-b from-accent/10 to-white pt-20 relative">

    <nav class="bg-white/90 backdrop-blur-md fixed w-full z-50 top-0 border-b border-border shadow-sm">
      <div class="container mx-auto px-4">
        <div class="flex justify-between items-center h-20">
          <a href="index.jsp" class="flex items-center gap-2 text-2xl font-bold text-primary">
            <i class="fas fa-leaf"></i> DG Rimbun
          </a>
          <div class="hidden md:flex items-center space-x-10">
            <div class="flex items-center space-x-8">
              <a href="index.jsp" class="flex items-center gap-2 text-gray-500 hover:text-[#859f8a] font-medium transition-colors">
                <i class="fas fa-home text-lg"></i> Home
              </a>
              <a href="homestays.jsp" class="flex items-center gap-2 text-gray-500 hover:text-[#859f8a] font-medium transition-colors">
                <i class="fas fa-bed text-lg"></i> Homestays
              </a>
              <a href="booking.jsp" class="flex items-center gap-2 text-[#859f8a] font-medium transition-colors">
                <i class="fas fa-calendar-check text-lg"></i> My Bookings
              </a>
            </div>
            <div class="flex items-center space-x-6">
              <span class="font-medium text-gray-700">Welcome, Alysa!</span>
              <form action="LogoutServlet" method="POST" class="m-0">
                  <button type="submit" class="flex items-center gap-2 bg-red-50 text-red-600 hover:bg-red-100 px-5 py-2.5 rounded-md font-medium transition-colors">
                      <i class="fas fa-sign-out-alt text-lg"></i> Logout
                  </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <div class="container mx-auto px-4 py-16">
      <div class="max-w-7xl mx-auto">
        
        <div class="mb-8">
          <h1 class="text-4xl font-bold mb-2 text-gray-900">My Bookings</h1>
          <p class="text-muted-foreground text-lg">View and manage all your homestay reservations</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div class="bg-white rounded-xl border-l-4 border-l-primary shadow-md p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground font-medium mb-1">Total Bookings</p>
                <p class="text-3xl font-bold">3</p>
              </div>
              <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center">
                <i class="fas fa-calendar-alt text-primary text-xl"></i>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl border-l-4 border-l-yellow-500 shadow-md p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground font-medium mb-1">Pending Payment</p>
                <p class="text-3xl font-bold">1</p>
              </div>
              <div class="w-12 h-12 bg-yellow-100 rounded-full flex items-center justify-center">
                <i class="fas fa-clock text-yellow-600 text-xl"></i>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl border-l-4 border-l-green-500 shadow-md p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground font-medium mb-1">Confirmed</p>
                <p class="text-3xl font-bold">1</p>
              </div>
              <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                <i class="fas fa-check-circle text-green-600 text-xl"></i>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl border-l-4 border-l-blue-500 shadow-md p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-muted-foreground font-medium mb-1">Completed</p>
                <p class="text-3xl font-bold">1</p>
              </div>
              <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                <i class="fas fa-check-double text-blue-600 text-xl"></i>
              </div>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow-lg border border-border overflow-hidden">
          <div class="bg-gradient-to-r from-primary/5 to-transparent border-b border-border p-6">
            <h2 class="text-xl font-bold flex items-center gap-2">
              <i class="fas fa-list text-primary"></i> All Bookings
            </h2>
          </div>
          
          <div class="overflow-x-auto">
            <table class="w-full">
              <thead class="bg-gray-50">
                <tr class="border-b border-border">
                  <th class="text-left py-4 px-6 font-semibold text-sm text-gray-700">Booking ID</th>
                  <th class="text-left py-4 px-6 font-semibold text-sm text-gray-700">Homestay</th>
                  <th class="text-left py-4 px-6 font-semibold text-sm text-gray-700">Dates</th>
                  <th class="text-left py-4 px-6 font-semibold text-sm text-gray-700">Amount</th>
                  <th class="text-left py-4 px-6 font-semibold text-sm text-gray-700">Status</th>
                  <th class="text-left py-4 px-6 font-semibold text-sm text-gray-700">Invoice</th>
                  <th class="text-left py-4 px-6 font-semibold text-sm text-gray-700">Actions</th>
                </tr>
              </thead>
              <tbody>
                
                <tr class="border-b border-border hover:bg-gray-50 transition-colors">
                  <td class="py-4 px-6 font-semibold text-primary">BK982341</td>
                  <td class="py-4 px-6 font-medium text-gray-900">DG Rimbun - Family Suite</td>
                  <td class="py-4 px-6 text-sm text-gray-600">
                    Oct 15, 2026 - Oct 18, 2026<br>
                    <span class="text-xs text-muted-foreground">3 Nights • 4 Guests</span>
                  </td>
                  <td class="py-4 px-6 font-bold text-lg text-primary">RM 800</td>
                  <td class="py-4 px-6">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800 border border-yellow-200">
                      Pending Payment
                    </span>
                  </td>
                  <td class="py-4 px-6">
                    <span class="text-xs text-gray-400 italic">Available after payment</span>
                  </td>
                  <td class="py-4 px-6">
                    <button onclick="openPaymentModal()" class="bg-primary hover:bg-primary/90 text-white px-4 py-2 rounded-md text-sm font-medium transition-colors shadow-sm">
                      <i class="fas fa-credit-card mr-1"></i> Pay Now
                    </button>
                  </td>
                </tr>

                <tr class="border-b border-border hover:bg-gray-50 transition-colors">
                  <td class="py-4 px-6 font-semibold text-primary">BK456123</td>
                  <td class="py-4 px-6 font-medium text-gray-900">DG Rimbun - Standard Twin</td>
                  <td class="py-4 px-6 text-sm text-gray-600">
                    Nov 02, 2026 - Nov 04, 2026<br>
                    <span class="text-xs text-muted-foreground">2 Nights • 2 Guests</span>
                  </td>
                  <td class="py-4 px-6 font-bold text-lg text-primary">RM 290</td>
                  <td class="py-4 px-6">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 border border-green-200">
                      Confirmed
                    </span>
                  </td>
                  <td class="py-4 px-6">
                    <a href="invoice.jsp?id=BK456123" class="inline-flex items-center px-3 py-1.5 border border-primary text-primary hover:bg-primary hover:text-white rounded text-xs font-medium transition-colors">
                      <i class="fas fa-file-invoice mr-1"></i> View Invoice
                    </a>
                  </td>
                  <td class="py-4 px-6">
                    <button onclick="document.getElementById('rulesModal').classList.remove('hidden')" class="border border-gray-300 text-gray-700 hover:bg-gray-100 px-4 py-2 rounded-md text-sm font-medium transition-colors shadow-sm">
                      <i class="fas fa-info-circle mr-1"></i> Details
                    </button>
                  </td>
                </tr>

                <tr class="border-b border-border hover:bg-gray-50 transition-colors bg-gray-50/50">
                  <td class="py-4 px-6 font-semibold text-gray-500">BK112233</td>
                  <td class="py-4 px-6 font-medium text-gray-600">DG Rimbun - VIP Villa</td>
                  <td class="py-4 px-6 text-sm text-gray-500">
                    Jan 10, 2026 - Jan 12, 2026<br>
                    <span class="text-xs text-gray-400">2 Nights • 2 Guests</span>
                  </td>
                  <td class="py-4 px-6 font-bold text-lg text-gray-500">RM 650</td>
                  <td class="py-4 px-6">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 border border-blue-200">
                      Completed
                    </span>
                  </td>
                  <td class="py-4 px-6">
                    <a href="invoice.jsp?id=BK112233" class="inline-flex items-center px-3 py-1.5 border border-gray-300 text-gray-600 hover:bg-gray-200 rounded text-xs font-medium transition-colors">
                      <i class="fas fa-file-invoice mr-1"></i> Receipt
                    </a>
                  </td>
                  <td class="py-4 px-6">
                    <span class="text-sm text-gray-400 italic">Archived</span>
                  </td>
                </tr>

              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <div id="paymentModal" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[60] flex items-center justify-center p-4">
      <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full p-6 animate-[fadeIn_0.2s_ease-out]">
        <h2 class="text-2xl font-bold mb-2">Select Payment Method</h2>
        <p class="text-muted-foreground mb-6">Choose your preferred way to securely complete your reservation.</p>
        
        <div class="bg-primary/5 p-4 rounded-lg mb-6 border border-primary/20">
          <div class="flex justify-between items-center mb-2">
            <span class="text-sm text-gray-600">Booking ID:</span>
            <span class="font-bold">BK982341</span>
          </div>
          <div class="flex justify-between items-center border-t border-primary/10 pt-2 mt-2">
            <span class="font-bold text-gray-800">Total Amount:</span>
            <span class="text-2xl font-bold text-primary">RM 800</span>
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          <div onclick="processPayment('FPX')" class="border-2 border-border hover:border-primary rounded-xl p-6 text-center cursor-pointer transition-all hover:shadow-md">
            <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-4">
              <i class="fas fa-university text-2xl text-primary"></i>
            </div>
            <h3 class="font-bold text-lg">FPX Banking</h3>
            <p class="text-sm text-muted-foreground">Secure online transfer</p>
          </div>

          <div onclick="processPayment('QR')" class="border-2 border-border hover:border-primary rounded-xl p-6 text-center cursor-pointer transition-all hover:shadow-md">
            <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-4">
              <i class="fas fa-qrcode text-2xl text-primary"></i>
            </div>
            <h3 class="font-bold text-lg">QR Pay</h3>
            <p class="text-sm text-muted-foreground">Scan with any e-wallet</p>
          </div>
        </div>

        <div class="text-center">
          <button onclick="closeModal('paymentModal')" class="text-gray-500 hover:text-gray-800 font-medium px-4 py-2">
            Cancel
          </button>
        </div>
      </div>
    </div>

    <div id="loadingModal" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[70] flex items-center justify-center p-4">
      <div class="bg-white rounded-xl shadow-2xl p-8 max-w-sm w-full text-center">
        <div class="w-16 h-16 border-4 border-gray-200 border-t-primary rounded-full animate-spin mx-auto mb-6"></div>
        <h2 class="text-2xl font-bold text-gray-800 mb-2">Processing...</h2>
        <p class="text-muted-foreground">Securely confirming your transaction with the bank.</p>
      </div>
    </div>

    <div id="successModal" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[80] flex items-center justify-center p-4">
      <div class="bg-white rounded-xl shadow-2xl p-8 max-w-sm w-full text-center transform scale-100 transition-transform">
        <div class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6 shadow-inner">
          <i class="fas fa-check text-4xl text-green-600"></i>
        </div>
        <h2 class="text-3xl font-bold text-gray-800 mb-2">Success!</h2>
        <p class="text-muted-foreground mb-8">Your payment has been received and your booking is now Confirmed.</p>
        
        <form action="ConfirmPaymentServlet" method="POST" class="m-0">
            <input type="hidden" name="bookingId" value="BK982341">
            <button type="submit" class="w-full bg-primary hover:bg-primary/90 text-white font-bold py-3 rounded-lg shadow-md transition-colors">
              Awesome, Take Me Back!
            </button>
        </form>
      </div>
    </div>

    <div id="rulesModal" class="hidden fixed inset-0 bg-black/60 backdrop-blur-sm z-[60] flex items-center justify-center p-4">
      <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-border p-6 flex justify-between items-center">
          <h2 class="text-2xl font-bold text-gray-800">Booking Details & Rules</h2>
          <button onclick="closeModal('rulesModal')" class="text-gray-400 hover:text-gray-800">
            <i class="fas fa-times text-xl"></i>
          </button>
        </div>
        
        <div class="p-6 space-y-6">
          <div class="bg-green-50 border border-green-200 rounded-lg p-4 flex gap-4">
            <i class="fas fa-key text-green-600 text-2xl mt-1"></i>
            <div>
              <h3 class="font-bold text-green-800 mb-1">Key Collection</h3>
              <p class="text-sm text-green-700">Keys can be collected at the Main Reception Office. Please bring your IC/Passport for verification.</p>
            </div>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div class="border border-border rounded-lg p-4 text-center">
              <p class="text-sm text-muted-foreground uppercase tracking-wider mb-1">Check-in</p>
              <p class="text-xl font-bold text-primary">3:00 PM</p>
            </div>
            <div class="border border-border rounded-lg p-4 text-center">
              <p class="text-sm text-muted-foreground uppercase tracking-wider mb-1">Check-out</p>
              <p class="text-xl font-bold text-red-500">12:00 PM</p>
            </div>
          </div>

          <div>
            <h3 class="font-bold text-gray-800 mb-3 border-b pb-2"><i class="fas fa-exclamation-triangle text-orange-500 mr-2"></i> House Rules</h3>
            <ul class="space-y-2 text-sm text-gray-600">
              <li><i class="fas fa-ban text-red-500 w-5"></i> Strictly No Smoking inside the chalet.</li>
              <li><i class="fas fa-paw text-red-500 w-5"></i> No Pets allowed.</li>
              <li><i class="fas fa-volume-mute text-blue-500 w-5"></i> Quiet hours begin at 10:00 PM.</li>
            </ul>
          </div>
        </div>
        
        <div class="p-6 border-t border-border bg-gray-50 text-right">
          <button onclick="closeModal('rulesModal')" class="bg-gray-800 hover:bg-gray-900 text-white px-6 py-2 rounded-md font-medium transition-colors">
            Got it
          </button>
        </div>
      </div>
    </div>

    <script>
      function openPaymentModal() {
        document.getElementById('paymentModal').classList.remove('hidden');
      }

      function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
      }

      // This function mimics the cool loading sequence from Figma
      function processPayment(method) {
        // 1. Close payment selection
        closeModal('paymentModal');
        
        // 2. Show Loading spinner
        const loader = document.getElementById('loadingModal');
        loader.classList.remove('hidden');

        // 3. Wait 2 seconds (simulating bank API call), then show Success
        setTimeout(() => {
          loader.classList.add('hidden');
          document.getElementById('successModal').classList.remove('hidden');
        }, 2000);
      }
    </script>
</body>
</html>