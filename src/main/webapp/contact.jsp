<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact Us - DG Rimbun</title>
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
<body class="min-h-screen bg-gray-50 pt-20">

    <nav class="bg-white/90 backdrop-blur-md fixed w-full z-50 top-0 border-b border-border shadow-sm">
      <div class="container mx-auto px-4">
        <div class="flex justify-between items-center h-20">
          <a href="index.jsp" class="flex items-center gap-2 text-2xl font-bold text-primary">
            <i class="fas fa-leaf"></i> DG Rimbun
          </a>
          <div class="hidden md:flex items-center space-x-10">
            <div class="flex items-center space-x-8">
              <a href="index.jsp" class="text-gray-500 hover:text-primary font-medium transition-colors">
                <i class="fas fa-home mr-1 text-lg"></i> Home
              </a>
              <a href="homestays.jsp" class="text-gray-500 hover:text-primary font-medium transition-colors">
                <i class="fas fa-bed mr-1 text-lg"></i> Homestays
              </a>
              <a href="contact.jsp" class="text-primary font-medium transition-colors border-b-2 border-primary pb-1">
                <i class="fas fa-envelope mr-1 text-lg"></i> Contact
              </a>
            </div>
            
            <div class="flex items-center space-x-6">
              <% if (session.getAttribute("currentUser") != null) { %>
                  <a href="dashboard.jsp" class="flex items-center gap-2 text-gray-700 hover:text-primary font-medium transition-colors">
                      <i class="fas fa-border-all text-lg"></i> Dashboard
                  </a>
                  <form action="LogoutServlet" method="POST" class="m-0">
                      <button type="submit" class="flex items-center gap-2 bg-red-50 text-red-600 hover:bg-red-100 px-5 py-2.5 rounded-md font-medium transition-colors">
                          <i class="fas fa-sign-out-alt text-lg"></i> Logout
                      </button>
                  </form>
              <% } else { %>
                  <a href="login.jsp" class="flex items-center gap-2 text-gray-700 hover:text-primary font-medium transition-colors">
                      <i class="fas fa-sign-in-alt text-lg"></i> Login
                  </a>
                  <a href="register.jsp" class="flex items-center gap-2 bg-primary hover:bg-primary/90 text-white px-5 py-2.5 rounded-md font-medium transition-colors shadow-sm">
                      <i class="fas fa-user-plus text-lg"></i> Register
                  </a>
              <% } %>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <div class="container mx-auto px-4 py-16">
      <div class="max-w-5xl mx-auto">
        
        <div class="text-center mb-12">
          <h1 class="text-4xl font-bold mb-4 text-gray-900">Contact Us</h1>
          <p class="text-lg text-muted-foreground">
            Have questions? We'd love to hear from you.
          </p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          
          <div class="bg-white rounded-xl shadow-lg border border-border h-fit">
            <div class="p-8">
              <h2 class="text-2xl font-semibold mb-8 text-gray-800">Get in Touch</h2>
              
              <div class="space-y-8">
                
                <div class="flex items-start gap-4">
                  <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0">
                    <i class="fas fa-map-marker-alt text-xl text-primary"></i>
                  </div>
                  <div>
                    <h3 class="font-semibold mb-1 text-gray-900">Address</h3>
                    <p class="text-muted-foreground leading-relaxed">
                      Homestay DG Rimbun<br />
                      Taman Kenangan, Kampung Chinchin,<br />
                      77000 Jasin, Melaka<br />
                      Malaysia
                    </p>
                  </div>
                </div>

                <div class="flex items-start gap-4">
                  <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0">
                    <i class="fas fa-phone-alt text-xl text-primary"></i>
                  </div>
                  <div>
                    <h3 class="font-semibold mb-1 text-gray-900">Phone</h3>
                    <p class="text-muted-foreground">+60 12-345 6789</p>
                  </div>
                </div>

                <div class="flex items-start gap-4">
                  <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0">
                    <i class="fas fa-envelope text-xl text-primary"></i>
                  </div>
                  <div>
                    <h3 class="font-semibold mb-1 text-gray-900">Email</h3>
                    <p class="text-muted-foreground">info@dgrimbun.com</p>
                  </div>
                </div>

                <div class="flex items-start gap-4">
                  <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0">
                    <i class="fas fa-clock text-xl text-primary"></i>
                  </div>
                  <div>
                    <h3 class="font-semibold mb-1 text-gray-900">Office Hours</h3>
                    <p class="text-muted-foreground leading-relaxed">
                      Monday - Sunday<br />
                      9:00 AM - 6:00 PM
                    </p>
                  </div>
                </div>

              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-lg border border-border">
            <div class="p-8">
              <h2 class="text-2xl font-semibold mb-8 text-gray-800">Send Us a Message</h2>
              
              <form id="contactForm" onsubmit="return handleContactSubmit(event)" class="space-y-6">
                
                <div class="space-y-2">
                  <label for="name" class="text-sm font-medium text-gray-700">Your Name</label>
                  <input
                    type="text"
                    id="name"
                    name="name"
                    placeholder="John Doe"
                    class="w-full px-4 py-3 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50 text-gray-900"
                    required
                  />
                </div>

                <div class="space-y-2">
                  <label for="email" class="text-sm font-medium text-gray-700">Your Email</label>
                  <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="john@example.com"
                    class="w-full px-4 py-3 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50 text-gray-900"
                    required
                  />
                </div>

                <div class="space-y-2">
                  <label for="message" class="text-sm font-medium text-gray-700">Message</label>
                  <textarea
                    id="message"
                    name="message"
                    placeholder="How can we help you?"
                    rows="6"
                    class="w-full px-4 py-3 border border-border rounded-md focus:outline-none focus:ring-2 focus:ring-primary/50 text-gray-900"
                    required
                  ></textarea>
                </div>

                <button
                  type="submit"
                  class="w-full bg-primary hover:bg-primary/90 text-white font-semibold py-3 rounded-md transition-colors shadow-sm text-lg"
                >
                  Send Message
                </button>
              </form>
            </div>
          </div>

        </div>
      </div>
    </div>

    <script>
      function handleContactSubmit(event) {
        // Prevent the form from actually submitting to a server
        event.preventDefault();
        
        // Show success alert
        alert('Thank you for your message! We will get back to you soon.');
        
        // Clear the form fields
        document.getElementById('contactForm').reset();
        
        return false;
      }
    </script>
</body>
</html> 