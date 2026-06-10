<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Homestays - DG Rimbun</title>
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
                        'muted-foreground': '#6b7280'
                    }
                }
            }
        }
    </script>
</head>
<body class="min-h-screen bg-gradient-to-b from-accent/10 to-white pt-20">

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

    <section class="relative h-[500px] overflow-hidden">
      <div class="absolute inset-0">
        <img
          src="https://images.unsplash.com/photo-1594130139005-3f0c0f0e7c5e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080"
          alt="Homestay"
          class="w-full h-full object-cover"
        />
        <div class="absolute inset-0 bg-black/50"></div>
      </div>

      <div class="relative z-10 h-full flex flex-col items-center justify-center px-4">
        <div class="text-center mb-8">
          <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-white mb-4">
            Find Your Perfect Escape
          </h1>
          <p class="text-lg md:text-xl text-white/90">
            Discover unique homestays in nature's embrace
          </p>
        </div>

        <div class="w-full max-w-5xl bg-white rounded-2xl shadow-2xl p-6 md:p-8">
          <form action="homestays.jsp" method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-4">
            
            <div>
              <label for="checkin" class="block text-sm font-medium text-muted-foreground mb-2">Check-in</label>
              <div class="relative">
                <i class="fas fa-calendar absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                <input
                  type="date"
                  id="checkin"
                  name="checkin"
                  value="<%= request.getParameter("checkin") != null ? request.getParameter("checkin") : "" %>"
                  class="w-full pl-10 pr-3 h-12 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                  required
                />
              </div>
            </div>

            <div>
              <label for="checkout" class="block text-sm font-medium text-muted-foreground mb-2">Check-out</label>
              <div class="relative">
                <i class="fas fa-calendar absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                <input
                  type="date"
                  id="checkout"
                  name="checkout"
                  value="<%= request.getParameter("checkout") != null ? request.getParameter("checkout") : "" %>"
                  class="w-full pl-10 pr-3 h-12 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                  required
                />
              </div>
            </div>

            <div>
              <label for="pax" class="block text-sm font-medium text-muted-foreground mb-2">Number of Pax</label>
              <div class="relative">
                <i class="fas fa-users absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                <input
                  type="number"
                  id="pax"
                  name="pax"
                  min="1"
                  placeholder="2"
                  value="<%= request.getParameter("pax") != null ? request.getParameter("pax") : "2" %>"
                  class="w-full pl-10 pr-3 h-12 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                  required
                />
              </div>
            </div>

            <div class="flex items-end">
              <button type="submit" class="w-full h-12 bg-primary hover:bg-primary/90 text-white rounded-md font-semibold text-base transition-colors shadow-sm">
                <i class="fas fa-search mr-2"></i> Check Availability
              </button>
            </div>
          </form>

          <% if (request.getParameter("checkin") != null) { %>
            <div class="mt-4 text-center">
              <a href="homestays.jsp" class="inline-block text-primary hover:text-primary/80 font-medium p-2">
                Clear Search & View All Homestays
              </a>
            </div>
          <% } %>
        </div>
      </div>
    </section>

    <section class="container mx-auto px-4 py-16">
      
      <div class="mb-8">
        <h2 class="text-3xl font-bold mb-2">
          <%= request.getParameter("checkin") != null ? "Available Homestays" : "All Homestays" %>
        </h2>
        <% if (request.getParameter("checkin") != null) { %>
          <p class="text-muted-foreground">
            Showing results for <%= request.getParameter("pax") %> guests from <%= request.getParameter("checkin") %> to <%= request.getParameter("checkout") %>
          </p>
        <% } %>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        
        <div class="bg-white rounded-xl overflow-hidden hover:shadow-2xl transition-all duration-300 group border border-border shadow-lg cursor-pointer" onclick="window.location.href='homestayDetails.jsp?id=1'">
          <div class="relative h-72 overflow-hidden">
            <img src="