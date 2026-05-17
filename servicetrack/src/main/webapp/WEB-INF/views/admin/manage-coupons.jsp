<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, com.servicetrack.model.Coupon, java.util.List"%>
<%
User admin = (User) session.getAttribute("user");
if (admin == null || !"admin".equals(admin.getRole())) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}
List<Coupon> coupons = (List<Coupon>) request.getAttribute("coupons");
Coupon editCoupon = (Coupon) request.getAttribute("editCoupon");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Coupons - ServiceTrack</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.coupon-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
	gap: 20px;
	margin-top: 20px;
}

.coupon-card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 20px;
}

.coupon-code {
	font-size: 24px;
	font-weight: bold;
	color: #E6002E;
	letter-spacing: 2px;
}

.discount {
	font-size: 32px;
	color: #4CAF50;
	margin: 10px 0;
}

.expiry {
	color: #8a8f99;
	font-size: 12px;
	margin-top: 10px;
}

.used {
	color: #FF9800;
}

.btn-add {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	padding: 10px 20px;
	border: none;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
}

.btn-edit {
	background: #3671C6;
	border: none;
	padding: 5px 10px;
	border-radius: 5px;
	color: #fff;
	cursor: pointer;
	margin-right: 5px;
}

.btn-delete {
	background: #E6002E;
	border: none;
	padding: 5px 10px;
	border-radius: 5px;
	color: #fff;
	cursor: pointer;
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
	width: 500px;
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
					class="menu-item"><i class="fas fa-users"></i><span>Manage
						Users</span></a> <a href="${pageContext.request.contextPath}/admin/packages"
					class="menu-item"><i class="fas fa-box"></i><span>Service
						Packages</span></a> <a
					href="${pageContext.request.contextPath}/admin/coupons"
					class="menu-item active"><i class="fas fa-tag"></i><span>Coupons</span></a>
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
					<h2>Promotional Coupons</h2>
					<p>Manage discount coupons for customers</p>
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

			<div
				style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
				<h1>Promotional Coupons</h1>
				<button class="btn-add" onclick="openAddModal()">+ Add
					Coupon</button>
			</div>

			<div class="coupon-grid">
				<%
				if (coupons != null && !coupons.isEmpty()) {
					for (Coupon c : coupons) {
				%>
				<div class="coupon-card">
					<div class="coupon-code"><%=c.getCode()%></div>
					<div class="discount"><%=c.getDiscountType().equals("percentage")
		? c.getDiscountValue() + "% OFF"
		: "NPR " + c.getDiscountValue() + " OFF"%></div>
					<p><%=c.getDescription() != null ? c.getDescription() : "No description"%></p>
					<p>
						Min Order: NPR
						<%=c.getMinOrderAmount()%></p>
					<p class="expiry">
						Valid until:
						<%=c.getValidUntil()%></p>
					<p class="used">
						Used:
						<%=c.getUsedCount()%>
						/
						<%=c.getUsageLimit()%></p>
					<div style="margin-top: 15px;">
						<button class="btn-edit" onclick="editCoupon(<%=c.getId()%>)">Edit</button>
						<button class="btn-delete" onclick="deleteCoupon(<%=c.getId()%>)">Delete</button>
					</div>
				</div>
				<%
				}
				} else {
				%>
				<div class="empty-state"
					style="grid-column: 1/-1; text-align: center; padding: 60px;">
					<i class="fas fa-tag" style="font-size: 48px; color: #8a8f99;"></i>
					<p>No coupons found</p>
					<button class="btn-add" style="margin-top: 15px;"
						onclick="openAddModal()">Add Your First Coupon</button>
				</div>
				<%
				}
				%>
			</div>
		</main>
	</div>

	<!-- Add/Edit Coupon Modal -->
	<div id="couponModal" class="modal">
		<div class="modal-content">
			<h3 id="modalTitle">Add Coupon</h3>
			<form id="couponForm"
				action="${pageContext.request.contextPath}/admin/coupons/save"
				method="post">
				<input type="hidden" id="couponId" name="couponId"> <input
					type="text" name="code" id="code" placeholder="Coupon Code"
					required> <input type="text" name="description"
					id="description" placeholder="Description"> <select
					name="discountType" id="discountType">
					<option value="percentage">Percentage (%)</option>
					<option value="fixed">Fixed Amount (NPR)</option>
				</select> <input type="number" name="discountValue" id="discountValue"
					placeholder="Discount Value" required> <input type="number"
					name="minOrderAmount" id="minOrderAmount"
					placeholder="Min Order Amount" value="0"> <input
					type="number" name="maxDiscount" id="maxDiscount"
					placeholder="Max Discount (for percentage)"> <input
					type="date" name="validFrom" id="validFrom" required> <input
					type="date" name="validUntil" id="validUntil" required> <input
					type="number" name="usageLimit" id="usageLimit"
					placeholder="Usage Limit" value="1">
				<button type="submit" class="btn-add"
					style="width: 100%; margin-top: 10px;">Save Coupon</button>
			</form>
		</div>
	</div>

	<script>
        function openAddModal() { 
            document.getElementById('modalTitle').innerText = 'Add Coupon'; 
            document.getElementById('couponForm').reset(); 
            document.getElementById('couponId').value = ''; 
            document.getElementById('couponModal').style.display = 'flex'; 
        }
        
        function editCoupon(id) { 
            window.location.href = '${pageContext.request.contextPath}/admin/coupons/edit?id=' + id; 
        }
        
        function deleteCoupon(id) { 
            if(confirm('Delete this coupon?')) 
                window.location.href = '${pageContext.request.contextPath}/admin/coupons/delete?id=' + id; 
        }
        
        function closeModal() {
            document.getElementById('couponModal').style.display = 'none';
        }
        
        window.onclick = function(event) {
            const modal = document.getElementById('couponModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>

	<%-- Edit Coupon Popup Script - Only runs when editCoupon exists --%>
	<%
	if (editCoupon != null) {
	%>
	<script>
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('modalTitle').innerText = 'Edit Coupon';
            document.getElementById('couponId').value = '<%=editCoupon.getId()%>';
            document.getElementById('code').value = '<%=editCoupon.getCode()%>';
            document.getElementById('description').value = '<%=editCoupon.getDescription() != null ? editCoupon.getDescription() : ""%>';
            document.getElementById('discountType').value = '<%=editCoupon.getDiscountType()%>';
            document.getElementById('discountValue').value = '<%=editCoupon.getDiscountValue()%>';
            document.getElementById('minOrderAmount').value = '<%=editCoupon.getMinOrderAmount()%>';
            document.getElementById('maxDiscount').value = '<%=editCoupon.getMaxDiscount() != null ? editCoupon.getMaxDiscount() : ""%>';
            document.getElementById('validFrom').value = '<%=editCoupon.getValidFrom()%>';
            document.getElementById('validUntil').value = '<%=editCoupon.getValidUntil()%>';
            document.getElementById('usageLimit').value = '<%=editCoupon.getUsageLimit()%>';
            document.getElementById('couponModal').style.display = 'flex';
        });
    </script>
	<%
	}
	%>
</body>
</html>