<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Unit - DG Rimbun</title>
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
<body class="bg-accent/10">
    <div class="flex min-h-screen">
      
      <!-- Admin Sidebar (Consistent across all admin pages) -->
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
        <div class="max-w-3xl mx-auto">
          
          <h1 class="text-3xl font-bold mb-8">Update Homestay Unit</h1>

          <!-- Form Card -->
          <div class="bg-white rounded-xl shadow-lg border border-border overflow-hidden">
            <div class="bg-gradient-to-r from-primary/5 to-transparent border-b border-border p-6">
              <h2 class="text-xl font-bold">Chalet Details</h2>
            </div>
            
            <div class="p-6">
              <!-- Note the enctype attribute! Required for file uploads in Java -->
              <form action="SaveHomestayServlet" method="POST" enctype="multipart/form-data" class="space-y-6">
                
                <!-- Hidden ID field to tell the backend which unit is being updated -->
                <input type="hidden" name="homestayId" value="<%= request.getParameter("id") != null ? request.getParameter("id") : "" %>">

                <!-- Name Input -->
                <div class="space-y-2">
                  <label for="name" class="text-sm font-medium">Homestay Name</label>
                  <input
                    id="name"
                    name="name"
                    type="text"
                    placeholder="Enter homestay name"
                    class="w-full px-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                    required
                  />
                </div>

                <!-- Description Input -->
                <div class="space-y-2">
                  <label for="description" class="text-sm font-medium">Description</label>
                  <textarea
                    id="description"
                    name="description"
                    placeholder="Enter homestay description"
                    rows="4"
                    class="w-full px-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                    required
                  ></textarea>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <!-- Price Input -->
                  <div class="space-y-2">
                    <label for="price" class="text-sm font-medium">Price Per Night (RM)</label>
                    <input
                      id="price"
                      name="price"
                      type="number"
                      placeholder="200"
                      class="w-full px-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                      required
                    />
                  </div>

                  <!-- Capacity Dropdown -->
                  <div class="space-y-2">
                    <label for="capacity" class="text-sm font-medium">Max Capacity</label>
                    <select
                      id="capacity"
                      name="capacity"
                      class="w-full px-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50 bg-white"
                      required
                    >
                      <option value="" disabled selected>Select capacity</option>
                      <option value="2">2 Pax</option>
                      <option value="4">4 Pax</option>
                      <option value="5">5 Pax</option>
                      <option value="6">6 Pax</option>
                      <option value="8">8 Pax</option>
                      <option value="10">10 Pax</option>
                    </select>
                  </div>
                </div>

                <!-- Image Upload (Styled to look like a drag-and-drop zone) -->
                <div class="space-y-2">
                  <label class="text-sm font-medium">Room Photos</label>
                  <label for="imageUpload" class="block w-full border-2 border-dashed border-border rounded-lg p-8 text-center hover:border-primary transition-colors cursor-pointer bg-gray-50/50">
                    <i class="fas fa-cloud-upload-alt text-4xl text-muted-foreground mb-4"></i>
                    <p class="text-sm text-muted-foreground mb-2">
                      Click to browse and upload images
                    </p>
                    <p class="text-xs text-muted-foreground">
                      Supported formats: JPG, PNG, WEBP (Max 5MB)
                    </p>
                    <!-- Actual hidden file input -->
                    <input type="file" id="imageUpload" name="imageUpload" class="hidden" accept="image/png, image/jpeg, image/webp" />
                  </label>
                </div>

                <!-- Action Buttons -->
                <div class="flex gap-4 pt-4">
                  <button
                    type="submit"
                    class="flex-1 bg-primary hover:bg-primary/90 text-white font-medium py-2 rounded-md transition-colors shadow-sm"
                  >
                    Save Changes
                  </button>
                  <a
                    href="manageHomestays.jsp"
                    class="flex-1 inline-flex items-center justify-center border border-border text-gray-700 hover:bg-gray-50 font-medium py-2 rounded-md transition-colors"
                  >
                    Cancel
                  </a>
                </div>

              </form>
            </div>
          </div>
        </div>
      </main>
    </div>
</body>
</html>