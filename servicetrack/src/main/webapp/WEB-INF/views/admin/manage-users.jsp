<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.servicetrack.model.User, java.util.List"%>
<%
User admin = (User) session.getAttribute("user");
if (admin == null || !"admin".equals(admin.getRole())) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}
List<User> users = (List<User>) request.getAttribute("users");
User editUser = (User) request.getAttribute("editUser");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Users - ServiceTrack Admin</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.user-table {
	width: 100%;
	border-collapse: collapse;
	background: #0f1115;
	border-radius: 16px;
	overflow: hidden;
}

.user-table th, .user-table td {
	padding: 12px;
	text-align: left;
	border-bottom: 1px solid #1a1d24;
}

.user-table th {
	color: #3671C6;
}

.user-table td {
	color: #fff;
}

.role-badge {
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 12px;
}

.role-admin {
	background: rgba(230, 0, 46, 0.2);
	color: #E6002E;
}

.role-customer {
	background: rgba(54, 113, 198, 0.2);
	color: #3671C6;
}

.status-badge {
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 12px;
}

.status-active {
	background: rgba(76, 175, 80, 0.2);
	color: #4CAF50;
}

.status-locked {
	background: rgba(230, 0, 46, 0.2);
	color: #E6002E;
}

.action-btn {
	background: none;
	border: none;
	cursor: pointer;
	margin: 0 5px;
	font-size: 16px;
	transition: all 0.3s;
}

.edit-btn {
	color: #FFD700;
}

.edit-btn:hover {
	color: #FFA500;
	transform: scale(1.1);
}

.delete-btn {
	color: #E6002E;
}

.delete-btn:hover {
	color: #ff3333;
	transform: scale(1.1);
}

.unlock-btn {
	color: #4CAF50;
}

.unlock-btn:hover {
	color: #45a049;
	transform: scale(1.1);
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
	border: 1px solid #1a1d24;
}

.modal-content input, .modal-content select, .modal-content textarea {
	width: 100%;
	padding: 10px;
	margin: 10px 0;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: #fff;
}

.close-modal {
	float: right;
	font-size: 24px;
	cursor: pointer;
	color: #E6002E;
}

.alert-success {
	background: rgba(76, 175, 80, 0.2);
	color: #4CAF50;
	padding: 12px 15px;
	border-radius: 8px;
	margin-bottom: 20px;
}

.unlock-btn {
	color: #4CAF50;
	background: none;
	border: none;
	cursor: pointer;
	margin: 0 5px;
	font-size: 16px;
	transition: all 0.3s;
}

.unlock-btn:hover {
	color: #45a049;
	transform: scale(1.1);
}

.alert-error {
	background: rgba(230, 0, 46, 0.2);
	color: #E6002E;
	padding: 12px 15px;
	border-radius: 8px;
	margin-bottom: 20px;
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
					class="menu-item active"><i class="fas fa-users"></i><span>Manage
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

		<main class="main-content">
			<div class="top-bar">
				<div class="welcome-text">
					<h2>Manage Users</h2>
					<p>View and manage all registered users</p>
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

			<div
				style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
				<h1>Manage Users</h1>
			</div>
			<table class="user-table">
				<thead>
					<tr>
						<th>ID</th>
						<th>Name</th>
						<th>Email</th>
						<th>Phone</th>
						<th>Role</th>
						<th>Status</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<%
					if (users != null && !users.isEmpty()) {
						for (User u : users) {
					%>
					<tr>
						<td><%=u.getId()%></td>
						<td><%=u.getFullName()%></td>
						<td><%=u.getEmail()%></td>
						<td><%=u.getPhone() != null ? u.getPhone() : "N/A"%></td>
						<td><span class="role-badge role-<%=u.getRole()%>"><%=u.getRole().toUpperCase()%></span></td>
						<td>
							<%
							if (u.isAccountLocked()) {
							%> <span
							style="background: rgba(230, 0, 46, 0.2); color: #E6002E; padding: 4px 12px; border-radius: 20px; font-size: 12px;">
								<i class="fas fa-lock"></i> Locked
						</span> <%
 } else {
 %> <span
							style="background: rgba(76, 175, 80, 0.2); color: #4CAF50; padding: 4px 12px; border-radius: 20px; font-size: 12px;">
								<i class="fas fa-check-circle"></i> Active
						</span> <%
 }
 %>
						</td>
						<td>
							<button class="action-btn edit-btn"
								onclick="editUser(<%=u.getId()%>)">
								<i class="fas fa-edit"></i>
							</button> <%
 if (u.isAccountLocked()) {
 %>
							<button class="action-btn" onclick="unlockUser(<%=u.getId()%>)"
								style="color: #4CAF50; background: none; border: none; cursor: pointer; font-size: 16px;">
								<i class="fas fa-unlock-alt"></i>
							</button> <%
 }
 %> <%
 if (!"admin".equals(u.getRole()) || u.getId() != admin.getId()) {
 %>
							<button class="action-btn delete-btn"
								onclick="deleteUser(<%=u.getId()%>)">
								<i class="fas fa-trash-alt"></i>
							</button> <%
 }
 %>
						</td>
					</tr>
					<%
					}
					} else {
					%>
					<tr>
						<td colspan="7" style="text-align: center;">No users found</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</main>
	</div>

	<!-- Add/Edit User Modal -->
	<div id="userModal" class="modal">
		<div class="modal-content">
			<span class="close-modal" onclick="closeModal()">&times;</span>
			<h3 id="modalTitle">Add User</h3>
			<form id="userForm"
				action="${pageContext.request.contextPath}/admin/users/save"
				method="post">
				<input type="hidden" id="userId" name="userId"> <input
					type="text" name="fullName" id="fullName" placeholder="Full Name"
					required> <input type="email" name="email" id="email"
					placeholder="Email" required> <input type="text"
					name="phone" id="phone" placeholder="Phone">
				<textarea name="address" id="address" rows="2" placeholder="Address"></textarea>
				<select name="role" id="role">
					<option value="customer">Customer</option>
					<option value="admin">Admin</option>
				</select>
				<button type="submit" class="btn-add"
					style="width: 100%; margin-top: 10px;">Save User</button>
			</form>
		</div>
	</div>

	<script>
        function openAddModal() {
            document.getElementById('modalTitle').innerText = 'Add User';
            document.getElementById('userForm').reset();
            document.getElementById('userId').value = '';
            document.getElementById('userModal').style.display = 'flex';
        }
        
        function editUser(id) {
            window.location.href = '${pageContext.request.contextPath}/admin/users/edit?id=' + id;
        }
        
        function deleteUser(id) {
            if(confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
                window.location.href = '${pageContext.request.contextPath}/admin/users/delete?id=' + id;
            }
        }
        
        function unlockUser(id) {
            if(confirm('Are you sure you want to unlock this user account?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/users/unlock?id=' + id;
            }
        }
        
        function closeModal() {
            document.getElementById('userModal').style.display = 'none';
        }
        
        window.onclick = function(event) {
            const modal = document.getElementById('userModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
	<%
	if (editUser != null) {
	%>
	<script>
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('modalTitle').innerText = 'Edit User';
            document.getElementById('userId').value = '<%=editUser.getId()%>';
            document.getElementById('fullName').value = '<%=editUser.getFullName()%>';
            document.getElementById('email').value = '<%=editUser.getEmail()%>';
            document.getElementById('phone').value = '<%=editUser.getPhone() != null ? editUser.getPhone() : ""%>';
            document.getElementById('address').value = '<%=editUser.getAddress() != null ? editUser.getAddress() : ""%>';
            document.getElementById('role').value = '<%=editUser.getRole()%>';
            document.getElementById('userModal').style.display = 'flex';
        });
    </script>
	<%
	}
	%>
</body>
</html>