<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.servicetrack.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ServiceTrack</title>
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
                    <span>ServiceTrack Admin</span>
                </div>
            </div>
            
            <div class="sidebar-menu">
                <a href="#" class="menu-item active">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-tools"></i>
                    <span>Service Requests</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-users"></i>
                    <span>Manage Users</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-car"></i>
                    <span>Vehicles</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-chart-bar"></i>
                    <span>Reports</span>
                </a>
                <a href="#" class="menu-item">
                    <i class="fas fa-cog"></i>
                    <span>Settings</span>
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
                    <h2>Welcome, <%= user.getFullName() %>!</h2>
                    <p>Here's your system overview for today.</p>
                </div>
                <div class="user-profile">
                    <div class="avatar">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="user-info">
                        <span class="name"><%= user.getFullName() %></span>
                        <span class="role">Administrator</span>
                    </div>
                </div>
            </div>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-details">
                        <h3>Total Users</h3>
                        <p class="stat-number">0</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="fas fa-wrench"></i>
                    </div>
                    <div class="stat-details">
                        <h3>Active Services</h3>
                        <p class="stat-number">0</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="fas fa-check-double"></i>
                    </div>
                    <div class="stat-details">
                        <h3>Completed Services</h3>
                        <p class="stat-number">0</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon purple">
                        <i class="fas fa-calendar-week"></i>
                    </div>
                    <div class="stat-details">
                        <h3>Pending Requests</h3>
                        <p class="stat-number">0</p>
                    </div>
                </div>
            </div>
            
            <div class="content-grid">
                <div class="card full-width">
                    <div class="card-header">
                        <h3><i class="fas fa-clock"></i> Recent Service Requests</h3>
                        <a href="#" class="btn-link">View All</a>
                    </div>
                    <div class="card-body">
                        <div class="empty-state">
                            <i class="fas fa-tasks"></i>
                            <p>No service requests pending</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="content-grid">
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-chart-line"></i> System Status</h3>
                    </div>
                    <div class="card-body">
                        <div class="status-item">
                            <span>Server Status</span>
                            <span class="status-badge success">Operational</span>
                        </div>
                        <div class="status-item">
                            <span>Database Connection</span>
                            <span class="status-badge success">Connected</span>
                        </div>
                        <div class="status-item">
                            <span>Active Sessions</span>
                            <span class="status-badge info">0</span>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-bell"></i> Recent Activities</h3>
                    </div>
                    <div class="card-body">
                        <div class="empty-state small">
                            <i class="fas fa-inbox"></i>
                            <p>No recent activities</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>