<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - ServiceTrack</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
	<div class="auth-container">
		<div class="auth-card">
			<div class="auth-header">
				<div class="auth-icon">
					<i class="fas fa-user-plus"></i>
				</div>
				<h1>CREATE ACCOUNT</h1>
				<p>Join ServiceTrack today</p>
			</div>

			<div class="auth-body">
				<%
				if (request.getAttribute("error") != null) {
				%>
				<div class="alert alert-error">
					<i class="fas fa-exclamation-circle"></i>
					<%=request.getAttribute("error")%>
				</div>
				<%
				}
				%>

				<form action="${pageContext.request.contextPath}/auth/register"
					method="post" id="registerForm">
					<div class="form-row">
						<div class="form-group">
							<label><i class="fas fa-user"></i> Full Name</label>
							<div class="input-wrapper">
								<i class="fas fa-user input-icon"></i> <input type="text"
									name="fullName" placeholder="Enter your full name" required>
							</div>
						</div>

						<div class="form-group">
							<label><i class="fas fa-phone"></i> Phone Number</label>
							<div class="input-wrapper">
								<i class="fas fa-phone input-icon"></i> <input type="tel"
									name="phone" placeholder="Optional">
							</div>
						</div>
					</div>

					<div class="form-group">
						<label><i class="fas fa-envelope"></i> Email Address</label>
						<div class="input-wrapper">
							<i class="fas fa-envelope input-icon"></i> <input type="email"
								name="email" placeholder="Enter your email" required>
						</div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label><i class="fas fa-lock"></i> Password</label>
							<div class="input-wrapper">
								<i class="fas fa-key input-icon"></i> <input type="password"
									name="password" id="password"
									placeholder="Minimum 6 characters" required> <span
									class="password-toggle" onclick="togglePassword('password')">
									<i class="fas fa-eye"></i>
								</span>
							</div>
						</div>

						<div class="form-group">
							<label><i class="fas fa-check-circle"></i> Confirm
								Password</label>
							<div class="input-wrapper">
								<i class="fas fa-check input-icon"></i> <input type="password"
									name="confirmPassword" id="confirmPassword"
									placeholder="Confirm password" required> <span
									class="password-toggle"
									onclick="togglePassword('confirmPassword')"> <i
									class="fas fa-eye"></i>
								</span>
							</div>
						</div>
					</div>

					<div class="form-group">
						<label><i class="fas fa-map-marker-alt"></i> Address</label>
						<div class="input-wrapper">
							<i class="fas fa-location-dot input-icon"></i>
							<textarea name="address" rows="2"
								placeholder="Your address (Optional)"></textarea>
						</div>
					</div>

					<div class="form-group">
						<label><i class="fas fa-user-tag"></i> Register As</label>
						<div class="radio-group">
							<label class="radio-label"> <input type="radio"
								name="role" value="customer" checked> <span
								class="radio-custom"></span> <i class="fas fa-user"></i>
								Customer
							</label> <label class="radio-label"> <input type="radio"
								name="role" value="admin"> <span class="radio-custom"></span>
								<i class="fas fa-user-shield"></i> Admin
							</label>
						</div>
					</div>

					<div class="admin-key-field" style="display: none;">
						<div class="form-group">
							<label><i class="fas fa-key"></i> Admin Registration Key</label>
							<div class="input-wrapper">
								<i class="fas fa-key input-icon"></i> <input type="password"
									name="adminKey" placeholder="Enter admin registration key">
							</div>
							<small class="help-text"><i class="fas fa-info-circle"></i>
								Only users with valid admin key can register as admin</small>
						</div>
					</div>

					<button type="submit" class="btn-auth" id="registerBtn">
						<span class="btn-text"><i class="fas fa-user-plus"></i>
							Create Account</span> <span class="spinner"></span>
					</button>
				</form>

				<div class="auth-links">
					<p>
						Already have an account? <a
							href="${pageContext.request.contextPath}/auth/login">Sign In</a>
					</p>
				</div>
			</div>
		</div>
	</div>

	<script>
        function togglePassword(fieldId) {
            const input = document.getElementById(fieldId);
            const icon = input.parentElement.querySelector('.password-toggle i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Show/hide admin key field
        const roleRadios = document.querySelectorAll('input[name="role"]');
        const adminKeyField = document.querySelector('.admin-key-field');
        
        roleRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                if (this.value === 'admin') {
                    adminKeyField.style.display = 'block';
                } else {
                    adminKeyField.style.display = 'none';
                }
            });
        });
        
        // Password match validation
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        
        function validatePasswordMatch() {
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity("Passwords don't match");
            } else {
                confirmPassword.setCustomValidity('');
            }
        }
        
        password.addEventListener('change', validatePasswordMatch);
        confirmPassword.addEventListener('keyup', validatePasswordMatch);
        
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const btn = document.getElementById('registerBtn');
            btn.classList.add('loading');
            btn.disabled = true;
        });
    </script>
</body>
</html>