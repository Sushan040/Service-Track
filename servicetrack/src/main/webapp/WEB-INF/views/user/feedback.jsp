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
List<ServiceRequest> completedServices = (List<ServiceRequest>) request.getAttribute("completedServices");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Rate & Review - ServiceTrack</title>
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

.navbar {
	background: #0f1115;
	border-bottom: 1px solid #1a1d24;
	padding: 15px 40px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.logo {
	font-size: 24px;
	font-weight: 800;
}

.logo span {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	-webkit-background-clip: text;
	background-clip: text;
	color: transparent;
}

.nav-links a {
	color: #8a8f99;
	text-decoration: none;
	margin-left: 30px;
}

.nav-links a:hover {
	color: #E6002E;
}

.container {
	max-width: 800px;
	margin: 50px auto;
	padding: 20px;
}

.card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 25px;
	margin-bottom: 20px;
}

.rating {
	display: flex;
	gap: 10px;
	margin: 15px 0;
}

.rating i {
	font-size: 30px;
	cursor: pointer;
	color: #555;
}

.rating i:hover, .rating i.active {
	color: #FFD700;
}

textarea {
	width: 100%;
	padding: 12px;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: #fff;
	margin: 15px 0;
	font-family: inherit;
}

.btn-submit {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	padding: 12px 24px;
	border: none;
	border-radius: 8px;
	color: #fff;
	cursor: pointer;
	font-weight: 600;
}

.service-item {
	padding: 15px;
	border-bottom: 1px solid #1a1d24;
}

.service-item:last-child {
	border-bottom: none;
}

.empty-state {
	text-align: center;
	padding: 60px;
	color: #8a8f99;
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

@media ( max-width : 768px) {
	.navbar {
		flex-direction: column;
		gap: 15px;
	}
	.nav-links a {
		margin: 0 15px;
	}
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
					class="menu-item active"> <i class="fas fa-star"></i> <span>Rate
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

	<div class="container">
		<h2>Rate Your Service Experience</h2>
		<p style="color: #8a8f99; margin-bottom: 30px;">Your feedback
			helps us improve our service quality</p>

		<%
		if (completedServices != null && !completedServices.isEmpty()) {
		%>
		<%
		for (ServiceRequest sr : completedServices) {
		%>
		<div class="card">
			<div class="service-item">
				<h3><%=sr.getServiceType()%></h3>
				<p>
					Vehicle:
					<%=sr.getVehicleModel() != null ? sr.getVehicleModel() : "N/A"%>
					-
					<%=sr.getVehicleNumber() != null ? sr.getVehicleNumber() : "N/A"%></p>
				<p>
					Date:
					<%=sr.getPreferredDate() != null ? sr.getPreferredDate() : "N/A"%></p>

				<form
					action="${pageContext.request.contextPath}/user/feedback/submit"
					method="post">
					<input type="hidden" name="serviceId" value="<%=sr.getId()%>">
					<div class="rating" data-service="<%=sr.getId()%>">
						<i class="far fa-star" data-value="1"></i> <i class="far fa-star"
							data-value="2"></i> <i class="far fa-star" data-value="3"></i> <i
							class="far fa-star" data-value="4"></i> <i class="far fa-star"
							data-value="5"></i>
					</div>
					<input type="hidden" name="rating" class="rating-value" value="0">
					<textarea name="comment" rows="3"
						placeholder="Share your experience... (Optional)"></textarea>
					<button type="submit" class="btn-submit">Submit Review</button>
				</form>
			</div>
		</div>
		<%
		}
		%>
		<%
		} else {
		%>
		<div class="card empty-state">
			<i class="fas fa-star"
				style="font-size: 48px; margin-bottom: 15px; color: #8a8f99;"></i>
			<p>No completed services to review yet.</p>
			<a href="${pageContext.request.contextPath}/service/book"
				class="btn-book">Book a Service</a>
		</div>
		<%
		}
		%>
	</div>

	<script>
        document.querySelectorAll('.rating').forEach(ratingDiv => {
            const stars = ratingDiv.querySelectorAll('i');
            const ratingInput = ratingDiv.parentElement.querySelector('.rating-value');
            
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const value = this.dataset.value;
                    ratingInput.value = value;
                    
                    stars.forEach(s => {
                        if(s.dataset.value <= value) {
                            s.classList.remove('far');
                            s.classList.add('fas');
                            s.classList.add('active');
                        } else {
                            s.classList.remove('fas');
                            s.classList.add('far');
                            s.classList.remove('active');
                        }
                    });
                });
            });
        });
    </script>
</body>
</html>