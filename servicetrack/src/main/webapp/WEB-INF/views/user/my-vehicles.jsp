<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, com.servicetrack.model.Vehicle, java.util.List"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}
List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
Vehicle editVehicle = (Vehicle) request.getAttribute("editVehicle");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Vehicles - ServiceTrack</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<style>
.vehicles-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
	gap: 20px;
	margin-top: 20px;
}

.vehicle-card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 20px;
	transition: all 0.3s;
}

.vehicle-card:hover {
	transform: translateY(-3px);
	border-color: #E6002E;
}

.vehicle-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 15px;
}

.vehicle-icon {
	font-size: 40px;
	color: #3671C6;
}

.btn-add {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	padding: 10px 20px;
	border: none;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
	margin-bottom: 20px;
}

.btn-edit, .btn-delete {
	background: none;
	border: none;
	cursor: pointer;
	font-size: 18px;
	margin-left: 10px;
}

.btn-edit {
	color: #FFD700;
}

.btn-delete {
	color: #E6002E;
}

.modal {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.8);
	justify-content: center;
	align-items: center;
}

.modal-content {
	background: #0f1115;
	border-radius: 16px;
	padding: 30px;
	width: 500px;
}

.modal-content input, .modal-content select {
	width: 100%;
	padding: 10px;
	margin: 10px 0;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: #fff;
}

.empty-state {
	text-align: center;
	padding: 60px;
	color: #8a8f99;
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
					class="menu-item active"> <i class="fas fa-car"></i> <span>My
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

		<div class="main-content">
			<div class="top-bar">
				<div class="welcome-text">
					<h2>My Vehicles</h2>
					<p>Manage your registered vehicles</p>
				</div>
				<div class="user-avatar"><%=user.getFullName().charAt(0)%></div>
			</div>

			<button class="btn-add" onclick="openAddModal()">
				<i class="fas fa-plus"></i> Add New Vehicle
			</button>

			<div class="vehicles-grid">
				<%
				if (vehicles != null && !vehicles.isEmpty()) {
					for (Vehicle v : vehicles) {
				%>
				<div class="vehicle-card">
					<div class="vehicle-header">
						<div class="vehicle-icon">
							<i class="fas fa-car-side"></i>
						</div>
						<div>
							<button class="btn-edit" onclick="editVehicle(<%=v.getId()%>)">
								<i class="fas fa-edit"></i>
							</button>
							<button class="btn-delete"
								onclick="deleteVehicle(<%=v.getId()%>)">
								<i class="fas fa-trash-alt"></i>
							</button>
						</div>
					</div>
					<h3><%=v.getBrand()%>
						<%=v.getModel()%></h3>
					<p>
						<i class="fas fa-id-card"></i>
						<%=v.getVehicleNumber()%></p>
					<p>
						<i class="fas fa-calendar"></i> Year:
						<%=v.getYear()%></p>
				</div>
				<%
				}
				} else {
				%>
				<div class="empty-state" style="grid-column: 1/-1;">
					<i class="fas fa-car"></i>
					<p>No vehicles registered yet</p>
					<button class="btn-add" style="margin-top: 15px;"
						onclick="openAddModal()">Add Your First Vehicle</button>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</div>

	<div id="vehicleModal" class="modal">
		<div class="modal-content">
			<h3 id="modalTitle">Add Vehicle</h3>
			<form id="vehicleForm"
				action="${pageContext.request.contextPath}/user/vehicles/save"
				method="post">
				<input type="hidden" id="vehicleId" name="vehicleId"> <input
					type="text" name="brand" id="brand" placeholder="Brand" required>
				<input type="text" name="model" id="model" placeholder="Model"
					required> <input type="text" name="vehicleNumber"
					id="vehicleNumber" placeholder="Vehicle Number" required> <select
					name="year" id="year">
					<%
					for (int y = 2025; y >= 2000; y--) {
					%><option value="<%=y%>"><%=y%></option>
					<%
					}
					%>
				</select>
				<button type="submit" class="btn-add"
					style="width: 100%; margin-top: 10px;">Save Vehicle</button>
			</form>
		</div>
	</div>

	<script>
        function openAddModal() { document.getElementById('modalTitle').innerText = 'Add Vehicle'; document.getElementById('vehicleForm').reset(); document.getElementById('vehicleId').value = ''; document.getElementById('vehicleModal').style.display = 'flex'; }
        function editVehicle(id) { window.location.href = '${pageContext.request.contextPath}/user/vehicles/edit?id=' + id; }
        function deleteVehicle(id) { if(confirm('Delete this vehicle?')) window.location.href = '${pageContext.request.contextPath}/user/vehicles/delete?id=' + id; }
        function closeModal() { document.getElementById('vehicleModal').style.display = 'none'; }
        window.onclick = function(e) { if(e.target == document.getElementById('vehicleModal')) closeModal(); }
    </script>

	<%
	if (editVehicle != null) {
	%>
	<script>
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('modalTitle').innerText = 'Edit Vehicle';
            document.getElementById('vehicleId').value = '<%=editVehicle.getId()%>';
            document.getElementById('brand').value = '<%=editVehicle.getBrand()%>';
            document.getElementById('model').value = '<%=editVehicle.getModel()%>';
            document.getElementById('vehicleNumber').value = '<%=editVehicle.getVehicleNumber()%>';
            document.getElementById('year').value = '<%=editVehicle.getYear()%>';
            document.getElementById('vehicleModal').style.display = 'flex';
        });
    </script>
	<%
	}
	%>
</body>
</html>