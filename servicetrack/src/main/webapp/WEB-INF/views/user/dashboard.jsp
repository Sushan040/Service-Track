<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.servicetrack.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - ServiceTrack</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="dashboard-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="logo">
                    <i class="fas fa-car"></i>
                    <span>ServiceTrack</span>
                </div>
            </div>
            
            <div class="sidebar-menu">
                <a href="#" class="menu-item active">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Book Service</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-history"></i>
                    <span>Service History</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-car"></i>
                    <span>My Vehicles</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-user"></i>
                    <span>Profile</span>
                </a>
            </div>
            
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/auth/logout" class="logout-item">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="top-bar">
                <div class="welcome-text">
                    <h2>Welcome back, <%= user.getFullName() %>!</h2>
                    <p>Here's what's happening with your vehicles today.</p>
                </div>
                <div class="user-profile">
                    <div class="avatar">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="user-info">
                        <span class="name"><%= user.getFullName() %></span>
                        <span class="role">Customer</span>
                    </div>
                </div>
            </div>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="fas fa-wrench"></i>
                    </div>
                    <div class="stat-details">
                        <h3>Active Services</h3>
                        <p class="stat-number">0</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-details">
                        <h3>Completed Services</h3>
                        <p class="stat-number">0</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="fas fa-car"></i>
                    </div>
                    <div class="stat-details">
                        <h3>My Vehicles</h3>
                        <p class="stat-number">0</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon purple">
                        <i class="fas fa-calendar"></i>
                    </div>
                    <div class="stat-details">
                        <h3>Total Appointments</h3>
                        <p class="stat-number">0</p>
                    </div>
                </div>
            </div>
            
            <div class="content-grid">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-clock"></i> Recent Service Requests</h3>
                        <a href="#" class="btn-link">View All</a>
                    </div>
                    <div class="card-body">
                        <div class="empty-state">
                            <i class="fas fa-tools"></i>
                            <p>No service requests yet</p>
                            <button class="btn-primary-small">Book Your First Service</button>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-calendar-week"></i> Upcoming Appointments</h3>
                        <a href="#" class="btn-link">View All</a>
                    </div>
                    <div class="card-body">
                        <div class="empty-state">
                            <i class="fas fa-calendar-alt"></i>
                            <p>No upcoming appointments</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>