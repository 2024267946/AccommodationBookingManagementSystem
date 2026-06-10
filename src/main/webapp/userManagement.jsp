<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management - DG Rimbun</title>
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
<body class="bg-accent/10">
    <div class="flex min-h-screen">
      
      <aside class="w-64 bg-white border-r border-border flex flex-col hidden md:flex shadow-sm">
        <div class="h-16 flex items-center px-6 border-b border-border">
          <span class="text-xl font-bold text-primary">DG Rimbun Admin</span>
        </div>
        <nav class="flex-1 py-4 px-3 space-y-1">
          <a href="dashboard.jsp" class="text-gray-700 hover:bg-gray-50 flex items-center px-3 py-2 rounded-md font-medium transition-colors">
            <i class="fas fa-home w-6 text-center mr-2"></i> Dashboard
          </a>
          <a href="#" class="text-gray-700 hover:bg-gray-50 flex items-center px-3 py-2 rounded-md font-medium transition-colors">
            <i class="fas fa-calendar-alt w-6 text-center mr-2"></i> Bookings
          </a>
          <a href="manageHomestays.jsp" class="text-gray-700 hover:bg-gray-50 flex items-center px-3 py-2 rounded-md font-medium transition-colors">
            <i class="fas fa-building w-6 text-center mr-2"></i> Chalet Units
          </a>
          <a href="userManagement.jsp" class="bg-primary/10 text-primary flex items-center px-3 py-2 rounded-md font-medium">
            <i class="fas fa-users w-6 text-center mr-2"></i> Guests
          </a>
        </nav>
        <div class="p-4 border-t border-border">
          <form action="LogoutServlet" method="POST">
             <button type="submit" class="w-full flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 transition-colors">
               <i class="fas fa-sign-out-alt mr-2"></i> Logout
             </button>
          </form>
        </div>
      </aside>

      <main class="flex-1 p-8 overflow-y-auto">
        <div class="max-w-7xl mx-auto">
          
          <div class="mb-8">
            <h1 class="text-3xl font-bold mb-4">User Management</h1>
          </div>

          <div class="mb-6 bg-primary/5 border-2 border-primary rounded-xl shadow-sm overflow-hidden">
            <div class="p-6">
              <form action="userManagement.jsp" method="GET" class="flex items-center gap-4">
                <label class="text-base font-semibold whitespace-nowrap">Search User:</label>
                <div class="relative flex-1 max-w-2xl">
                  <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-primary"></i>
                  <input
                    type="text"
                    name="query"
                    placeholder="Enter name, email, or phone number to search..."
                    value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>"
                    class="w-full pl-12 pr-4 h-14 text-lg border-2 border-primary rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50 font-medium"
                  />
                </div>
                <button
                  type="submit"
                  class="bg-primary hover:bg-primary/90 text-white px-6 h-14 rounded-md font-medium transition-colors shadow-sm"
                >
                  Search
                </button>
                <% if (request.getParameter("query") != null && !request.getParameter("query").isEmpty()) { %>
                    <a href="userManagement.jsp" class="inline-flex items-center justify-center border border-border bg-white text-gray-700 px-6 h-14 rounded-md font-medium hover:bg-gray-50 transition-colors">
                      Clear
                    </a>
                <% } %>
              </form>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-md border border-border overflow-hidden">
            <div class="bg-gradient-to-r from-primary/5 to-transparent border-b border-border p-6">
              <h2 class="text-xl font-bold">Registered Users</h2>
            </div>
            
            <div class="p-0 overflow-x-auto">
              <table class="w-full">
                <thead class="bg-gray-50">
                  <tr class="border-b border-border">
                    <th class="text-left py-4 px-6 font-medium text-muted-foreground text-sm">Name</th>
                    <th class="text-left py-4 px-6 font-medium text-muted-foreground text-sm">Role</th>
                    <th class="text-left py-4 px-6 font-medium text-muted-foreground text-sm">Email</th>
                    <th class="text-left py-4 px-6 font-medium text-muted-foreground text-sm">Phone</th>
                    <th class="text-left py-4 px-6 font-medium text-muted-foreground text-sm">Active Booking</th>
                    <th class="text-left py-4 px-6 font-medium text-muted-foreground text-sm">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  
                  <tr class="border-b border-border hover:bg-accent/30 transition-colors">
                    <td class="py-4 px-6 font-medium">Alysa Binti Ali</td>
                    <td class="py-4 px-6">
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border border-gray-200 text-gray-800">
                        Guest
                      </span>
                    </td>
                    <td class="py-4 px-6 text-sm text-muted-foreground">Alysa@email.com</td>
                    <td class="py-4 px-6 text-sm text-muted-foreground">+6012-345-6789</td>
                    <td class="py-4 px-6">
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 border border-green-200">
                        Active
                      </span>
                    </td>
                    <td class="py-4 px-6">
                      <form action="DeleteUserServlet" method="POST" class="m-0" onsubmit="return confirm('Are you sure you want to delete this user?');">
                        <input type="hidden" name="userId" value="1">
                        <button type="submit" class="text-sm font-medium text-destructive hover:bg-destructive/10 px-3 py-1.5 rounded transition-colors">
                          Delete
                        </button>
                      </form>
                    </td>
                  </tr>

                  <tr class="border-b border-border hover:bg-accent/30 transition-colors">
                    <td class="py-4 px-6 font-medium">Encik Ridzuan</td>
                    <td class="py-4 px-6">
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800 border border-purple-200">
                        Owner
                      </span>
                    </td>
                    <td class="py-4 px-6 text-sm text-muted-foreground">admin@dgrimbun.com</td>
                    <td class="py-4 px-6 text-sm text-muted-foreground">+6019-876-5432</td>
                    <td class="py-4 px-6">
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border border-gray-200 text-gray-500">
                        None
                      </span>
                    </td>
                    <td class="py-4 px-6">
                      <span class="text-sm text-muted-foreground italic">Restricted</span>
                    </td>
                  </tr>