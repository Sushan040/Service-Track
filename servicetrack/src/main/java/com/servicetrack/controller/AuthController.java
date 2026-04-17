package com.servicetrack.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.servicetrack.model.User;
import com.servicetrack.service.UserService;

@WebServlet("/auth/*")
public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    
    // Admin registration key - in production, this should be stored in database or config file
    private static final String ADMIN_REGISTRATION_KEY = "ADMIN123"; // Change this to a secure key
    
    @Override
    public void init() {
        userService = new UserService();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getPathInfo();
        
        if ("/login".equals(path)) {
            login(request, response);
        } else if ("/register".equals(path)) {
            register(request, response);
        } else if ("/logout".equals(path)) {
            logout(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getPathInfo();
        
        if (path == null || "/login".equals(path)) {
            // Check if user is already logged in
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                if ("admin".equals(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/dashboard");
                }
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        } else if ("/register".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        } else if ("/logout".equals(path)) {
            logout(request, response);
        }
    }
    
    private void login(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            User user = userService.loginUser(email, password);
            
            if (user == null) {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("role", user.getRole());
            
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/dashboard");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
    
    private void register(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");
        String adminKey = request.getParameter("adminKey");
        
        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("error", "Valid email address is required");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        // Role validation
        String userRole = "customer"; // default role
        if (role != null && role.equals("admin")) {
            // Verify admin registration key
            if (adminKey == null || !adminKey.equals(ADMIN_REGISTRATION_KEY)) {
                request.setAttribute("error", "Invalid admin registration key");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }
            userRole = "admin";
        }
        
        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(password);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRole(userRole);
        
        try {
            // Check if email already exists
            if (userService.emailExists(email.trim().toLowerCase())) {
                request.setAttribute("error", "Email address is already registered");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }
            
            boolean registered = userService.registerUser(user);
            if (registered) {
                String successMessage = userRole.equals("admin") ? 
                    "Admin registration successful! Please login." : 
                    "Registration successful! Please login.";
                request.setAttribute("success", successMessage);
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/auth/login");
    }
}