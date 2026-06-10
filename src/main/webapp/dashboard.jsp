<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - DG Rimbun</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
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
<body class="bg-accent/10">
    <div class="flex min-h-screen">
      
      <aside class="w-64 bg-white border-r border-border flex flex-col hidden md:flex shadow-sm">
        <div class="h-16 flex items-center px-6 border-b border-border">
          <span class="text-xl font-bold text-primary">DG Rimbun Admin</span>
        </div>
        <nav class="flex-1 py-4 px-3 space-y-1">
          <a href="dashboard.jsp" class="bg-primary/10 text-primary flex items-center px-3 py-2 rounded-md font-medium">
            <i class="fas fa-home w-6 text-center mr-2"></i> Dashboard
          </a>
          <a href="#" class="text-gray-700 hover:bg-gray-50 flex items-center px-3 py-2 rounded-md font-medium transition-colors">
            <i class="fas fa-calendar-alt w-6 text-center mr-2"></i> Bookings
          </a>
          <a href="#" class="text-gray-700 hover:bg-gray-50 flex items-center px-3 py-2 rounded-md font-medium transition-colors">
            <i class="fas fa-building w-6 text-center mr-2"></i> Chalet Units
          </a>
          <a href="#" class="text-gray-700 hover:bg-gray-50 flex items-center px-3 py-2 rounded-md font-medium transition-colors">
            <i class="fas fa-users w-6 text-center mr-2"></i> Guests
          </a>
        </nav>
        <div class="p-4 border-t border-border">
          <form action="LogoutServlet" method="POST">
             <button type="submit" class="w-full flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700">
               <i class="fas fa-sign-out-alt mr-2"></i> Logout
             </button>
          </form>
        </div>
      </aside>

      <main class="flex-1 p-8 overflow-y-auto">
        <div class="max-w-7xl mx-auto">
          
          <div class="mb-8">
            <h1 class="text-3xl font-bold mb-2">Dashboard Overview</h1>
            <p class="text-muted-foreground">
              Welcome back, <%= session.getAttribute("currentUser") != null ? ((model.User)session.getAttribute("currentUser")).getName() : "Encik Ridzuan" %>! Here's what's happening with your 100 homestays.
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            
            <div class="bg-white rounded-xl border-l-4 border-l-primary shadow-lg p-6">
              <div class="flex items-center justify-between pb-3">
                <h3 class="text-sm font-medium text-muted-foreground">Total Bookings</h3>
                <i class="fas fa-calendar text-primary text-xl"></i>
              </div>
              <div class="text-4xl font-bold mb-1">1,284</div>
              <p class="text-xs text-muted-foreground">All time bookings</p>
            </div>

            <div class="bg-white rounded-xl border-l-4 border-l-yellow-500 shadow-lg p-6">
              <div class="flex items-center justify-between pb-3">
                <h3 class="text-sm font-medium text-muted-foreground">Pending Bookings</h3>
                <i class="fas fa-clock text-yellow-500 text-xl"></i>
              </div>
              <div class="text-4xl font-bold mb-1">42</div>
              <p class="text-xs text-muted-foreground">Awaiting verification</p>
            </div>

            <div class="bg-white rounded-xl border-l-4 border-l-green-500 shadow-lg p-6">
              <div class="flex items-center justify-between pb-3">
                <h3 class="text-sm font-medium text-muted-foreground">Confirmed Bookings</h3>
                <i class="fas fa-check-circle text-green-500 text-xl"></i>
              </div>
              <div class="text-4xl font-bold mb-1">86</div>
              <p class="text-xs text-muted-foreground">Active bookings</p>
            </div>

            <div class="bg-white rounded-xl border-l-4 border-l-red-500 shadow-lg p-6">
              <div class="flex items-center justify-between pb-3">
                <h3 class="text-sm font-medium text-muted-foreground">Cancelled Bookings</h3>
                <i class="fas fa-times-circle text-red-500 text-xl"></i>
              </div>
              <div class="text-4xl font-bold mb-1">12</div>
              <p class="text-xs text-muted-foreground">Total cancellations</p>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-lg mb-8 border border-border">
            <div class="bg-gradient-to-r from-primary/5 to-transparent border-b border-border p-6 rounded-t-xl">
              <h2 class="text-xl font-bold">Booking Trends (Last 30 Days)</h2>
            </div>
            <div class="p-6">
              <div class="relative h-80 w-full">
                <canvas id="trendsChart"></canvas>
              </div>
            </div>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            
            <div class="bg-white rounded-xl shadow-lg border border-border">
              <div class="bg-gradient-to-r from-primary/5 to-transparent border-b border-border p-6 rounded-t-xl">
                <h2 class="text-xl font-bold">Popular Chalet Types</h2>
              </div>
              <div class="p-6">
                <div class="relative h-80 w-full">
                  <canvas id="popularRoomsChart"></canvas>
                </div>
              </div>
            </div>

            <div class="bg-white rounded-xl shadow-lg border border-border">
              <div class="bg-gradient-to-r from-primary/5 to-transparent border-b border-border p-6 rounded-t-xl">
                <h2 class="text-xl font-bold">Status Distribution</h2>
              </div>
              <div class="p-6 flex justify-center">
                <div class="relative h-80 w-full flex justify-center">
                  <canvas id="statusChart"></canvas>
                </div>
              </div>
            </div>

          </div>
        </div>
      </main>
    </div>

    <script>
      // 1. Line Chart (Booking Trends)
      const ctxTrends = document.getElementById('trendsChart').getContext('2d');
      new Chart(ctxTrends, {
          type: 'line',
          data: {
              labels: ['May 1', 'May 5', 'May 10', 'May 15', 'May 20', 'May 25', 'May 30'],
              datasets: [{
                  label: 'Bookings',
                  data: [12, 19, 15, 25, 22, 30, 28],
                  borderColor: '#16a34a',
                  backgroundColor: 'rgba(22, 163, 74, 0.1)',
                  borderWidth: 3,
                  fill: true,
                  tension: 0.4
              }]
          },
          options: { responsive: true, maintainAspectRatio: false }
      });

      // 2. Bar Chart (Popular Rooms)
      const ctxPopular = document.getElementById('popularRoomsChart').getContext('2d');
      new Chart(ctxPopular, {
          type: 'bar',
          data: {
              labels: ['Family Suite', 'Twin Chalet', 'Standard Room', 'VIP Villa', 'Dormitory'],
              datasets: [{
                  label: 'Total Bookings',
                  data: [85, 62, 110, 34, 45],
                  backgroundColor: '#7fa99b',
                  borderRadius: 6
              }]
          },
          options: { responsive: true, maintainAspectRatio: false }
      });

      // 3. Pie Chart (Status Distribution)
      const ctxStatus = document.getElementById('statusChart').getContext('2d');
      new Chart(ctxStatus, {
          type: 'doughnut',
          data: {
              labels: ['Confirmed', 'Pending', 'Cancelled', 'Completed'],
              datasets: [{
                  data: [86, 42, 12, 145],
                  backgroundColor: ['#10b981', '#f59e0b', '#ef4444', '#3b82f6'],
                  borderWidth: 0
              }]
          },
          options: { responsive: true, maintainAspectRatio: false, cutout: '65%' }
      });
    </script>
</body>
</html>