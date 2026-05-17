<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, com.servicetrack.model.ServiceRequest, java.util.List"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}

Integer activeServices = (Integer) request.getAttribute("activeServices");
Integer completedServices = (Integer) request.getAttribute("completedServices");
Integer myVehicles = (Integer) request.getAttribute("myVehicles");
Integer myServices = (Integer) request.getAttribute("myServices");
List<ServiceRequest> recentServices = (List<ServiceRequest>) request.getAttribute("recentServices");

if (activeServices == null)
	activeServices = 0;
if (completedServices == null)
	completedServices = 0;
if (myVehicles == null)
	myVehicles = 0;
if (myServices == null)
	myServices = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Dashboard - ServiceTrack</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<style>
.dashboard-wrapper {
	display: flex;
	min-height: 100vh;
}

.sidebar {
	width: 280px;
	background: #0f1115;
	border-right: 1px solid #1a1d24;
	padding: 30px 20px;
	position: fixed;
	height: 100vh;
}

.logo {
	font-size: 24px;
	font-weight: 800;
	margin-bottom: 40px;
}

.logo span {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	-webkit-background-clip: text;
	background-clip: text;
	color: transparent;
}

.menu-item {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 12px 16px;
	color: #8a8f99;
	text-decoration: none;
	border-radius: 10px;
	margin-bottom: 5px;
}

.menu-item:hover, .menu-item.active {
	background: linear-gradient(135deg, rgba(230, 0, 46, 0.15),
		rgba(54, 113, 198, 0.15));
	color: #E6002E;
}

.main-content {
	flex: 1;
	margin-left: 280px;
	padding: 30px 40px;
}

.top-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
	padding-bottom: 20px;
	border-bottom: 1px solid #1a1d24;
}

.welcome-text h2 {
	font-size: 28px;
	color: #fff;
	margin-bottom: 5px;
}

.welcome-text p {
	color: #8a8f99;
}

.user-avatar {
	width: 50px;
	height: 50px;
	background: linear-gradient(135deg, #E6002E, #3671C6);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
	font-size: 20px;
}

.stats-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
	margin-bottom: 30px;
}

.stat-card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 20px;
	display: flex;
	align-items: center;
	gap: 15px;
}

.stat-icon {
	width: 50px;
	height: 50px;
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 24px;
}

.stat-icon.blue {
	background: rgba(54, 113, 198, 0.2);
	color: #3671C6;
}

.stat-icon.green {
	background: rgba(76, 175, 80, 0.2);
	color: #4CAF50;
}

.stat-icon.orange {
	background: rgba(255, 152, 0, 0.2);
	color: #FF9800;
}

.stat-icon.purple {
	background: rgba(156, 39, 176, 0.2);
	color: #9C27B0;
}

.stat-details h3 {
	font-size: 14px;
	color: #8a8f99;
	margin-bottom: 5px;
}

.stat-number {
	font-size: 28px;
	font-weight: bold;
	color: #fff;
}

.content-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	overflow: hidden;
}

.card-header {
	padding: 18px 20px;
	border-bottom: 1px solid #1a1d24;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.card-header h3 {
	font-size: 16px;
	color: #fff;
}

.card-header h3 i {
	color: #E6002E;
	margin-right: 8px;
}

.btn-link {
	color: #3671C6;
	text-decoration: none;
	font-size: 13px;
}

.card-body {
	padding: 20px;
}

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

.empty-state {
	text-align: center;
	padding: 40px;
	color: #8a8f99;
}

@media ( max-width : 1000px) {
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.content-grid {
		grid-template-columns: 1fr;
	}
}

@media ( max-width : 768px) {
	.sidebar {
		width: 80px;
	}
	.logo span, .menu-item span {
		display: none;
	}
	.main-content {
		margin-left: 80px;
	}
	.stats-grid {
		grid-template-columns: 1fr;
	}
}
</style>
</head>
<body>
	<div class="dashboard-wrapper">
		<!-- Sidebar -->
		<div class="sidebar">
			<div class="sidebar-header">
				<div class="logo">
					<i class="fas fa-car"></i> <span>ServiceTrack</span>
				</div>
			</div>

			<div class="sidebar-menu">
				<a href="${pageContext.request.contextPath}/user/dashboard"
					class="menu-item active"> <i class="fas fa-tachometer-alt"></i>
					<span>Dashboard</span>
				</a> <a href="${pageContext.request.contextPath}/service/book"
					class="menu-item"> <i class="fas fa-calendar-alt"></i> <span>Book
						Service</span>
				</a> <a href="${pageContext.request.contextPath}/service/history"
					class="menu-item"> <i class="fas fa-history"></i> <span>Service
						History</span>
				</a> <a href="${pageContext.request.contextPath}/user/vehicles"
					class="menu-item"> <i class="fas fa-car"></i> <span>My
						Vehicles</span>
				</a> <a href="${pageContext.request.contextPath}/user/profile"
					class="menu-item"> <i class="fas fa-user"></i> <span>Profile</span>
				</a> <a href="${pageContext.request.contextPath}/user/feedback"
					class="menu-item"> <i class="fas fa-star"></i> <span>Rate
						Us</span>
				</a> <a href="${pageContext.request.contextPath}/user/reminders"
					class="menu-item"> <i class="fas fa-bell"></i> <span>Reminders</span>
				</a>
			</div>

			<div class="sidebar-footer">
				<a href="${pageContext.request.contextPath}/auth/logout"
					class="logout-item"> <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
				</a>
			</div>
		</div>

		<!-- Main Content -->
		<div class="main-content">
			<div class="top-bar">
				<div class="welcome-text">
					<h2>
						Welcome back,
						<%=user.getFullName()%>!
					</h2>
					<p>Here's what's happening with your vehicles today.</p>
				</div>
				<div class="user-avatar"><%=user.getFullName().charAt(0)%></div>
			</div>

			<!-- Statistics Cards -->
			<div class="stats-grid">
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
						<i class="fas fa-check-circle"></i>
					</div>
					<div class="stat-details">
						<h3>Completed Services</h3>
						<p class="stat-number"><%=completedServices%></p>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon orange">
						<i class="fas fa-car"></i>
					</div>
					<div class="stat-details">
						<h3>My Vehicles</h3>
						<p class="stat-number"><%=myVehicles%></p>
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon purple">
						<i class="fas fa-calendar"></i>
					</div>
					<div class="stat-details">
						<h3>Total Services</h3>
						<p class="stat-number"><%=myServices%></p>
					</div>
				</div>
			</div>

			<div class="content-grid">
				<!-- Quick Actions -->
				<div class="card">
					<div class="card-header">
						<h3>
							<i class="fas fa-bolt"></i> Quick Actions
						</h3>
					</div>
					<div class="card-body">
						<div style="display: flex; gap: 15px; flex-wrap: wrap;">
							<a href="${pageContext.request.contextPath}/service/book"
								class="btn-primary-small"
								style="display: inline-block; padding: 10px 20px; background: linear-gradient(135deg, #E6002E, #3671C6); border-radius: 8px; color: #fff; text-decoration: none;">Book
								Service</a> <a
								href="${pageContext.request.contextPath}/service/history"
								class="btn-primary-small"
								style="display: inline-block; padding: 10px 20px; background: linear-gradient(135deg, #E6002E, #3671C6); border-radius: 8px; color: #fff; text-decoration: none;">View
								History</a>
						</div>
					</div>
				</div>

				<!-- Recent Services -->
				<div class="card">
					<div class="card-header">
						<h3>
							<i class="fas fa-clock"></i> Recent Services
						</h3>
						<a href="${pageContext.request.contextPath}/service/history"
							class="btn-link">View All →</a>
					</div>
					<div class="card-body">
						<%
						if (recentServices != null && !recentServices.isEmpty()) {
						%>
						<table class="data-table">
							<thead>
								<tr>
									<th>Service</th>
									<th>Date</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (ServiceRequest sr : recentServices) {
								%>
								<tr>
									<td><%=sr.getServiceType()%></td>
									<td><%=sr.getPreferredDate() != null ? sr.getPreferredDate() : "N/A"%></td>
									<td><span
										class="status-badge status-<%=sr.getStatus().replace("_", "-")%>"><%=sr.getStatus().replace("_", " ").toUpperCase()%></span></td>
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
							<i class="fas fa-calendar-alt"></i>
							<p>No recent services</p>
							<a href="${pageContext.request.contextPath}/service/book"
								class="btn-primary-small"
								style="display: inline-block; margin-top: 15px;">Book First
								Service</a>
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