<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, com.servicetrack.model.ServicePackage, java.util.List"%>
<%
User admin = (User) session.getAttribute("user");
if (admin == null || !"admin".equals(admin.getRole())) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}
List<ServicePackage> packages = (List<ServicePackage>) request.getAttribute("packages");
ServicePackage editPackage = (ServicePackage) request.getAttribute("editPackage");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Packages - ServiceTrack Admin</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<style>
.packages-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
	gap: 20px;
	margin-top: 20px;
}

.package-card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	overflow: hidden;
	transition: all 0.3s;
}

.package-card:hover {
	transform: translateY(-5px);
	border-color: #E6002E;
}

.package-header {
	background: linear-gradient(135deg, #1a1d24, #0f1115);
	padding: 20px;
	border-bottom: 1px solid #1a1d24;
	position: relative;
}

.package-name {
	font-size: 20px;
	font-weight: 700;
	margin-bottom: 5px;
	color: #fff;
}

.package-price {
	font-size: 28px;
	font-weight: 800;
	color: #E6002E;
}

.package-price small {
	font-size: 14px;
	font-weight: 400;
	color: #8a8f99;
}

.discount-badge {
	position: absolute;
	top: 15px;
	right: 15px;
	background: #4CAF50;
	color: white;
	padding: 4px 10px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
}

.package-body {
	padding: 20px;
}

.package-description {
	color: #8a8f99;
	margin-bottom: 15px;
	line-height: 1.5;
}

.services-list {
	list-style: none;
	margin-top: 15px;
}

.services-list li {
	padding: 8px 0;
	border-bottom: 1px solid #1a1d24;
	display: flex;
	align-items: center;
	gap: 10px;
	color: #fff;
}

.services-list li i {
	color: #4CAF50;
	font-size: 12px;
}

.package-footer {
	padding: 15px 20px;
	border-top: 1px solid #1a1d24;
	display: flex;
	gap: 10px;
}

.btn-edit {
	flex: 1;
	background: #3671C6;
	border: none;
	padding: 10px;
	border-radius: 8px;
	color: white;
	cursor: pointer;
	font-weight: 600;
}

.btn-delete {
	flex: 1;
	background: #E6002E;
	border: none;
	padding: 10px;
	border-radius: 8px;
	color: white;
	cursor: pointer;
	font-weight: 600;
}

.btn-add {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	padding: 12px 24px;
	border: none;
	border-radius: 10px;
	color: white;
	font-weight: 600;
	cursor: pointer;
	margin-bottom: 20px;
}

.modal {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.8);
	z-index: 1000;
	justify-content: center;
	align-items: center;
}

.modal-content {
	background: #0f1115;
	border-radius: 16px;
	padding: 30px;
	max-width: 550px;
	width: 90%;
	border: 1px solid #1a1d24;
}

.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 1px solid #1a1d24;
}

.modal-header h3 {
	font-size: 20px;
	color: #fff;
}

.close-modal {
	background: none;
	border: none;
	color: #E6002E;
	font-size: 24px;
	cursor: pointer;
}

.form-group {
	margin-bottom: 18px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	color: #8a8f99;
	font-weight: 500;
}

.form-group input, .form-group textarea, .form-group select {
	width: 100%;
	padding: 10px 12px;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: #fff;
	font-family: inherit;
}

.form-group input:focus, .form-group textarea:focus {
	outline: none;
	border-color: #E6002E;
}

.btn-save {
	width: 100%;
	padding: 12px;
	background: linear-gradient(135deg, #E6002E, #3671C6);
	border: none;
	border-radius: 8px;
	color: white;
	font-weight: 600;
	cursor: pointer;
	margin-top: 10px;
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
					class="menu-item active"><i class="fas fa-box"></i><span>Service
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
					<h2>Manage Service Packages</h2>
					<p>Create and manage service packages with discounts</p>
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

			<button class="btn-add" onclick="openAddModal()">
				<i class="fas fa-plus"></i> Add New Package
			</button>

			<div class="packages-grid">
				<%
				if (packages != null && !packages.isEmpty()) {
					for (ServicePackage pkg : packages) {
				%>
				<div class="package-card">
					<div class="package-header">
						<div class="package-name"><%=pkg.getPackageName()%></div>
						<div class="package-price">
							NPR
							<%=String.format("%.0f", pkg.getPrice())%>
							<small>/ package</small>
						</div>
						<%
						if (pkg.getDiscountPercent() > 0) {
						%>
						<div class="discount-badge"><%=pkg.getDiscountPercent()%>%
							OFF
						</div>
						<%
						}
						%>
					</div>
					<div class="package-body">
						<div class="package-description">
							<%=pkg.getDescription() != null ? pkg.getDescription() : "No description available"%>
						</div>
						<ul class="services-list">
							<%
							String[] services = pkg.getServicesIncluded() != null ? pkg.getServicesIncluded().split(",") : new String[]{};
							for (String service : services) {
							%>
							<li><i class="fas fa-check-circle"></i> <%=service.trim()%></li>
							<%
							}
							%>
						</ul>
					</div>
					<div class="package-footer">
						<button class="btn-edit" onclick="editPackage(<%=pkg.getId()%>)">
							<i class="fas fa-edit"></i> Edit
						</button>
						<button class="btn-delete"
							onclick="deletePackage(<%=pkg.getId()%>)">
							<i class="fas fa-trash-alt"></i> Delete
						</button>
					</div>
				</div>
				<%
				}
				} else {
				%>
				<div class="empty-state" style="grid-column: 1/-1;">
					<i class="fas fa-box"></i>
					<p>No service packages found</p>
					<button class="btn-add" style="margin-top: 15px;"
						onclick="openAddModal()">Create Your First Package</button>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</div>

	<!-- Add/Edit Package Modal -->
	<div id="packageModal" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h3 id="modalTitle">Add New Package</h3>
				<button class="close-modal" onclick="closeModal()">&times;</button>
			</div>
			<form id="packageForm"
				action="${pageContext.request.contextPath}/admin/packages/save"
				method="post">
				<input type="hidden" id="packageId" name="packageId">
				<div class="form-group">
					<label>Package Name</label> <input type="text" id="packageName"
						name="packageName" required
						placeholder="e.g., Basic Service Package">
				</div>
				<div class="form-group">
					<label>Description</label>
					<textarea id="description" name="description" rows="2"
						placeholder="Brief description of this package"></textarea>
				</div>
				<div class="form-group">
					<label>Services Included (comma separated)</label>
					<textarea id="servicesIncluded" name="servicesIncluded" rows="2"
						placeholder="e.g., Oil Change, Brake Check, Tire Rotation"></textarea>
				</div>
				<div class="form-group">
					<label>Price (NPR)</label> <input type="number" id="price"
						name="price" required placeholder="e.g., 5000">
				</div>
				<div class="form-group">
					<label>Discount (%)</label> <input type="number"
						id="discountPercent" name="discountPercent" value="0"
						placeholder="e.g., 10">
				</div>
				<button type="submit" class="btn-save">Save Package</button>
			</form>
		</div>
	</div>

	<script>
        function openAddModal() {
            document.getElementById('modalTitle').innerText = 'Add New Package';
            document.getElementById('packageForm').reset();
            document.getElementById('packageId').value = '';
            document.getElementById('packageModal').style.display = 'flex';
        }
        
        function editPackage(id) {
            window.location.href = '${pageContext.request.contextPath}/admin/packages/edit?id=' + id;
        }
        
        function deletePackage(id) {
            if(confirm('Are you sure you want to delete this package?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/packages/delete?id=' + id;
            }
        }
        
        function closeModal() {
            document.getElementById('packageModal').style.display = 'none';
        }
        
        window.onclick = function(event) {
            const modal = document.getElementById('packageModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>

	<%-- Edit Package Popup Script - Only runs when editPackage exists --%>
	<%
	if (editPackage != null) {
	%>
	<script>
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('modalTitle').innerText = 'Edit Package';
            document.getElementById('packageId').value = '<%=editPackage.getId()%>';
            document.getElementById('packageName').value = '<%=editPackage.getPackageName()%>';
            document.getElementById('description').value = '<%=editPackage.getDescription() != null ? editPackage.getDescription() : ""%>';
            document.getElementById('servicesIncluded').value = '<%=editPackage.getServicesIncluded() != null ? editPackage.getServicesIncluded() : ""%>';
            document.getElementById('price').value = '<%=editPackage.getPrice()%>';
            document.getElementById('discountPercent').value = '<%=editPackage.getDiscountPercent()%>';
            document.getElementById('packageModal').style.display = 'flex';
        });
    </script>
	<%
	}
	%>
</body>
</html>