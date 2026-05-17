<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, com.servicetrack.model.ServiceRequest, java.util.List, java.util.Map"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"admin".equals(user.getRole())) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}

Integer totalUsers = (Integer) request.getAttribute("totalUsers");
Integer activeServices = (Integer) request.getAttribute("activeServices");
Integer completedServices = (Integer) request.getAttribute("completedServices");
Integer pendingServices = (Integer) request.getAttribute("pendingServices");
List<ServiceRequest> recentServices = (List<ServiceRequest>) request.getAttribute("recentServices");
List<Map<String, String>> recentActivities = (List<Map<String, String>>) request.getAttribute("recentActivities");

if (totalUsers == null)
	totalUsers = 0;
if (activeServices == null)
	activeServices = 0;
if (completedServices == null)
	completedServices = 0;
if (pendingServices == null)
	pendingServices = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard - ServiceTrack</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.data-table {
	width: 100%;
	border-collapse: collapse;
}

.data-table th, .data-table td {
	padding: 10px;
	text-align: left;
	border-bottom: 1px solid #1a1d24;
}

.data-table th {
	color: #3671C6;
	font-weight: 600;
}

.data-table td {
	color: #fff;
}

.status-badge {
	display: inline-block;
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
}

.status-pending {
	background: rgba(255, 152, 0, 0.2);
	color: #FF9800;
}

.status-in-progress {
	background: rgba(54, 113, 198, 0.2);
	color: #3671C6;
}

.status-completed {
	background: rgba(76, 175, 80, 0.2);
	color: #4CAF50;
}

.status-cancelled {
	background: rgba(230, 0, 46, 0.2);
	color: #E6002E;
}

.activity-item {
	padding: 10px 0;
	border-bottom: 1px solid #1a1d24;
}

.activity-message {
	color: #fff;
}

.activity-time {
	color: #8a8f99;
	font-size: 12px;
}
</style>
</head>
<body>
	<div class="dashboard-wrapper">
		<!-- Sidebar -->
		<div class="sidebar">
			<div class="sidebar-header">
				<div class="logo">
					<i class="fas fa-car"></i> <span>ServiceTrack Admin</span>
				</div>
			</div>
			<div class="sidebar-menu">
				<a href="${pageContext.request.contextPath}/admin/dashboard"
					class="menu-item active"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a>
				<a href="${pageContext.request.contextPath}/service/admin/manage"
					class="menu-item"><i class="fas fa-tools"></i><span>Service
						Requests</span></a> <a href="${pageContext.request.contextPath}/admin/users"
					class="menu-item"><i class="fas fa-users"></i><span>Manage
						Users</span></a> <a href="${pageContext.request.contextPath}/admin/packages"
					class="menu-item"><i class="fas fa-box"></i><span>Service
						Packages</span></a> <a
					href="${pageContext.request.contextPath}/admin/coupons"
					class="menu-item"><i class="fas fa-tag"></i><span>Coupons</span></a>
				<a href="${pageContext.request.contextPath}/admin/reports"
					class="menu-item"><i class="fas fa-chart-line"></i><span>Reports</span></a>
			</div>
			<div class="sidebar-footer">
				<a href="${pageContext.request.contextPath}/auth/logout"
					class="logout-item"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
			</div>
		</div>

		<!-- Main Content -->
		<div class="main-content">
			<div class="top-bar">
				<div class="welcome-text">
					<h2>
						Welcome,
						<%=user.getFullName()%>!
					</h2>
					<p>Here's your system overview for today.</p>
				</div>
				<div class="user-profile">
					<div class="avatar">
						<i class="fas fa-user-circle"></i>
					</div>
					<div class="user-info">
						<span class="name"><%=user.getFullName()%></span> <span
							class="role">Administrator</span>
					</div>
				</div>
			</div>

			<!-- Statistics Cards -->
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-icon blue">
						<i class="fas fa-users"></i>
					</div>
					<div class="stat-details">
						<h3>Total Users</h3>
						<p class="stat-number"><%=totalUsers%></p>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon orange">
						<i class="fas fa-clock"></i>
					</div>
					<div class="stat-details">
						<h3>Pending Services</h3>
						<p class="stat-number"><%=pendingServices%></p>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon blue">
						<i class="fas fa-wrench"></i>
					</div>
					<div class="stat-details">
						<h3>Active Services</h3>
						<p class="stat-number"><%=activeServices%></p>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon green">
						<i class="fas fa-check-double"></i>
					</div>
					<div class="stat-details">
						<h3>Completed Services</h3>
						<p class="stat-number"><%=completedServices%></p>
					</div>
				</div>
			</div>

			<!-- Recent Service Requests -->
			<div class="content-grid">
				<div class="card full-width">
					<div class="card-header">
						<h3>
							<i class="fas fa-clock"></i> Recent Service Requests
						</h3>
						<a href="${pageContext.request.contextPath}/service/admin/manage"
							class="btn-link">View All</a>
					</div>
					<div class="card-body">
						<%
						if (recentServices != null && !recentServices.isEmpty()) {
						%>
						<table class="data-table">
							<thead>
								<tr>
									<th>Customer</th>
									<th>Vehicle</th>
									<th>Service Type</th>
									<th>Status</th>
									<th>Date</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (ServiceRequest sr : recentServices) {
								%>
								<tr>
									<td><%=sr.getCustomerName() != null ? sr.getCustomerName() : "N/A"%></td>
									<td><%=sr.getVehicleModel() != null ? sr.getVehicleModel() : "N/A"%></td>
									<td><%=sr.getServiceType()%></td>
									<td><span
										class="status-badge status-<%=sr.getStatus().replace("_", "-")%>"><%=sr.getStatus().replace("_", " ").toUpperCase()%></span></td>
									<td><%=sr.getCreatedAt() != null ? sr.getCreatedAt().toString().substring(0, 10) : "N/A"%></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
						<%
						} else {
						%>
						<div class="empty-state">
							<i class="fas fa-tasks"></i>
							<p>No service requests found</p>
						</div>
						<%
						}
						%>
					</div>
				</div>
			</div>

			<!-- System Status and Recent Activities -->
			<div class="content-grid">
				<div class="card">
					<div class="card-header">
						<h3>
							<i class="fas fa-chart-line"></i> System Status
						</h3>
					</div>
					<div class="card-body">
						<div class="status-item">
							<span>Server Status</span> <span class="status-badge success">Operational</span>
						</div>
						<div class="status-item">
							<span>Database Connection</span> <span
								class="status-badge success">Connected</span>
						</div>
						<div class="status-item">
							<span>Active Sessions</span> <span class="status-badge info">Active</span>
						</div>
					</div>
				</div>

				<div class="card">
					<div class="card-header">
						<h3>
							<i class="fas fa-bell"></i> Recent Activities
						</h3>
					</div>
					<div class="card-body">
						<%
						if (recentActivities != null && !recentActivities.isEmpty()) {
						%>
						<%
						for (Map<String, String> activity : recentActivities) {
						%>
						<div class="activity-item">
							<div class="activity-message"><%=activity.get("message")%></div>
							<div class="activity-time"><%=activity.get("time")%></div>
						</div>
						<%
						}
						%>
						<%
						} else {
						%>
						<div class="empty-state small">
							<i class="fas fa-inbox"></i>
							<p>No recent activities</p>
						</div>
						<%
						}
						%>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>