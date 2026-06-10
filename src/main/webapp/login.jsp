<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - DG Rimbun</title>
    <!-- Tailwind CSS Script -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome for standard HTML Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Your Tailwind Custom Colors -->
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
<body>
    <div class="min-h-screen bg-accent/20">
      
      <!-- Simple Back to Home Header -->
      <header class="p-4 bg-white shadow-sm flex items-center">
          <a href="index.jsp" class="text-primary hover:text-primary/80 font-medium flex items-center gap-2">
              <i class="fas fa-arrow-left"></i> Back to Home
          </a>
      </header>

      <div class="flex items-center justify-center px-4 py-12">
        <div class="w-full max-w-md bg-white rounded-xl shadow-lg border border-border p-6">
        
          <div class="space-y-1 mb-6">
            <h2 class="text-2xl font-bold text-center">Welcome Back</h2>
            <p class="text-center text-muted-foreground">
              Sign in to your DG Rimbun account
            </p>
          </div>
        
          <!-- Form Action points directly to your LoginServlet -->
          <form action="LoginServlet" method="POST" class="space-y-4">
            
            <!-- Role Selection (Styled Radio Buttons) -->
            <div class="space-y-2">
              <label class="text-sm font-medium">I am a</label>
              <div class="grid grid-cols-2 gap-3">
                
                <!-- Guest Radio -->
                <label class="cursor-pointer">
                  <input type="radio" name="role" value="guest" class="peer sr-only" checked>
                  <div class="h-20 flex flex-col items-center justify-center gap-2 rounded-md border border-border peer-checked:bg-primary peer-checked:text-white peer-checked:border-primary hover:border-primary transition-all">
                    <i class="fas fa-user-circle text-2xl"></i>
                    <span class="text-sm">Guest</span>
                  </div>
                </label>

                <!-- Staff Radio -->
                <label class="cursor-pointer">
                  <input type="radio" name="role" value="staff" class="peer sr-only">
                  <div class="h-20 flex flex-col items-center justify-center gap-2 rounded-md border border-border peer-checked:bg-primary peer-checked:text-white peer-checked:border-primary hover:border-primary transition-all">
                    <i class="fas fa-briefcase text-2xl"></i>
                    <span class="text-sm">Staff</span>
                  </div>
                </label>

              </div>
            </div>

            <!-- Dynamic JSP Error Message (Matches your LoginServlet logic) -->
            <% 
                String error = (String) request.getAttribute("errorMessage");
                if (error != null) { 
            %>
            <div class="bg-destructive/10 border border-destructive/20 rounded-lg p-3 flex items-start gap-2">
              <i class="fas fa-exclamation-circle text-destructive mt-0.5"></i>
              <p class="text-sm text-destructive"><%= error %></p>
            </div>
            <% } %>

            <!-- Email Input -->
            <div class="space-y-2">
              <label for="email" class="text-sm font-medium">Email</label>
              <div class="relative">
                <i class="fas fa-envelope absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                <input
                  id="email"
                  name="email"
                  type="email"
                  placeholder="your@email.com"
                  class="w-full pl-10 pr-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                  required
                />
              </div>
            </div>

            <!-- Password Input -->
            <div class="space-y-2">
              <label for="password" class="text-sm font-medium">Password</label>
              <div class="relative">
                <i class="fas fa-lock absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"></i>
                <input
                  id="password"
                  name="password"
                  type="password"
                  placeholder="••••••••"
                  class="w-full pl-10 pr-3 py-2 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50"
                  required
                />
              </div>
            </div>

            <!-- Forgot Password -->
            <div class="flex items-center justify-between">
              <a href="#" class="text-sm text-primary hover:underline">
                Forgot Password?
              </a>
            </div>

            <!-- Submit Button -->
            <button
              type="submit"
              class="w-full bg-primary hover:bg-primary/90 text-white font-medium py-2 rounded-md transition-all shadow-md"
            >
              Login
            </button>

            <!-- Register Link -->
            <div class="text-center text-sm pt-2">
              <span class="text-muted-foreground">Don't have an account? </span>
              <a href="register.jsp" class="text-primary hover:underline font-medium">
                Register here
              </a>
            </div>

            <!-- Demo Credentials Note -->
            <div class="mt-4 p-3 bg-accent/50 rounded-lg">
              <p class="text-xs text-muted-foreground mb-2 font-medium">Demo Credentials:</p>
              <p class="text-xs text-muted-foreground">Owner: owner@dgrimbun.com / password</p>
              <p class="text-xs text-muted-foreground">Staff: staff@dgrimbun.com / password</p>
              <p class="text-xs text-muted-foreground">Guest: guest@dgrimbun.com / password</p>
            </div>

          </form>
        </div>
      </div>
    </div>
</body>
</html>