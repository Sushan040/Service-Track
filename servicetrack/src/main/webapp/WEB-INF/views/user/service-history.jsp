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
List<ServiceRequest> services = (List<ServiceRequest>) request.getAttribute("services");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Service History - ServiceTrack</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<style>
.filter-bar {
	display: flex;
	gap: 10px;
	margin-bottom: 20px;
	flex-wrap: wrap;
}

.filter-btn {
	padding: 8px 16px;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: #8a8f99;
	cursor: pointer;
	transition: all 0.3s;
}

.filter-btn:hover, .filter-btn.active {
	background: #3671C6;
	color: white;
	border-color: #3671C6;
}

.data-table td .status-badge {
	display: inline-block;
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
}

.empty-state {
	text-align: center;
	padding: 60px;
	color: #8a8f99;
}

.empty-state i {
	font-size: 48px;
	margin-bottom: 15px;
	color: #3671C6;
}

.btn-book {
	display: inline-block;
	margin-top: 15px;
	background: linear-gradient(135deg, #E6002E, #3671C6);
	padding: 10px 20px;
	border-radius: 8px;
	color: #fff;
	text-decoration: none;
}
</style>
</head>
<body>
	<div class="app-container">
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
					class="menu-item active"> <i class="fas fa-history"></i> <span>Service
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

		<main class="main-content">
			<div class="top-bar">
				<div class="welcome-text">
					<h1>Service History</h1>
					<p>View all your past and current service requests</p>
				</div>
				<div class="user-profile">
					<div class="user-avatar"><%=user.getFullName().charAt(0)%></div>
					<div class="user-info">
						<span class="name"><%=user.getFullName()%></span> <span
							class="role">Customer</span>
					</div>
				</div>
			</div>

			<div class="card">
				<div class="card-header">
					<h3>
						<i class="fas fa-history"></i> Your Service Requests
					</h3>
					<a href="${pageContext.request.contextPath}/service/book"
						style="color: #3671C6; font-size: 13px;"> <i
						class="fas fa-plus"></i> New Service
					</a>
				</div>
				<div class="card-body">
					<div class="filter-bar">
						<button class="filter-btn active" data-filter="all">All</button>
						<button class="filter-btn" data-filter="pending">Pending</button>
						<button class="filter-btn" data-filter="in_progress">In
							Progress</button>
						<button class="filter-btn" data-filter="completed">Completed</button>
						<button class="filter-btn" data-filter="cancelled">Cancelled</button>
					</div>

					<table class="data-table" id="historyTable">
						<thead>
							<tr>
								<th>ID</th>
								<th>Vehicle</th>
								<th>Service Type</th>
								<th>Preferred Date</th>
								<th>Status</th>
								<th>Amount</th>
								<th>Payment</th>
								<th>Booked On</th>
							</tr>
						</thead>
						<tbody>
							<%
							if (services != null && !services.isEmpty()) {
								for (ServiceRequest sr : services) {
							%>
							<tr data-status="<%=sr.getStatus()%>">
								<td>#<%=sr.getId()%></td>
								<td><%=sr.getVehicleModel() != null ? sr.getVehicleModel() : "N/A"%><br>
									<small style="color: #8a8f99;"><%=sr.getVehicleNumber() != null ? sr.getVehicleNumber() : ""%></small>
								</td>
								<td><%=sr.getServiceType()%></td>
								<td><%=sr.getPreferredDate() != null ? sr.getPreferredDate() : "Not set"%></td>
								<td><span
									class="status-badge status-<%=sr.getStatus().replace("_", "-")%>">
										<%=sr.getStatus().replace("_", " ").toUpperCase()%>
								</span></td>
								<td>NPR <%=String.format("%.0f", sr.getTotalAmount())%></td>
								<td><span
									class="status-badge <%="paid".equals(sr.getPaymentStatus()) ? "status-completed" : "status-pending"%>">
										<%=sr.getPaymentStatus() != null ? sr.getPaymentStatus().toUpperCase() : "UNPAID"%>
								</span></td>
								<td><%=sr.getCreatedAt() != null ? sr.getCreatedAt().toString().substring(0, 10) : "N/A"%></td>
							</tr>
							<%
							}
							} else {
							%>
							<tr>
								<td colspan="8" style="text-align: center;">
									<div class="empty-state">
										<i class="fas fa-calendar-alt"></i>
										<p>No service requests found</p>
										<a href="${pageContext.request.contextPath}/service/book"
											class="btn-book">Book Your First Service</a>
									</div>
								</td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>
			</div>
		</main>
	</div>

	<script>
        // Filter functionality
        const filterBtns = document.querySelectorAll('.filter-btn');
        const tableRows = document.querySelectorAll('#historyTable tbody tr');
        
        filterBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                filterBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                const filter = this.dataset.filter;
                tableRows.forEach(row => {
                    if (row.dataset) {
                        if (filter === 'all' || row.dataset.status === filter) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    }
                });
            });
        });
    </script>
</body>
</html>