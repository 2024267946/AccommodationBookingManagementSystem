<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - DG Rimbun</title>
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
              <a href="profile.jsp" class="font-medium text-primary border-b-2 border-primary pb-1">
                Welcome, <%= session.getAttribute("currentUser") != null ? ((model.User)session.getAttribute("currentUser")).getName() : "Guest" %>!
              </a>
              <form action="LogoutServlet" method="POST" class="m-0">
                  <button type="submit" class="flex items-center gap-2 bg-red-50 text-red-600 hover:bg-red-100 px-5 py-2.5 rounded-md font-medium transition-colors">
                      <i class="fas fa-sign-out-alt"></i> Logout
                  </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <div class="container mx-auto px-4 py-16">
      <div class="max-w-4xl mx-auto">
        
        <h1 class="text-4xl font-bold mb-8 text-gray-900">Account</h1>

        <div class="flex gap-2 mb-6 border-b border-border">
          <div class="px-6 py-3 font-medium text-primary relative">
            <div class="flex items-center gap-2">
              <i class="fas fa-user"></i> My Profile
            </div>
            <div class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary"></div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow-lg border border-border overflow-hidden">
          <div class="bg-gradient-to-r from-primary/5 to-transparent border-b border-border p-6">
            <h2 class="text-xl font-bold text-gray-900">Personal Information</h2>
          </div>
          
          <div class="p-8">
            <div class="space-y-6">
              
              <div class="space-y-2">
                <label class="text-sm font-medium text-gray-700">Full Name</label>
                <div class="relative">
                  <i class="fas fa-user absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                  <input
                    type="text"
                    value="Alysa Binti Ali"
                    class="w-full pl-12 pr-4 py-3 bg-gray-50 border border-border rounded-md text-gray-700 cursor-not-allowed"
                    disabled
                  />
                </div>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-medium text-gray-700">Email Address</label>
                <div class="relative">
                  <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                  <input
                    type="email"
                    value="Alysa@email.com"
                    class="w-full pl-12 pr-4 py-3 bg-gray-50 border border-border rounded-md text-gray-700 cursor-not-allowed"
                    disabled
                  />
                </div>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-medium text-gray-700">Phone Number</label>
                <div class="relative">
                  <i class="fas fa-phone absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                  <input
                    type="tel"
                    value="+60 12-345 6789"
                    class="w-full pl-12 pr-4 py-3 bg-gray-50 border border-border rounded-md text-gray-700 cursor-not-allowed"
                    disabled
                  />
                </div>
              </div>

              <div class="pt-6 border-t border-border">
                <a href="editAccount.jsp" class="inline-flex items-center justify-center bg-primary hover:bg-primary/90 text-white font-medium px-6 py-3 rounded-md transition-colors shadow-sm gap-2">
                  <i class="fas fa-edit"></i> Edit Account
                </a>
              </div>

            </div>
          </div>
        </div>

      </div>
    </div>
</body>
</html>