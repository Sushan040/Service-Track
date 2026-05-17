<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.servicetrack.model.User"%>
<%
User loggedInUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ServiceTrack - Professional Vehicle Service Management</title>
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
	overflow-x: hidden;
}

/* Top Racing Stripes */
.racing-stripes {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 4px;
	background: linear-gradient(90deg, #3671C6 0%, #3671C6 25%, #E6002E 25%, #E6002E 50%
		, #FFD700 50%, #FFD700 75%, #3671C6 75%, #3671C6 100%);
	z-index: 1001;
}

/* Navigation Bar */
.navbar {
	background: rgba(15, 17, 21, 0.95);
	backdrop-filter: blur(10px);
	padding: 15px 50px;
	position: fixed;
	width: 100%;
	top: 4px;
	z-index: 1000;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1px solid rgba(54, 113, 198, 0.3);
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

.nav-links {
	display: flex;
	gap: 35px;
	align-items: center;
}

.nav-links a {
	color: #8a8f99;
	text-decoration: none;
	font-weight: 500;
	transition: all 0.3s;
	font-size: 15px;
}

.nav-links a:hover {
	color: #E6002E;
}

.nav-links a.active {
	color: #E6002E;
}

.auth-buttons {
	display: flex;
	gap: 15px;
}

.btn-login {
	background: transparent;
	border: 1px solid #3671C6;
	padding: 8px 20px;
	border-radius: 8px;
	color: #3671C6;
	cursor: pointer;
	transition: all 0.3s;
	text-decoration: none;
}

.btn-login:hover {
	background: #3671C6;
	color: white;
}

.btn-register {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	border: none;
	padding: 8px 20px;
	border-radius: 8px;
	color: white;
	cursor: pointer;
	transition: all 0.3s;
	text-decoration: none;
}

.btn-register:hover {
	transform: translateY(-2px);
	box-shadow: 0 5px 15px rgba(230, 0, 46, 0.3);
}

.dashboard-btn {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	border: none;
	padding: 8px 20px;
	border-radius: 8px;
	color: white;
	cursor: pointer;
	text-decoration: none;
}

/* Hero Section */
.hero {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	text-align: center;
	background: linear-gradient(135deg, #0a0c10 0%, #1a1d24 100%);
	padding: 120px 20px 80px;
}

.hero-content h1 {
	font-size: 56px;
	margin-bottom: 20px;
	font-weight: 800;
}

.hero-content h1 span {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	-webkit-background-clip: text;
	background-clip: text;
	color: transparent;
}

.hero-content p {
	color: #8a8f99;
	font-size: 18px;
	margin-bottom: 30px;
	max-width: 600px;
	margin-left: auto;
	margin-right: auto;
}

.hero-buttons {
	display: flex;
	gap: 20px;
	justify-content: center;
}

.btn-primary {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	padding: 14px 32px;
	border-radius: 10px;
	color: white;
	text-decoration: none;
	font-weight: 600;
	transition: all 0.3s;
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 5px 20px rgba(230, 0, 46, 0.3);
}

.btn-outline {
	border: 2px solid #3671C6;
	padding: 14px 32px;
	border-radius: 10px;
	color: white;
	text-decoration: none;
	font-weight: 600;
	transition: all 0.3s;
}

.btn-outline:hover {
	background: #3671C6;
}

/* Sections */
.section {
	padding: 80px 50px;
}

.section-title {
	text-align: center;
	font-size: 36px;
	margin-bottom: 50px;
	font-weight: 700;
}

.section-title span {
	color: #E6002E;
}

/* Services Grid */
.services-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
	gap: 30px;
	max-width: 1200px;
	margin: 0 auto;
}

.service-card {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 30px;
	text-align: center;
	transition: all 0.3s;
}

.service-card:hover {
	transform: translateY(-5px);
	border-color: #E6002E;
}

.service-card i {
	font-size: 50px;
	color: #E6002E;
	margin-bottom: 20px;
}

.service-card h3 {
	margin-bottom: 15px;
}

.service-card p {
	color: #8a8f99;
	margin-bottom: 15px;
}

.service-price {
	color: #4CAF50;
	font-weight: 600;
	font-size: 18px;
}

/* Stats Section */
.stats-section {
	background: linear-gradient(135deg, #1a1d24, #0f1115);
	padding: 60px 50px;
}

.stats-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 30px;
	max-width: 1000px;
	margin: 0 auto;
	text-align: center;
}

.stat-item h3 {
	font-size: 48px;
	color: #E6002E;
	margin-bottom: 10px;
}

.stat-item p {
	color: #8a8f99;
}

/* Contact Section */
.contact-container {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 50px;
	max-width: 1000px;
	margin: 0 auto;
}

.contact-info {
	background: #0f1115;
	border: 1px solid #1a1d24;
	border-radius: 16px;
	padding: 30px;
}

.contact-info p {
	margin: 15px 0;
	color: #8a8f99;
}

.contact-info i {
	color: #E6002E;
	width: 30px;
}

.contact-form input, .contact-form textarea {
	width: 100%;
	padding: 12px;
	background: #1a1d24;
	border: 1px solid #2a2d35;
	border-radius: 8px;
	color: white;
	margin-bottom: 15px;
	font-family: inherit;
}

.contact-form button {
	width: 100%;
	padding: 12px;
	background: linear-gradient(135deg, #E6002E, #3671C6);
	border: none;
	border-radius: 8px;
	color: white;
	font-weight: 600;
	cursor: pointer;
}

/* About Section */
.about-content {
	max-width: 800px;
	margin: 0 auto;
	text-align: center;
}

.about-content p {
	color: #8a8f99;
	line-height: 1.8;
	margin-bottom: 20px;
}

/* Footer */
.footer {
	background: #0f1115;
	border-top: 1px solid #1a1d24;
	padding: 40px 50px;
	text-align: center;
	color: #8a8f99;
}

.footer-links {
	display: flex;
	justify-content: center;
	gap: 30px;
	margin-bottom: 20px;
	flex-wrap: wrap;
}

.footer-links a {
	color: #8a8f99;
	text-decoration: none;
}

.footer-links a:hover {
	color: #E6002E;
}

/* Responsive */
@media ( max-width : 900px) {
	.navbar {
		flex-direction: column;
		gap: 15px;
		padding: 15px 20px;
	}
	.hero-content h1 {
		font-size: 36px;
	}
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.contact-container {
		grid-template-columns: 1fr;
	}
	.section {
		padding: 50px 20px;
	}
	.services-grid {
		grid-template-columns: 1fr;
	}
}

@media ( max-width : 550px) {
	.stats-grid {
		grid-template-columns: 1fr;
	}
	.hero-buttons {
		flex-direction: column;
		align-items: center;
	}
	.nav-links {
		flex-wrap: wrap;
		justify-content: center;
		gap: 15px;
	}
	.nav-link {
		color: #8a8f99;
		text-decoration: none;
		font-weight: 500;
		transition: all 0.3s;
		font-size: 15px;
	}
	.nav-link:hover {
		color: #E6002E;
	}
	.nav-link.active {
		color: #E6002E;
	}
}

/* Smooth Scroll */
html {
	scroll-behavior: smooth;
}
</style>
</head>
<body>
	<div class="racing-stripes"></div>

	<!-- Navigation Bar -->
	<nav class="navbar">
		<div class="logo">
			SERVICE<span>TRACK</span>
		</div>
		<div class="nav-links">
			<a href="#home" class="nav-link active">Home</a> <a href="#services"
				class="nav-link">Services</a> <a href="#contact" class="nav-link">Contact</a>
			<a href="#about" class="nav-link">About</a>
		</div>
		<div class="auth-buttons">
			<%
			if (loggedInUser != null) {
			%>
			<a
				href="<%=loggedInUser.getRole().equals("admin")
		? request.getContextPath() + "/admin/dashboard"
		: request.getContextPath() + "/user/dashboard"%>"
				class="dashboard-btn"> <i class="fas fa-tachometer-alt"></i>
				Dashboard
			</a> <a href="${pageContext.request.contextPath}/auth/logout"
				class="btn-login"> <i class="fas fa-sign-out-alt"></i> Logout
			</a>
			<%
			} else {
			%>
			<a href="${pageContext.request.contextPath}/auth/login"
				class="btn-login">Login</a> <a
				href="${pageContext.request.contextPath}/auth/register"
				class="btn-register">Register</a>
			<%
			}
			%>
		</div>
	</nav>

	<!-- Hero Section -->
	<section id="home" class="hero">
		<div class="hero-content">
			<h1>
				Welcome to <span>ServiceTrack</span>
			</h1>
			<p>Professional Vehicle Service Management System | Red Bull
				Racing Edition</p>
			<div class="hero-buttons">
				<a href="#services" class="btn-outline">Our Services</a>
				<%
				if (loggedInUser == null) {
				%>
				<a href="${pageContext.request.contextPath}/auth/register"
					class="btn-primary">Get Started</a>
				<%
				} else {
				%>
				<a
					href="<%=loggedInUser.getRole().equals("admin")
		? request.getContextPath() + "/admin/dashboard"
		: request.getContextPath() + "/user/dashboard"%>"
					class="btn-primary">Go to Dashboard</a>
				<%
				}
				%>
			</div>
		</div>
	</section>

	<!-- Services Section -->
	<section id="services" class="section">
		<h2 class="section-title">
			Our <span>Services</span>
		</h2>
		<div class="services-grid">
			<div class="service-card">
				<i class="fas fa-oil-can"></i>
				<h3>Oil Change</h3>
				<p>Regular engine oil change with filter replacement</p>
				<div class="service-price">Starting from NPR 2,500</div>
			</div>
			<div class="service-card">
				<i class="fas fa-engine"></i>
				<h3>Engine Repair</h3>
				<p>Complete engine diagnostic and repair</p>
				<div class="service-price">Starting from NPR 15,000</div>
			</div>
			<div class="service-card">
				<i class="fas fa-brake-warning"></i>
				<h3>Brake Service</h3>
				<p>Brake pads replacement and disc inspection</p>
				<div class="service-price">Starting from NPR 3,500</div>
			</div>
			<div class="service-card">
				<i class="fas fa-fan"></i>
				<h3>AC Service</h3>
				<p>Air conditioning gas recharge and service</p>
				<div class="service-price">Starting from NPR 4,000</div>
			</div>
			<div class="service-card">
				<i class="fas fa-battery-full"></i>
				<h3>Battery Replacement</h3>
				<p>Car battery replacement and testing</p>
				<div class="service-price">Starting from NPR 8,000</div>
			</div>
			<div class="service-card">
				<i class="fas fa-tools"></i>
				<h3>Full Service</h3>
				<p>Complete vehicle inspection and service</p>
				<div class="service-price">Starting from NPR 12,000</div>
			</div>
		</div>
	</section>

	<!-- Stats Section -->
	<section class="stats-section">
		<div class="stats-grid">
			<div class="stat-item">
				<h3>500+</h3>
				<p>Happy Customers</p>
			</div>
			<div class="stat-item">
				<h3>1000+</h3>
				<p>Services Done</p>
			</div>
			<div class="stat-item">
				<h3>50+</h3>
				<p>Expert Mechanics</p>
			</div>
			<div class="stat-item">
				<h3>24/7</h3>
				<p>Customer Support</p>
			</div>
		</div>
	</section>

	<!-- Contact Section -->
	<section id="contact" class="section">
		<h2 class="section-title">
			Contact <span>Us</span>
		</h2>
		<div class="contact-container">
			<div class="contact-info">
				<h3>Get in Touch</h3>
				<p>
					<i class="fas fa-map-marker-alt"></i> Lazimpat, Kathmandu, Nepal
				</p>
				<p>
					<i class="fas fa-phone"></i> +977 9851000001
				</p>
				<p>
					<i class="fas fa-envelope"></i> info@servicetrack.com
				</p>
				<p>
					<i class="fas fa-clock"></i> Mon-Sun: 8:00 AM - 8:00 PM
				</p>
				<p>
					<i class="fab fa-facebook"></i> <i class="fab fa-instagram"></i> <i
						class="fab fa-twitter"></i> @servicetrack
				</p>
			</div>
			<div class="contact-form">
				<input type="text" placeholder="Your Name"> <input
					type="email" placeholder="Your Email">
				<textarea rows="4" placeholder="Your Message"></textarea>
				<button>Send Message</button>
			</div>
		</div>
	</section>

	<!-- About Section -->
	<section id="about" class="section">
		<h2 class="section-title">
			About <span>Us</span>
		</h2>
		<div class="about-content">
			<p>ServiceTrack is Nepal's leading vehicle service management
				platform, providing professional car care services with transparency
				and efficiency. Founded in 2024, we have served over 500 satisfied
				customers with 1000+ successful services.</p>
			<p>Our team of 50+ expert mechanics uses state-of-the-art
				diagnostic tools and genuine parts to ensure your vehicle receives
				the best care possible. We pride ourselves on our Red Bull Racing
				inspired precision and speed.</p>
			<p>
				<strong>Why choose us?</strong> 24/7 service booking, real-time
				status tracking, transparent pricing, and certified mechanics.
			</p>
		</div>
	</section>

	<!-- Footer -->
	<footer class="footer">
		<div class="footer-links">
			<a href="#home">Home</a> <a href="#services">Services</a> <a
				href="#contact">Contact</a> <a href="#about">About</a> <a
				href="${pageContext.request.contextPath}/auth/login">Login</a> <a
				href="${pageContext.request.contextPath}/auth/register">Register</a>
		</div>
		<p>&copy; 2024 ServiceTrack. All rights reserved.</p>
	</footer>
	<script>
    // Active link highlighting based on scroll position
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('.nav-link');
    
    window.addEventListener('scroll', () => {
        let current = '';
        const scrollPosition = window.scrollY + 100;
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;
            
            if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                current = section.getAttribute('id');
            }
        });
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${current}`) {
                link.classList.add('active');
            }
        });
    });
    
    // Handle click to set active class and smooth scroll
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
            
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            if (targetSection) {
                targetSection.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });
    
    // Trigger scroll event on page load to set correct active link
    window.dispatchEvent(new Event('scroll'));
</script>
</body>
</html>