<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Homestay Details - DG Rimbun</title>
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
</head>
<body class="min-h-screen bg-gray-50 pt-20">

    <!-- Navigation Bar -->
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
              <a href="homestays.jsp" class="flex items-center gap-2 text-[#859f8a] font-medium transition-colors">
                <i class="fas fa-bed text-lg"></i> Homestays
              </a>
            </div>
            <div class="flex items-center space-x-6">
              <% if (session.getAttribute("currentUser") != null) { %>
                  <a href="dashboard.jsp" class="flex items-center gap-2 text-gray-700 hover:text-[#859f8a] font-medium transition-colors">
                      <i class="fas fa-border-all text-lg"></i> Dashboard
                  </a>
                  <form action="LogoutServlet" method="POST" class="m-0">
                      <button type="submit" class="flex items-center gap-2 bg-red-50 text-red-600 hover:bg-red-100 px-5 py-2.5 rounded-md font-medium transition-colors">
                          <i class="fas fa-sign-out-alt text-lg"></i> Logout
                      </button>
                  </form>
              <% } else { %>
                  <a href="login.jsp" class="flex items-center gap-2 text-gray-700 hover:text-[#859f8a] font-medium transition-colors">
                      <i class="fas fa-sign-in-alt text-lg"></i> Login
                  </a>
                  <a href="register.jsp" class="flex items-center gap-2 bg-[#859f8a] hover:bg-[#7fa99b] text-white px-5 py-2.5 rounded-md font-medium transition-colors shadow-sm">
                      <i class="fas fa-user-plus text-lg"></i> Register
                  </a>
              <% } %>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <div class="container mx-auto px-4 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <!-- Left Side - Image Gallery and Info -->
        <div class="lg:col-span-2 space-y-6">
          
          <!-- Image -->
          <div class="rounded-xl overflow-hidden h-96 shadow-md border border-border">
            <img src="https://images.unsplash.com/photo-1542718144-667d4022a426?w=1200&q=80" alt="Family Suite" class="w-full h-full object-cover" />
          </div>

          <!-- Homestay Info Card -->
          <div class="bg-white rounded-xl shadow-md border border-border p-6">
            <div class="flex items-start justify-between mb-4">
              <div>
                <h1 class="text-3xl font-bold mb-2">DG Rimbun - Family Suite</h1>
                <div class="flex items-center gap-4 text-muted-foreground">
                  <div class="flex items-center gap-1">
                    <i class="fas fa-map-marker-alt"></i>
                    <span class="text-sm">Jasin, Melaka</span>
                  </div>
                  <div class="flex items-center gap-1">
                    <i class="fas fa-star text-yellow-400"></i>
                    <span class="text-sm font-semibold text-gray-700">4.9 (128 reviews)</span>
                  </div>
                </div>
              </div>
            </div>

            <p class="text-muted-foreground mb-6 leading-relaxed">
              Experience the perfect blend of modern comfort and natural serenity in our Family Suite. Nestled amidst lush greenery, this spacious chalet offers breathtaking views, premium bedding, and a private balcony perfect for morning coffee or evening stargazing. Ideal for families seeking a peaceful retreat away from the city hustle.
            </p>

            <div class="border-t border-border pt-6">
              <h3 class="font-semibold mb-4 flex items-center gap-2 text-lg">
                <i class="fas fa-users text-primary"></i>
                Maximum Capacity: 6 Guests
              </h3>
            </div>

            <!-- Amenities -->
            <div class="border-t border-border pt-6 mt-6">
              <h3 class="font-semibold mb-4 text-lg">Amenities</h3>
              <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                    <i class="fas fa-wifi"></i>
                  </div>
                  <span class="font-medium text-gray-700">Fast WiFi</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                    <i class="fas fa-snowflake"></i>
                  </div>
                  <span class="font-medium text-gray-700">Air Conditioning</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                    <i class="fas fa-car"></i>
                  </div>
                  <span class="font-medium text-gray-700">Free Parking</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                    <i class="fas fa-tv"></i>
                  </div>
                  <span class="font-medium text-gray-700">Smart TV</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Side - Booking Form Card -->
        <div class="lg:col-span-1">
          <div class="bg-white rounded-xl shadow-xl border border-border sticky top-24 overflow-hidden">
            <div class="p-6">
              
              <div class="mb-6 pb-6 border-b border-border">
                <div class="flex items-baseline gap-2 mb-2">
                  <span class="text-4xl font-bold text-primary">RM250</span>
                  <span class="text-muted-foreground font-medium">/ night</span>
                </div>
              </div>

              <!-- Form submits to BookingServlet (Alysa's component) -->
              <form action="BookingServlet" method="POST" class="space-y-5">
                
                <input type="hidden" name="homestayId" value="1">
                <input type="hidden" name="pricePerNight" id="pricePerNight" value="250">

                <!-- Dates -->
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label for="checkIn" class="block text-sm font-medium text-gray-700 mb-1">Check-in</label>
                    <div class="relative">
                      <i class="fas fa-calendar-alt absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                      <input
                        type="date"
                        id="checkIn"
                        name="checkIn"
                        value="<%= request.getParameter("checkin") != null ? request.getParameter("checkin") : "" %>"
                        onchange="calculateTotal()"
                        class="w-full pl-10 pr-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50 text-sm"
                        required
                      />
                    </div>
                  </div>
                  <div>
                    <label for="checkOut" class="block text-sm font-medium text-gray-700 mb-1">Check-out</label>
                    <div class="relative">
                      <i class="fas fa-calendar-alt absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                      <input
                        type="date"
                        id="checkOut"
                        name="checkOut"
                        value="<%= request.getParameter("checkout") != null ? request.getParameter("checkout") : "" %>"
                        onchange="calculateTotal()"
                        class="w-full pl-10 pr-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50 text-sm"
                        required
                      />
                    </div>
                  </div>
                </div>

                <!-- Guests -->
                <div>
                  <label for="guests" class="block text-sm font-medium text-gray-700 mb-1">Guests</label>
                  <div class="relative">
                    <i class="fas fa-users absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                    <input
                      type="number"
                      id="guests"
                      name="guests"
                      min="1"
                      max="6"
                      value="<%= request.getParameter("pax") != null ? request.getParameter("pax") : "2" %>"
                      class="w-full pl-10 pr-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                      required
                    />
                  </div>
                </div>

                <div class="border-t border-border pt-4 mt-2">
                  <h4 class="font-semibold mb-3 text-sm text-gray-800">Guest Details</h4>
                </div>

                <!-- Guest Name -->
                <div>
                  <label for="guestName" class="block text-sm font-medium text-gray-700 mb-1">Full Name *</label>
                  <input
                    type="text"
                    id="guestName"
                    name="guestName"
                    placeholder="Enter your full name"
                    class="w-full px-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                    required
                  />
                </div>

                <!-- Phone Number -->
                <div>
                  <label for="guestPhone" class="block text-sm font-medium text-gray-700 mb-1">Phone Number *</label>
                  <input
                    type="tel"
                    id="guestPhone"
                    name="guestPhone"
                    placeholder="+60 12-345 6789"
                    class="w-full px-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                    required
                  />
                </div>

                <!-- Special Requests -->
                <div>
                  <label for="specialRequests" class="block text-sm font-medium text-gray-700 mb-1">Special Requests</label>
                  <textarea
                    id="specialRequests"
                    name="specialRequests"
                    placeholder="Any special requirements..."
                    rows="2"
                    class="w-full px-3 py-2 border border-border rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-primary/50"
                  ></textarea>
                </div>

                <!-- Dynamic Pricing Summary (Hidden by default, shown by JS when dates are picked) -->
                <div id="summarySection" class="hidden p-4 rounded-lg border bg-accent/10 mt-4">
                  <h4 class="font-semibold mb-3 text-gray-800 text-sm">Booking Summary</h4>
                  <div class="space-y-2 text-sm text-gray-600">
                    <div class="flex justify-between">
                      <span>RM250 × <span id="nightsDisplay">0</span> nights</span>
                      <span class="font-medium text-gray-800">RM<span id="roomTotal">0</span></span>
                    </div>
                    <div class="flex justify-between">
                      <span>Cleaning fee</span>
                      <span class="font-medium text-gray-800">RM50</span>
                    </div>
                    <div class="flex justify-between font-bold text-base pt-3 mt-3 border-t border-border/50 text-gray-900">
                      <span>Total</span>
                      <span class="text-primary">RM<span id="grandTotal">0</span></span>
                    </div>
                  </div>
                  <!-- Hidden input to pass the final total to the Java Servlet -->
                  <input type="hidden" name="totalAmount" id="hiddenTotalAmount" value="0">
                </div>

                <button type="submit" class="w-full bg-primary hover:bg-primary/90 text-white font-semibold py-3 rounded-md transition-colors shadow-sm mt-4">
                  Confirm Booking
                </button>
                <p class="text-center text-xs text-muted-foreground mt-3">You won't be charged yet</p>
                
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- JavaScript to handle dynamic price calculations -->
    <script>
      function calculateTotal() {
        const checkIn = document.getElementById('checkIn').value;
        const checkOut = document.getElementById('checkOut').value;
        const summary = document.getElementById('summarySection');
        
        if(checkIn && checkOut) {
            const start = new Date(checkIn);
            const end = new Date(checkOut);
            
            // Calculate difference in days
            const diffTime = end.getTime() - start.getTime();
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            
            if(diffDays > 0) {
                const pricePerNight = 250;
                const cleaningFee = 50;
                
                const roomCharge = diffDays * pricePerNight;
                const total = roomCharge + cleaningFee;
                
                // Update UI text
                document.getElementById('nightsDisplay').innerText = diffDays;
                document.getElementById('roomTotal').innerText = roomCharge;
                document.getElementById('grandTotal').innerText = total;
                
                // Update hidden input for Java backend
                document.getElementById('hiddenTotalAmount').value = total;
                
                // Show the summary box
                summary.classList.remove('hidden');
            } else {
                summary.classList.add('hidden');
            }
        } else {
            summary.classList.add('hidden');
        }
      }

      // Run calculation immediately on page load in case dates were passed via URL
      window.onload = function() {
          calculateTotal();
      };
    </script>
</body>
</html>