<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, java.util.Map, java.util.List, java.util.ArrayList"%>
<%
User admin = (User) session.getAttribute("user");
if (admin == null || !"admin".equals(admin.getRole())) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}

// Get data from request attributes
Integer totalServices = (Integer) request.getAttribute("totalServices");
Integer totalEarnings = (Integer) request.getAttribute("totalEarnings");
Double avgRating = (Double) request.getAttribute("avgRating");
Integer totalUsers = (Integer) request.getAttribute("totalUsers");

Map<String, Integer> statusStats = (Map<String, Integer>) request.getAttribute("statusStats");

// Get monthly data - create default if null
List<String> months = (List<String>) request.getAttribute("months");
List<Double> revenues = (List<Double>) request.getAttribute("revenues");

if (months == null) {
	months = new ArrayList<>();
	String[] monthNames = {"Jan", "Feb", "Mar", "Apr", "May", "Jun"};
	for (String m : monthNames)
		months.add(m);
}
if (revenues == null) {
	revenues = new ArrayList<>();
	for (int i = 0; i < 6; i++)
		revenues.add(0.0);
}

if (totalServices == null)
	totalServices = 0;
if (totalEarnings == null)
	totalEarnings = 0;
if (avgRating == null)
	avgRating = 0.0;
if (totalUsers == null)
	totalUsers = 0;

// Build JSON strings manually
StringBuilder monthsJson = new StringBuilder("[");
for (int i = 0; i < months.size(); i++) {
	if (i > 0)
		monthsJson.append(",");
	monthsJson.append("\"").append(months.get(i)).append("\"");
}
monthsJson.append("]");

StringBuilder revenuesJson = new StringBuilder("[");
for (int i = 0; i < revenues.size(); i++) {
	if (i > 0)
		revenuesJson.append(",");
	revenuesJson.append(revenues.get(i));
}
revenuesJson.append("]");

// Get status counts
int pendingCount = statusStats != null && statusStats.containsKey("pending") ? statusStats.get("pending") : 0;
int inProgressCount = statusStats != null && statusStats.containsKey("in_progress")
		? statusStats.get("in_progress")
		: 0;
int completedCount = statusStats != null && statusStats.containsKey("completed") ? statusStats.get("completed") : 0;
int cancelledCount = statusStats != null && statusStats.containsKey("cancelled") ? statusStats.get("cancelled") : 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reports - ServiceTrack</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
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
	text-align: center;
}

.stat-value {
	font-size: 36px;
	font-weight: bold;
	color: #E6002E;
}

.chart-container {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 20px;
	margin-bottom: 20px;
}

canvas {
	max-height: 300px;
}

.report-section {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

@media ( max-width : 900px) {
	.sidebar {
		width: 80px;
	}
	.logo span, .nav-link span {
		display: none;
	}
	.main-content {
		margin-left: 80px;
	}
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.report-section {
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
					<i class="fas fa-car"></i> <span>ServiceTrack Admin</span>
				</div>
			</div>
			<div class="sidebar-menu">
				<a href="${pageContext.request.contextPath}/admin/dashboard"
					class="menu-item"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a>
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
					class="menu-item active"><i class="fas fa-chart-line"></i><span>Reports</span></a>
			</div>
			<div class="sidebar-footer">
				<a href="${pageContext.request.contextPath}/auth/logout"
					class="logout-item"><i class="fas fa-sign-out-alt"></i><span> Logout</span></a>
			</div>
		</div>

		<!-- Main Content -->
		<div class="main-content">
			<div class="top-bar">
				<div class="welcome-text">
					<h2>Analytics & Reports</h2>
					<p>System performance and statistics</p>
				</div>
				<div class="user-profile">
					<div class="avatar">
						<i class="fas fa-user-circle"></i>
					</div>
					<div class="user-info">
						<span class="name"><%=admin.getFullName()%></span> <span
							class="role">Administrator</span>
					</div>
				</div>
			</div>

			<!-- Statistics Cards -->
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-value"><%=totalServices%></div>
					<p>Total Services</p>
				</div>
				<div class="stat-card">
					<div class="stat-value">
						NPR
						<%=totalEarnings%></div>
					<p>Total Earnings</p>
				</div>
				<div class="stat-card">
					<div class="stat-value"><%=String.format("%.1f", avgRating)%></div>
					<p>Average Rating</p>
				</div>
				<div class="stat-card">
					<div class="stat-value"><%=totalUsers%></div>
					<p>Total Users</p>
				</div>
			</div>

			<!-- Charts -->
			<div class="report-section">
				<div class="chart-container">
					<h3>Service Status Distribution</h3>
					<canvas id="statusChart"></canvas>
				</div>
				<div class="chart-container">
					<h3>Monthly Revenue</h3>
					<canvas id="revenueChart"></canvas>
				</div>
			</div>
		</div>
	</div>

	<script>
		// Status Chart
		new Chart(document.getElementById('statusChart'),
				{
					type : 'doughnut',
					data : {
						labels : [ 'Pending', 'In Progress', 'Completed',
								'Cancelled' ],
						datasets : [ {
							data : [
	<%=pendingCount%>
		,
	<%=inProgressCount%>
		,
	<%=completedCount%>
		,
	<%=cancelledCount%>
		],
							backgroundColor : [ '#FF9800', '#3671C6',
									'#4CAF50', '#E6002E' ],
							borderWidth : 0
						} ]
					},
					options : {
						responsive : true,
						plugins : {
							legend : {
								position : 'bottom',
								labels : {
									color : '#FFF'
								}
							}
						}
					}
				});

		// Revenue Chart
		new Chart(document.getElementById('revenueChart'), {
			type : 'bar',
			data : {
				labels :
	<%=monthsJson.toString()%>
		,
				datasets : [ {
					label : 'Revenue (NPR)',
					data :
	<%=revenuesJson.toString()%>
		,
					backgroundColor : '#3671C6',
					borderRadius : 8
				} ]
			},
			options : {
				responsive : true,
				plugins : {
					legend : {
						labels : {
							color : '#FFF'
						}
					}
				},
				scales : {
					y : {
						ticks : {
							color : '#8A9BB5'
						},
						grid : {
							color : '#2A3548'
						}
					},
					x : {
						ticks : {
							color : '#8A9BB5'
						},
						grid : {
							color : '#2A3548'
						}
					}
				}
			}
		});
	</script>
</body>
</html>