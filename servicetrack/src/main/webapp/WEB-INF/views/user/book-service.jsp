<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.servicetrack.model.User, com.servicetrack.model.Vehicle, com.servicetrack.model.ServicePackage, java.util.List"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
	response.sendRedirect(request.getContextPath() + "/auth/login");
	return;
}
List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
List<ServicePackage> packages = (List<ServicePackage>) request.getAttribute("packages");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Book Service - ServiceTrack</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<style>
.booking-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 25px;
}

.service-options {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 10px;
	margin-top: 10px;
}

.service-option {
	padding: 10px;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	cursor: pointer;
	text-align: center;
	transition: all 0.3s;
}

.service-option:hover {
	border-color: #3671C6;
}

.service-option.selected {
	border-color: #E6002E;
	background: rgba(230, 0, 46, 0.1);
}

.price-tag {
	color: #4CAF50;
	font-size: 14px;
	margin-top: 5px;
}

.summary-card {
	background: #1a1d24;
	border-radius: 12px;
	padding: 20px;
	position: sticky;
	top: 20px;
}

.summary-row {
	display: flex;
	justify-content: space-between;
	padding: 10px 0;
	border-bottom: 1px solid #2a2d35;
}

.summary-total {
	font-size: 20px;
	font-weight: bold;
	color: #E6002E;
}

.coupon-input {
	display: flex;
	gap: 10px;
	margin: 15px 0;
}

.coupon-input input {
	flex: 1;
	padding: 10px;
	background: #0f1115;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: #fff;
}

.apply-btn {
	padding: 10px 15px;
	background: #3671C6;
	border: none;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
}

@media ( max-width : 900px) {
	.booking-grid {
		grid-template-columns: 1fr;
	}
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
					class="menu-item active"> <i class="fas fa-calendar-alt"></i> <span>Book
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

		<main class="main-content">
			<div class="top-bar">
				<div class="welcome-text">
					<h1>Book a Service</h1>
					<p>Schedule your vehicle service appointment</p>
				</div>
				<div class="user-profile">
					<div class="user-avatar"><%=user.getFullName().charAt(0)%></div>
					<div class="user-info">
						<span class="name"><%=user.getFullName()%></span> <span
							class="role">Customer</span>
					</div>
				</div>
			</div>

			<%
			if (request.getAttribute("success") != null) {
			%>
			<div class="alert alert-success">
				<i class="fas fa-check-circle"></i>
				<%=request.getAttribute("success")%></div>
			<%
			}
			%>
			<%
			if (request.getAttribute("error") != null) {
			%>
			<div class="alert alert-error">
				<i class="fas fa-exclamation-circle"></i>
				<%=request.getAttribute("error")%></div>
			<%
			}
			%>

			<div class="booking-grid">
				<!-- Booking Form -->
				<div class="card">
					<div class="card-header">
						<h3>
							<i class="fas fa-clipboard-list"></i> New Service Request
						</h3>
					</div>
					<div class="card-body">
						<form id="bookingForm"
							action="${pageContext.request.contextPath}/service/book"
							method="post">
							<div class="form-group">
								<label><i class="fas fa-car"></i> Select Vehicle</label> <select
									name="vehicleId" id="vehicleId" required>
									<option value="">-- Select a vehicle --</option>
									<%
									if (vehicles != null) {
										for (Vehicle v : vehicles) {
									%>
									<option value="<%=v.getId()%>"><%=v.getBrand()%>
										<%=v.getModel()%> -
										<%=v.getVehicleNumber()%> (<%=v.getYear()%>)
									</option>
									<%
									}
									}
									%>
								</select>
							</div>

							<div class="form-group">
								<label><i class="fas fa-wrench"></i> Service Type</label> <select
									name="serviceType" id="serviceType" required>
									<option value="">-- Select service type --</option>
									<option value="Oil Change">Oil Change - NPR 2,500</option>
									<option value="Engine Repair">Engine Repair - NPR
										15,000</option>
									<option value="Brake Service">Brake Service - NPR
										3,500</option>
									<option value="Tire Rotation">Tire Rotation - NPR
										1,500</option>
									<option value="Battery Replacement">Battery
										Replacement - NPR 8,000</option>
									<option value="AC Service">AC Service - NPR 4,000</option>
									<option value="Full Service">Full Service - NPR 12,000</option>
								</select>
							</div>

							<div class="form-group">
								<label><i class="fas fa-calendar"></i> Preferred Date</label> <input
									type="date" name="preferredDate" id="preferredDate" required>
							</div>

							<div class="form-group">
								<label><i class="fas fa-align-left"></i> Description</label>
								<textarea name="description" rows="3"
									placeholder="Any specific issues or requirements..."></textarea>
							</div>

							<div class="form-group">
								<label><i class="fas fa-credit-card"></i> Payment Method</label>
								<select name="paymentMethod" id="paymentMethod">
									<option value="cash">Cash on Delivery</option>
									<option value="esewa">eSewa</option>
									<option value="khalti">Khalti</option>
									<option value="card">Credit/Debit Card</option>
								</select>
							</div>

							<input type="hidden" name="totalAmount" id="totalAmount">
							<input type="hidden" name="discount" id="discount" value="0">
							<input type="hidden" name="couponCode" id="couponCode">

							<button type="submit" class="btn-primary"
								style="width: 100%; margin-top: 10px;">
								<i class="fas fa-calendar-check"></i> Book Service
							</button>
						</form>
					</div>
				</div>

				<!-- Add Vehicle & Summary -->
				<div>
					<div class="card">
						<div class="card-header">
							<h3>
								<i class="fas fa-plus-circle"></i> Add New Vehicle
							</h3>
						</div>
						<div class="card-body">
							<form
								action="${pageContext.request.contextPath}/service/add-vehicle"
								method="post">
								<div class="form-group">
									<input type="text" name="brand"
										placeholder="Brand (e.g., Toyota, Honda)" required>
								</div>
								<div class="form-group">
									<input type="text" name="model"
										placeholder="Model (e.g., Camry, Civic)" required>
								</div>
								<div class="form-group">
									<input type="text" name="vehicleNumber"
										placeholder="Vehicle Number (e.g., BA 2 1234)" required>
								</div>
								<div class="form-group">
									<select name="year" required>
										<option value="">Select Year</option>
										<%
										for (int y = 2025; y >= 2000; y--) {
										%>
										<option value="<%=y%>"><%=y%></option>
										<%
										}
										%>
									</select>
								</div>
								<button type="submit" class="btn-primary" style="width: 100%;">
									<i class="fas fa-plus"></i> Add Vehicle
								</button>
							</form>
						</div>
					</div>

					<!-- Summary Card -->
					<div class="summary-card" style="margin-top: 20px;">
						<h3>
							<i class="fas fa-receipt"></i> Order Summary
						</h3>
						<div class="summary-row">
							<span>Service Charge:</span> <span id="serviceCharge">NPR
								0</span>
						</div>
						<div class="coupon-input">
							<input type="text" id="couponInput" placeholder="Coupon Code">
							<button class="apply-btn" onclick="applyCoupon()">Apply</button>
						</div>
						<div class="summary-row">
							<span>Discount:</span> <span id="discountDisplay"
								style="color: #4CAF50;">NPR 0</span>
						</div>
						<div class="summary-row summary-total">
							<span>Total Amount:</span> <span id="totalDisplay">NPR 0</span>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>

	<script>
        const servicePrices = {
            "Oil Change": 2500,
            "Engine Repair": 15000,
            "Brake Service": 3500,
            "Tire Rotation": 1500,
            "Battery Replacement": 8000,
            "AC Service": 4000,
            "Full Service": 12000
        };
        
        const serviceType = document.getElementById('serviceType');
        const totalAmountInput = document.getElementById('totalAmount');
        const serviceChargeSpan = document.getElementById('serviceCharge');
        const totalDisplaySpan = document.getElementById('totalDisplay');
        const discountDisplaySpan = document.getElementById('discountDisplay');
        const discountInput = document.getElementById('discount');
        const couponCodeInput = document.getElementById('couponCode');
        
        let currentPrice = 0;
        let currentDiscount = 0;
        
        serviceType.addEventListener('change', function() {
            currentPrice = servicePrices[this.value] || 0;
            serviceChargeSpan.innerText = 'NPR ' + currentPrice;
            updateTotal();
        });
        
        function updateTotal() {
            const finalAmount = currentPrice - currentDiscount;
            totalAmountInput.value = finalAmount;
            totalDisplaySpan.innerText = 'NPR ' + finalAmount;
        }
        
        function applyCoupon() {
            const coupon = document.getElementById('couponInput').value;
            if (!coupon) {
                alert('Please enter a coupon code');
                return;
            }
            fetch('${pageContext.request.contextPath}/service/validate-coupon?code=' + coupon + '&amount=' + currentPrice)
                .then(res => res.json())
                .then(data => {
                    currentDiscount = data.discount;
                    discountDisplaySpan.innerText = 'NPR ' + currentDiscount;
                    couponCodeInput.value = coupon;
                    discountInput.value = currentDiscount;
                    updateTotal();
                    if(currentDiscount > 0) {
                        alert('Coupon applied! You saved NPR ' + currentDiscount);
                    } else {
                        alert('Invalid coupon code');
                    }
                });
        }
        
        // Set min date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('preferredDate').min = today;
    </script>
</body>
</html>