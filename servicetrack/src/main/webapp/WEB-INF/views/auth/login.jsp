<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - ServiceTrack</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/auth.css">
<style>
.lock-warning {
	background: rgba(255, 152, 0, 0.15);
	border-left: 4px solid #FF9800;
	padding: 12px 15px;
	border-radius: 8px;
	margin-bottom: 20px;
	display: flex;
	align-items: center;
	gap: 10px;
	color: #FF9800;
}

.attempts-warning {
	background: rgba(230, 0, 46, 0.1);
	border-left: 4px solid #E6002E;
	padding: 12px 15px;
	border-radius: 8px;
	margin-bottom: 20px;
	display: flex;
	align-items: center;
	gap: 10px;
	color: #E6002E;
}
</style>
</head>
<body>
	<div class="auth-container">
		<div class="auth-card">
			<div class="auth-header">
				<div class="auth-icon">
					<i class="fas fa-car"></i> <i class="fas fa-tools"></i>
				</div>
				<h1>SERVICE TRACK</h1>
				<p>Login to your account</p>
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

				<%
				if (request.getAttribute("success") != null) {
				%>
				<div class="alert alert-success">
					<i class="fas fa-check-circle"></i>
					<%=request.getAttribute("success")%>
				</div>
				<%
				}
				%>

				<form action="${pageContext.request.contextPath}/auth/login"
					method="post" id="loginForm">
					<div class="form-group">
						<label><i class="fas fa-envelope"></i> Email Address</label>
						<div class="input-wrapper">
							<i class="fas fa-user input-icon"></i> <input type="email"
								name="email" placeholder="Enter your email" required
								autocomplete="email">
						</div>
					</div>

					<div class="form-group">
						<label><i class="fas fa-lock"></i> Password</label>
						<div class="input-wrapper">
							<i class="fas fa-key input-icon"></i> <input type="password"
								name="password" id="password" placeholder="Enter your password"
								required> <span class="password-toggle"
								onclick="togglePassword()"> <i class="fas fa-eye"></i>
							</span>
						</div>
					</div>

					<button type="submit" class="btn-auth" id="loginBtn">
						<span class="btn-text"><i class="fas fa-sign-in-alt"></i>
							Login</span> <span class="spinner"></span>
					</button>
				</form>

				<div class="auth-links">
					<p>
						<a href="${pageContext.request.contextPath}/auth/forgot-password">Forgot Password?</a>
					</p>
					<p>
						Don't have an account? <a
							href="${pageContext.request.contextPath}/auth/register">Create
							Account</a>
					</p>
				</div>
			</div>
		</div>
	</div>

	<script>
		function togglePassword() {
			const passwordInput = document.getElementById('password');
			const toggleIcon = document.querySelector('.password-toggle i');
			if (passwordInput.type === 'password') {
				passwordInput.type = 'text';
				toggleIcon.classList.remove('fa-eye');
				toggleIcon.classList.add('fa-eye-slash');
			} else {
				passwordInput.type = 'password';
				toggleIcon.classList.remove('fa-eye-slash');
				toggleIcon.classList.add('fa-eye');
			}
		}

		document.getElementById('loginForm').addEventListener('submit',
				function() {
					const btn = document.getElementById('loginBtn');
					btn.classList.add('loading');
					btn.disabled = true;
				});
	</script>
</body>
</html>