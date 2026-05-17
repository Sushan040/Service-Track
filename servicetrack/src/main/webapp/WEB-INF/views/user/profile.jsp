<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.servicetrack.model.User"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}

Integer vehicleCount = (Integer) request.getAttribute("vehicleCount");
Integer serviceCount = (Integer) request.getAttribute("serviceCount");
Integer completedCount = (Integer) request.getAttribute("completedCount");

if (vehicleCount == null)
	vehicleCount = 0;
if (serviceCount == null)
	serviceCount = 0;
if (completedCount == null)
	completedCount = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile - ServiceTrack</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<style>
.profile-container {
	max-width: 600px;
	margin: 0 auto;
}

.avatar {
	width: 100px;
	height: 100px;
	background: linear-gradient(135deg, #E6002E, #3671C6);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 48px;
	margin: 0 auto 20px;
}

.profile-card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 25px;
	margin-bottom: 20px;
}

.info-row {
	display: flex;
	padding: 12px 0;
	border-bottom: 1px solid #1a1d24;
}

.info-label {
	width: 130px;
	color: #8a8f99;
}

.info-value {
	flex: 1;
	color: #fff;
}

.info-value input, .info-value textarea {
	width: 100%;
	padding: 8px;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: #fff;
}

.btn-save {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	padding: 12px 24px;
	border: none;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
	width: 100%;
	margin-top: 10px;
}

.stats-row {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
	margin-bottom: 20px;
}

.stat-box {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 12px;
	padding: 15px;
	text-align: center;
}

.stat-number {
	font-size: 28px;
	font-weight: bold;
	color: #E6002E;
}

.stat-label {
	color: #8a8f99;
	font-size: 12px;
	margin-top: 5px;
}

.alert-success {
	background: rgba(76, 175, 80, 0.2);
	color: #4CAF50;
	padding: 12px;
	border-radius: 8px;
	margin-bottom: 20px;
}

.alert-error {
	background: rgba(230, 0, 46, 0.2);
	color: #E6002E;
	padding: 12px;
	border-radius: 8px;
	margin-bottom: 20px;
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
					class="menu-item active"> <i class="fas fa-user"></i> <span>Profile</span>
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

		<div class="main-content">
			<div class="top-bar">
				<div class="welcome-text">
					<h2>My Profile</h2>
					<p>Manage your account information</p>
				</div>
				<div class="user-avatar"><%=user.getFullName().charAt(0)%></div>
			</div>

			<%
			if (request.getSession().getAttribute("success") != null) {
			%>
			<div class="alert-success">
				<i class="fas fa-check-circle"></i>
				<%=request.getSession().getAttribute("success")%></div>
			<%
			request.getSession().removeAttribute("success");
			%>
			<%
			}
			%>
			<%
			if (request.getSession().getAttribute("error") != null) {
			%>
			<div class="alert-error">
				<i class="fas fa-exclamation-circle"></i>
				<%=request.getSession().getAttribute("error")%></div>
			<%
			request.getSession().removeAttribute("error");
			%>
			<%
			}
			%>

			<div class="profile-container">
				<div class="avatar"><%=user.getFullName().charAt(0)%></div>

				<div class="stats-row">
					<div class="stat-box">
						<div class="stat-number"><%=vehicleCount%></div>
						<div class="stat-label">Vehicles</div>
					</div>
					<div class="stat-box">
						<div class="stat-number"><%=serviceCount%></div>
						<div class="stat-label">Services</div>
					</div>
					<div class="stat-box">
						<div class="stat-number"><%=completedCount%></div>
						<div class="stat-label">Completed</div>
					</div>
				</div>

				<div class="profile-card">
					<h3>Profile Information</h3>
					<form
						action="${pageContext.request.contextPath}/user/profile/update"
						method="post">
						<div class="info-row">
							<div class="info-label">Full Name:</div>
							<div class="info-value">
								<input type="text" name="fullName"
									value="<%=user.getFullName()%>">
							</div>
						</div>
						<div class="info-row">
							<div class="info-label">Email:</div>
							<div class="info-value">
								<input type="email" name="email" value="<%=user.getEmail()%>">
							</div>
						</div>
						<div class="info-row">
							<div class="info-label">Phone:</div>
							<div class="info-value">
								<input type="text" name="phone"
									value="<%=user.getPhone() != null ? user.getPhone() : ""%>">
							</div>
						</div>
						<div class="info-row">
							<div class="info-label">Address:</div>
							<div class="info-value">
								<textarea name="address" rows="2"><%=user.getAddress() != null ? user.getAddress() : ""%></textarea>
							</div>
						</div>
						<button type="submit" class="btn-save">Update Profile</button>
					</form>
				</div>

				<div class="profile-card">
					<h3>Change Password</h3>
					<form
						action="${pageContext.request.contextPath}/user/profile/password"
						method="post">
						<div class="info-row">
							<div class="info-label">Current Password:</div>
							<div class="info-value">
								<input type="password" name="currentPassword" required>
							</div>
						</div>
						<div class="info-row">
							<div class="info-label">New Password:</div>
							<div class="info-value">
								<input type="password" name="newPassword" required>
							</div>
						</div>
						<div class="info-row">
							<div class="info-label">Confirm Password:</div>
							<div class="info-value">
								<input type="password" name="confirmPassword" required>
							</div>
						</div>
						<button type="submit" class="btn-save">Change Password</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>