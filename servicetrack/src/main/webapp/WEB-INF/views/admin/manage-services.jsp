<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, com.servicetrack.model.ServiceRequest, java.util.List"%>
<%
User admin = (User) session.getAttribute("user");
if (admin == null || !"admin".equals(admin.getRole())) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}
List<ServiceRequest> services = (List<ServiceRequest>) request.getAttribute("services");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Services - ServiceTrack Admin</title>
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

.search-bar {
	display: flex;
	gap: 10px;
	margin-bottom: 20px;
}

.search-bar input {
	flex: 1;
	padding: 10px 15px;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: #fff;
}

.search-bar input::placeholder {
	color: #8a8f99;
}

.search-bar button {
	padding: 10px 20px;
	background: #3671C6;
	border: none;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
}

.status-select {
	padding: 6px 10px;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 6px;
	color: #fff;
	cursor: pointer;
}

.status-select:hover {
	border-color: #3671C6;
}

.data-table {
	width: 100%;
	border-collapse: collapse;
}

.data-table th, .data-table td {
	padding: 12px;
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

.data-table tr:hover {
	background: rgba(54, 113, 198, 0.05);
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

.delete-btn {
	background: none;
	border: none;
	color: #E6002E;
	cursor: pointer;
	font-size: 16px;
	transition: color 0.3s;
}

.delete-btn:hover {
	color: #ff3333;
}

.empty-state {
	text-align: center;
	padding: 60px;
	color: #8a8f99;
}

.empty-state i {
	font-size: 48px;
	margin-bottom: 15px;
}

.alert-success {
	background: rgba(76, 175, 80, 0.2);
	color: #4CAF50;
	padding: 12px 15px;
	border-radius: 8px;
	margin-bottom: 20px;
}

.alert-error {
	background: rgba(230, 0, 46, 0.2);
	color: #E6002E;
	padding: 12px 15px;
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
					<i class="fas fa-car"></i> <span>ServiceTrack Admin</span>
				</div>
			</div>
			<div class="sidebar-menu">
				<a href="${pageContext.request.contextPath}/admin/dashboard"
					class="menu-item"> <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
				</a> <a href="${pageContext.request.contextPath}/service/admin/manage"
					class="menu-item active"> <i class="fas fa-tools"></i> <span>Service
						Requests</span>
				</a> <a href="${pageContext.request.contextPath}/admin/users"
					class="menu-item"> <i class="fas fa-users"></i> <span>Manage
						Users</span>
				</a> <a href="${pageContext.request.contextPath}/admin/packages"
					class="menu-item"> <i class="fas fa-box"></i> <span>Service
						Packages</span>
				</a> <a href="${pageContext.request.contextPath}/admin/coupons"
					class="menu-item"> <i class="fas fa-tag"></i> <span>Coupons</span>
				</a> <a href="${pageContext.request.contextPath}/admin/reports"
					class="menu-item"> <i class="fas fa-chart-line"></i> <span>Reports</span>
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
					<h2>Manage Service Requests</h2>
					<p>View, update status, and manage all customer service
						requests</p>
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

			<%
			if (request.getSession().getAttribute("success") != null) {
			%>
			<div class="alert-success">
				<i class="fas fa-check-circle"></i>
				<%=request.getSession().getAttribute("success")%>
			</div>
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
				<%=request.getSession().getAttribute("error")%>
			</div>
			<%
			request.getSession().removeAttribute("error");
			%>
			<%
			}
			%>

			<div class="search-bar">
				<input type="text" id="searchInput"
					placeholder="Search by customer name or vehicle..."
					onkeyup="searchTable()">
				<button onclick="searchTable()">
					<i class="fas fa-search"></i> Search
				</button>
			</div>

			<div class="filter-bar">
				<button class="filter-btn active" data-filter="all">All</button>
				<button class="filter-btn" data-filter="pending">Pending</button>
				<button class="filter-btn" data-filter="in_progress">In
					Progress</button>
				<button class="filter-btn" data-filter="completed">Completed</button>
				<button class="filter-btn" data-filter="cancelled">Cancelled</button>
			</div>

			<div class="card">
				<div class="card-header">
					<h3>
						<i class="fas fa-list"></i> All Service Requests
					</h3>
				</div>
				<div class="card-body">
					<%
					if (services != null && !services.isEmpty()) {
					%>
					<table class="data-table" id="serviceTable">
						<thead>
							<tr>
								<th>ID</th>
								<th>Customer</th>
								<th>Vehicle</th>
								<th>Service Type</th>
								<th>Preferred Date</th>
								<th>Status</th>
								<th>Amount</th>
								<th>Payment</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (ServiceRequest sr : services) {
							%>
							<tr data-status="<%=sr.getStatus()%>">
								<td>#<%=sr.getId()%></td>
								<td><%=sr.getCustomerName() != null ? sr.getCustomerName() : "N/A"%></td>
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
								<td>
									<form
										action="${pageContext.request.contextPath}/service/status"
										method="post" style="display: inline;">
										<input type="hidden" name="id" value="<%=sr.getId()%>">
										<select name="status" class="status-select"
											onchange="this.form.submit()">
											<option value="pending"
												<%="pending".equals(sr.getStatus()) ? "selected" : ""%>>Pending</option>
											<option value="in_progress"
												<%="in_progress".equals(sr.getStatus()) ? "selected" : ""%>>In
												Progress</option>
											<option value="completed"
												<%="completed".equals(sr.getStatus()) ? "selected" : ""%>>Completed</option>
											<option value="cancelled"
												<%="cancelled".equals(sr.getStatus()) ? "selected" : ""%>>Cancelled</option>
										</select>
									</form>
									<form
										action="${pageContext.request.contextPath}/service/delete"
										method="post"
										onsubmit="return confirm('Are you sure you want to delete this service request?')"
										style="display: inline; margin-left: 5px;">
										<input type="hidden" name="id" value="<%=sr.getId()%>">
										<button type="submit" class="delete-btn" title="Delete">
											<i class="fas fa-trash-alt"></i>
										</button>
									</form>
								</td>
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
	</div>

	<script>
        // Filter functionality
        const filterBtns = document.querySelectorAll('.filter-btn');
        const tableRows = document.querySelectorAll('#serviceTable tbody tr');
        
        filterBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                filterBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                const filter = this.dataset.filter;
                tableRows.forEach(row => {
                    if (filter === 'all' || row.dataset.status === filter) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        });
        
        // Search functionality
        function searchTable() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const rows = document.querySelectorAll('#serviceTable tbody tr');
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(filter)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>