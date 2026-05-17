<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, com.servicetrack.model.Reminder, java.util.List"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}
List<Reminder> reminders = (List<Reminder>) request.getAttribute("reminders");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Service Reminders - ServiceTrack</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Inter', sans-serif;
	background: #0a0c10;
	color: #fff;
}

.container {
	max-width: 900px;
	margin: 50px auto;
	padding: 20px;
}

.reminder-card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 20px;
	margin-bottom: 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.reminder-card.warning {
	border-left: 4px solid #FF9800;
}

.reminder-card.urgent {
	border-left: 4px solid #E6002E;
}

.btn-remind {
	background: #3671C6;
	border: none;
	padding: 8px 16px;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
}
</style>
</head>
<body>

		<!-- Sidebar -->
		<div class="sidebar">
			<div class="sidebar-header">
				<div class="logo">
					<i class="fas fa-car"></i> <span>ServiceTrack</span>
				</div>
			</div>

			<div class="sidebar-menu">
				<a href="${pageContext.request.contextPath}/user/dashboard"
					class="menu-item"> <i class="fas fa-tachometer-alt"></i>
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
					class="menu-item active"> <i class="fas fa-bell"></i> <span>Reminders</span>
				</a>
			</div>

			<div class="sidebar-footer">
				<a href="${pageContext.request.contextPath}/auth/logout"
					class="logout-item"> <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
				</a>
			</div>
		</div>
	<div class="container">
		<h2>Service Reminders</h2>

		<%
		if (reminders != null && !reminders.isEmpty()) {
		%>
		<%
		for (Reminder r : reminders) {
		%>
		<div class="reminder-card">
			<div>
				<h3><%=r.getReminderType().toUpperCase()%>
					Reminder
				</h3>
				<p><%=r.getVehicleModel()%>
					-
					<%=r.getVehicleNumber()%></p>
				<p><%=r.getMessage()%></p>
				<small>Due: <%=r.getReminderDate()%></small>
			</div>
			<button class="btn-remind">Dismiss</button>
		</div>
		<%
		}
		%>
		<%
		} else {
		%>
		<div class="reminder-card">
			<p>No active reminders. Your vehicles are up to date!</p>
		</div>
		<%
		}
		%>
	</div>
</body>
</html>