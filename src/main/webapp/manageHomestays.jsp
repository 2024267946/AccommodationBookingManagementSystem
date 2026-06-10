<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Homestays - DG Rimbun</title>
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
      
      <!-- Admin Sidebar -->
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
          <a href="manageHomestays.jsp" class="bg-primary/10 text-primary flex items-center px-3 py-2 rounded-md font-medium">
            <i class="fas fa-building w-6 text-center mr-2"></i> Chalet Units
          </a>
          <a href="userManagement.jsp" class="text-gray-700 hover:bg-gray-50 flex items-center px-3 py-2 rounded-md font-medium transition-colors">
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

      <!-- Main Content -->
      <main class="flex-1 p-8 overflow-y-auto">
        <div class="max-w-7xl mx-auto">
          
          <!-- Header -->
          <div class="flex justify-between items-center mb-8">
            <div>
              <h1 class="text-3xl font-bold mb-2">Manage Chalet Units</h1>
              <p class="text-muted-foreground">Create, update, and manage the 100 properties in your network</p>
            </div>
            <!-- Create Button navigates to the edit/create page -->
            <a href="editHomestay.jsp" class="inline-flex items-center justify-center bg-primary hover:bg-primary/90 text-white px-4 py-2 rounded-md font-medium transition-colors shadow-sm gap-2">
              <i class="fas fa-plus"></i> Add New Unit
            </a>
          </div>

          <!-- Homestays List -->
          <div class="grid gap-6">
            
            <!-- Mockup Item 1 (Replace with JSP loop later) -->
            <div class="bg-white rounded-xl shadow-md hover:shadow-lg transition-shadow border border-border">
              <div class="p-6">
                <div class="flex flex-col md:flex-row gap-6">
                  
                  <!-- Image -->
                  <div class="w-full md:w-48 h-48 md:h-32 rounded-lg overflow-hidden flex-shrink-0">
                    <img src="https://images.unsplash.com/photo-1542718144-667d4022a426?w=800&q=80" alt="Chalet A" class="w-full h-full object-cover" />
                  </div>

                  <!-- Details -->
                  <div class="flex-1">
                    <h3 class="text-xl font-semibold mb-2">DG Rimbun - Family Suite</h3>
                    <p class="text-muted-foreground text-sm mb-3 line-clamp-2">
                      A spacious suite perfect for larger families, featuring beautiful views of the surrounding nature reserve and modern amenities.
                    </p>
                    <div class="flex gap-6 text-sm mb-2">
                      <div>
                        <span class="text-muted-foreground">Price:</span> 
                        <span class="font-semibold text-primary">RM 250/night</span>
                      </div>
                      <div>
                        <span class="text-muted-foreground">Capacity:</span> 
                        <span class="font-semibold">6 Pax</span>
                      </div>
                    </div>
                    <div class="text-sm">
                      <span class="text-muted-foreground">Amenities:</span> 
                      <span class="font-medium bg-gray-100 px-2 py-1 rounded text-xs ml-1">WiFi</span>
                      <span class="font-medium bg-gray-100 px-2 py-1 rounded text-xs ml-1">Air Conditioning</span>
                      <span class="font-medium bg-gray-100 px-2 py-1 rounded text-xs ml-1">BBQ Pit</span>
                    </div>
                  </div>

                  <!-- Action Buttons -->
                  <div class="flex flex-row md:flex-col gap-2 justify-center mt-4 md:mt-0 border-t md:border-t-0 md:border-l border-border pt-4 md:pt-0 md:pl-4">
                    
                    <!-- Edit Button -->
                    <a href="editHomestay.jsp?id=1" class="flex-1 md:flex-none inline-flex items-center justify-center px-4 py-2 border border-border rounded-md text-sm font-medium text-gray-700 hover:bg-primary hover:text-white hover:border-primary transition-colors gap-2">
                      <i class="fas fa-edit"></i> Edit
                    </a>
                    
                    <!-- Date Button -->
                    <button class="flex-1 md:flex-none inline-flex items-center justify-center px-4 py-2 border border-border rounded-md text-sm font-medium text-gray-700 hover:bg-primary hover:text-white hover:border-primary transition-colors gap-2">
                      <i class="fas fa-calendar-alt"></i> Dates
                    </button>

                    <!-- Delete Form (Submits to Servlet) -->
                    <form action="DeleteHomestayServlet" method="POST" class="flex-1 md:flex-none m-0" onsubmit="return confirm('Are you sure you want to delete this unit?');">
                      <input type="hidden" name="homestayId" value="1">
                      <button type="submit" class="w-full inline-flex items-center justify-center px-4 py-2 border border-destructive text-destructive rounded-md text-sm font-medium hover:bg-destructive hover:text-white transition-colors gap-2">
                        <i class="fas fa-trash-alt"></i> Delete
                      </button>
                    </form>

                  </div>
                </div>
              </div>
            </div>

            <!-- Mockup Item 2 -->
            <div class="bg-white rounded-xl shadow-md hover:shadow-lg transition-shadow border border-border">
              <div class="p-6">
                <div class="flex flex-col md:flex-row gap-6">
                  
                  <div class="w-full md:w-48 h-48 md:h-32 rounded-lg overflow-hidden flex-shrink-0">
                    <img src="https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&q=80" alt="Chalet B" class="w-full h-full object-cover" />
                  </div>

                  <div class="flex-1">
                    <h3 class="text-xl font-semibold mb-2">DG Rimbun - Standard Twin</h3>
                    <p class="text-muted-foreground text-sm mb-3 line-clamp-2">
                      Cozy and comfortable twin room ideal for couples or solo travelers looking for a peaceful getaway.
                    </p>
                    <div class="flex gap-6 text-sm mb-2">
                      <div>
                        <span class="text-muted-foreground">Price:</span> 
                        <span class="font-semibold text-primary">RM 120/night</span>
                      </div>
                      <div>
                        <span class="text-muted-foreground">Capacity:</span> 
                        <span class="font-semibold">2 Pax</span>
                      </div>
                    </div>
                    <div class="text-sm">
                      <span class="text-muted-foreground">Amenities:</span> 
                      <span class="font-medium bg-gray-100 px-2 py-1 rounded text-xs ml-1">Air Conditioning</span>
                      <span class="font-medium bg-gray-100 px-2 py-1 rounded text-xs ml-1">Free Parking</span>
                    </div>
                  </div>

                  <div class="flex flex-row md:flex-col gap-2 justify-center mt-4 md:mt-0 border-t md:border-t-0 md:border-l border-border pt-4 md:pt-0 md:pl-4">
                    <a href="editHomestay.jsp?id=2" class="flex-1 md:flex-none inline-flex items-center justify-center px-4 py-2 border border-border rounded-md text-sm font-medium text-gray-700 hover:bg-primary hover:text-white hover:border-primary transition-colors gap-2">
                      <i class="fas fa-edit"></i> Edit
                    </a>
                    <button class="flex-1 md:flex-none inline-flex items-center justify-center px-4 py-2 border border-border rounded-md text-sm font-medium text-gray-700 hover:bg-primary hover:text-white hover:border-primary transition-colors gap-2">
                      <i class="fas fa-calendar-alt"></i> Dates
                    </button>
                    <form action="DeleteHomestayServlet" method="POST" class="flex-1 md:flex-none m-0" onsubmit="return confirm('Are you sure you want to delete this unit?');">
                      <input type="hidden" name="homestayId" value="2">
                      <button type="submit" class="w-full inline-flex items-center justify-center px-4 py-2 border border-destructive text-destructive rounded-md text-sm font-medium hover:bg-destructive hover:text-white transition-colors gap-2">
                        <i class="fas fa-trash-alt"></i> Delete
                      </button>
                    </form>
                  </div>

                </div>
              </div>
            </div>

          </div>
        </div>
      </main>
    </div>
</body>
</html>