<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DG Rimbun - Homestays</title>
    <!-- Tailwind CSS Script -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome for standard HTML Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Your Tailwind Custom Colors (from your screenshot) -->
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#16a34a', // You can change this hex color to match your specific green
                        accent: '#dcfce7',
                        border: '#e5e7eb',
                        'muted-foreground': '#6b7280'
                    }
                }
            }
        }
    </script>
</head>
<body>
    <div class="min-h-screen">
   <!-- Navigation Bar -->
      <nav class="bg-white/90 backdrop-blur-md fixed w-full z-50 top-0 border-b border-border shadow-sm">
        <div class="container mx-auto px-4">
          <div class="flex justify-between items-center h-20">
            
            <!-- Logo -->
            <a href="index.jsp" class="flex items-center gap-2 text-2xl font-bold text-primary">
              <i class="fas fa-leaf"></i> DG Rimbun
            </a>

            <!-- Main Navigation (Matches Figma Exactly) -->
            <div class="hidden md:flex items-center space-x-10">
              
              <!-- Left Side Links -->
              <div class="flex items-center space-x-8">
                <a href="index.jsp" class="flex items-center gap-2 text-[#859f8a] font-medium transition-colors">
                  <i class="fas fa-home text-lg"></i> Home
                </a>
                <a href="homestays.jsp" class="flex items-center gap-2 text-gray-500 hover:text-[#859f8a] font-medium transition-colors">
                  <i class="fas fa-bed text-lg"></i> Homestays
                </a>
              </div>

              <!-- Right Side Auth Buttons (Static for first page) -->
              <div class="flex items-center space-x-6">
                <a href="login.jsp" class="flex items-center gap-2 text-gray-700 hover:text-[#859f8a] font-medium transition-colors">
                    <i class="fas fa-sign-in-alt text-lg"></i> Login
                </a>
                <a href="register.jsp" class="flex items-center gap-2 bg-[#859f8a] hover:bg-[#7fa99b] text-white px-5 py-2.5 rounded-md font-medium transition-colors shadow-sm">
                    <i class="fas fa-user-plus text-lg"></i> Register
                </a>
              </div>

            </div>
          </div>
        </div>
      </nav>
      <!-- Hero Section -->
      <section class="relative min-h-screen flex items-center bg-gradient-to-br from-accent/20 via-white to-primary/5">
        <div class="container mx-auto px-4 py-20">
          <div class="grid lg:grid-cols-2 gap-12 items-center">
          
            <div class="space-y-8">
              <div class="inline-block">
                <span class="inline-flex items-center gap-2 px-4 py-2 bg-primary/10 text-primary rounded-full text-sm font-medium">
                  <i class="fas fa-leaf"></i> Your Nature Escape Awaits
                </span>
              </div>
              <h1 class="text-5xl md:text-6xl lg:text-7xl font-bold leading-tight">
                Discover Peace at <span class="text-primary">DG Rimbun</span>
              </h1>
              <p class="text-xl text-muted-foreground leading-relaxed">
                Experience the perfect blend of comfort and nature in Jasin, Melaka. 
                Our homestays offer a serene retreat for families, couples, and solo travelers.
              </p>
              <div class="flex flex-wrap gap-4">
                <!-- Converted React Buttons to standard HTML anchor tags for JSP navigation -->
                <a href="homestays.jsp" class="inline-block bg-primary hover:bg-primary/90 text-white px-8 py-4 rounded-md text-lg shadow-lg hover:shadow-xl transition-all">
                  Explore Our Homestays
                  <i class="fas fa-arrow-right ml-2"></i>
                </a>
                <a href="contact.jsp" class="inline-block px-8 py-4 rounded-md text-lg border-2 border-primary/30 hover:border-primary transition-all">
                  Contact Us
                </a>
              </div>
              
              <!-- Stats -->
              <div class="flex flex-wrap gap-8 pt-8 border-t border-border">
                <div>
                  <div class="text-3xl font-bold text-primary">100+</div>
                  <div class="text-sm text-muted-foreground">Homestay Units</div>
                </div>
                <div>
                  <div class="text-3xl font-bold text-primary">500+</div>
                  <div class="text-sm text-muted-foreground">Happy Guests</div>
                </div>
                <div>
                  <div class="text-3xl font-bold text-primary">4.9</div>
                  <div class="text-sm text-muted-foreground">Rating</div>
                </div>
              </div>
            </div>

            <!-- Right Image Grid (Using placeholder images until database is linked) -->
            <div class="relative">
              <div class="grid grid-cols-1 gap-6">
                <div class="h-56 rounded-2xl overflow-hidden shadow-xl">
                  <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&q=80" alt="Homestay" class="w-full h-full object-cover hover:scale-105 transition-transform duration-500" />
                </div>
                <div class="h-56 rounded-2xl overflow-hidden shadow-xl">
                  <img src="https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800&q=80" alt="Nature" class="w-full h-full object-cover hover:scale-105 transition-transform duration-500" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Features Section -->
      <section class="py-20 bg-white">
        <div class="container mx-auto px-4">
          <div class="text-center mb-16">
            <h2 class="text-4xl font-bold mb-4">Why Choose DG Rimbun?</h2>
            <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
              We are committed to providing you with an exceptional stay experience
            </p>
          </div>

          <div class="grid md:grid-cols-3 gap-8">
            <div class="bg-white rounded-lg border-2 border-border hover:border-primary/50 transition-all hover:shadow-lg p-8 text-center">
                <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-6">
                  <i class="fas fa-shield-alt text-2xl text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-3">Safe & Secure</h3>
                <p class="text-muted-foreground">
                  Your safety is our priority. All our properties are secure and well-maintained.
                </p>
            </div>

            <div class="bg-white rounded-lg border-2 border-border hover:border-primary/50 transition-all hover:shadow-lg p-8 text-center">
                <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-6">
                  <i class="fas fa-clock text-2xl text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-3">24/7 Support</h3>
                <p class="text-muted-foreground">
                  Our team is always available to assist you during your stay.
                </p>
            </div>

            <div class="bg-white rounded-lg border-2 border-border hover:border-primary/50 transition-all hover:shadow-lg p-8 text-center">
                <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-6">
                  <i class="fas fa-star text-2xl text-primary"></i>
                </div>
                <h3 class="text-xl font-semibold mb-3">Premium Quality</h3>
                <p class="text-muted-foreground">
                  Carefully curated homestays with modern amenities and comfort.
                </p>
            </div>
          </div>
        </div>
      </section>

      <!-- Featured Homestays Section (Static mockups for now) -->
      <section class="py-20 bg-gradient-to-b from-accent/10 to-white">
        <div class="container mx-auto px-4">
          <div class="text-center mb-16">
            <h2 class="text-4xl font-bold mb-4">Our Premium Homestays</h2>
            <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
              Each property is uniquely designed to offer you comfort and tranquility
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Mockup Card 1 -->
            <div class="bg-white rounded-lg overflow-hidden hover:shadow-2xl transition-all duration-300 group border border-border shadow-lg">
                <div class="relative h-72 overflow-hidden">
                  <img src="https://images.unsplash.com/photo-1542718144-667d4022a426?w=800&q=80" alt="Chalet 1" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" />
                  <div class="absolute top-4 right-4 bg-white px-3 py-1 rounded-full shadow-md">
                    <div class="flex items-center gap-1">
                      <i class="fas fa-star text-yellow-400 text-sm"></i>
                      <span class="text-sm font-semibold">4.9</span>
                    </div>
                  </div>
                </div>
                <div class="p-6">
                  <h3 class="text-2xl font-bold mb-2 group-hover:text-primary transition-colors">
                    Chalet Type A
                  </h3>
                  <p class="text-muted-foreground text-sm mb-4 line-clamp-2 min-h-[2.5rem]">
                    A beautiful and cozy chalet perfect for a weekend getaway with the family.
                  </p>
                  
                  <div class="flex items-center justify-between mb-6 pt-4 border-t border-border">
                    <div class="flex items-center gap-2 text-muted-foreground">
                      <i class="fas fa-users"></i>
                      <span class="font-medium">4 Guests</span>
                    </div>
                    <div class="text-right">
                      <div class="text-3xl font-bold text-primary">
                        RM150
                      </div>
                      <div class="text-xs text-muted-foreground">per night</div>
                    </div>
                  </div>

                  <a href="homestayDetails.jsp?id=1" class="block text-center w-full bg-primary hover:bg-primary/90 text-white py-3 rounded-md group-hover:shadow-lg transition-all">
                    View Details
                    <i class="fas fa-arrow-right ml-2 text-sm group-hover:translate-x-1 transition-transform"></i>
                  </a>
                </div>
            </div>
            
            <!-- Mockup Card 2 -->
             <div class="bg-white rounded-lg overflow-hidden hover:shadow-2xl transition-all duration-300 group border border-border shadow-lg">
                <div class="relative h-72 overflow-hidden">
                  <img src="https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&q=80" alt="Chalet 2" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" />
                  <div class="absolute top-4 right-4 bg-white px-3 py-1 rounded-full shadow-md">
                    <div class="flex items-center gap-1">
                      <i class="fas fa-star text-yellow-400 text-sm"></i>
                      <span class="text-sm font-semibold">4.8</span>
                    </div>
                  </div>
                </div>
                <div class="p-6">
                  <h3 class="text-2xl font-bold mb-2 group-hover:text-primary transition-colors">
                    Chalet Type B
                  </h3>
                  <p class="text-muted-foreground text-sm mb-4 line-clamp-2 min-h-[2.5rem]">
                    Spacious living with a beautiful view of the surrounding nature reserve.
                  </p>
                  
                  <div class="flex items-center justify-between mb-6 pt-4 border-t border-border">
                    <div class="flex items-center gap-2 text-muted-foreground">
                      <i class="fas fa-users"></i>
                      <span class="font-medium">6 Guests</span>
                    </div>
                    <div class="text-right">
                      <div class="text-3xl font-bold text-primary">
                        RM220
                      </div>
                      <div class="text-xs text-muted-foreground">per night</div>
                    </div>
                  </div>

                  <a href="homestayDetails.jsp?id=2" class="block text-center w-full bg-primary hover:bg-primary/90 text-white py-3 rounded-md group-hover:shadow-lg transition-all">
                    View Details
                    <i class="fas fa-arrow-right ml-2 text-sm group-hover:translate-x-1 transition-transform"></i>
                  </a>
                </div>
            </div>
          </div>
        </div>
      </section>

      <!-- CTA Section -->
      <section class="py-20 bg-primary text-white">
        <div class="container mx-auto px-4 text-center">
          <h2 class="text-4xl md:text-5xl font-bold mb-6">
            Ready for Your Perfect Getaway?
          </h2>
          <p class="text-xl mb-8 text-white/90 max-w-2xl mx-auto">
            Book your stay today and experience the tranquility of DG Rimbun
          </p>
          <a href="homestays.jsp" class="inline-block bg-white text-primary hover:bg-white/90 px-8 py-4 rounded-md text-lg shadow-xl hover:shadow-2xl transition-all">
            Book Your Stay Now
            <i class="fas fa-arrow-right ml-2"></i>
          </a>
        </div>
      </section>
    </div>
</body>
</html>