<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - ServiceTrack</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="main-wrapper">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-left">
                    <div class="brand">
                        <div class="brand-icon">
                            <i class="fas fa-car"></i>
                            <i class="fas fa-tools"></i>
                        </div>
                        <h1>ServiceTrack</h1>
                        <p>Professional Vehicle Service Management</p>
                    </div>
                    <div class="features">
                        <div class="feature">
                            <i class="fas fa-check-circle"></i>
                            <span>24/7 Service Booking</span>
                        </div>
                        <div class="feature">
                            <i class="fas fa-chart-line"></i>
                            <span>Real-time Tracking</span>
                        </div>
                        <div class="feature">
                            <i class="fas fa-shield-alt"></i>
                            <span>Secure & Reliable</span>
                        </div>
                    </div>
                </div>
                
                <div class="auth-right">
                    <div class="auth-form">
                        <h2>Welcome Back</h2>
                        <p class="subtitle">Login to access your dashboard</p>
                        
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle"></i>
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <% if(request.getAttribute("success") != null) { %>
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle"></i>
                                <%= request.getAttribute("success") %>
                            </div>
                        <% } %>
                        
                        <form action="${pageContext.request.contextPath}/auth/login" method="post">
                            <div class="input-group">
                                <label for="email">
                                    <i class="fas fa-envelope"></i>
                                    Email Address
                                </label>
                                <input type="email" id="email" name="email" required autocomplete="off">
                            </div>
                            
                            <div class="input-group">
                                <label for="password">
                                    <i class="fas fa-lock"></i>
                                    Password
                                </label>
                                <input type="password" id="password" name="password" required>
                            </div>
                            
                            <button type="submit" class="btn-login">
                                <i class="fas fa-sign-in-alt"></i>
                                Sign In
                            </button>
                        </form>
                        
                        <div class="auth-footer">
                            <p>Don't have an account? <a href="${pageContext.request.contextPath}/auth/register">Create Account</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>