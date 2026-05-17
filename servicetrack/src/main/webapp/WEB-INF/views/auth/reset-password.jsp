<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String token = request.getParameter("token");
if (token == null || token.isEmpty()) {
	response.sendRedirect(request.getContextPath() + "/auth/forgot-password");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password - ServiceTrack</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/auth.css">
<style>
.password-strength {
	margin-top: 5px;
	height: 4px;
	background: #2a2d35;
	border-radius: 2px;
	overflow: hidden;
}

.strength-bar {
	height: 100%;
	width: 0%;
	transition: width 0.3s;
}

.strength-text {
	font-size: 11px;
	margin-top: 5px;
	color: #8a8f99;
}

.match-success {
	color: #4CAF50;
	font-size: 11px;
	margin-top: 5px;
}

.match-error {
	color: #E6002E;
	font-size: 11px;
	margin-top: 5px;
}
</style>
</head>
<body>
	<div class="auth-container">
		<div class="auth-card">
			<div class="auth-header">
				<div class="auth-icon">
					<i class="fas fa-lock-open"></i>
				</div>
				<h1>RESET PASSWORD</h1>
				<p>Create a new password</p>
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

				<form
					action="${pageContext.request.contextPath}/auth/reset-password"
					method="post" id="resetForm">
					<input type="hidden" name="token" value="<%=token%>">
					<input type="hidden" name="email" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">

					<div class="form-group">
						<label><i class="fas fa-lock"></i> New Password</label>
						<div class="input-wrapper">
							<i class="fas fa-key input-icon"></i> <input type="password"
								name="newPassword" id="newPassword"
								placeholder="Minimum 6 characters" required> <span
								class="password-toggle" onclick="togglePassword('newPassword')">
								<i class="fas fa-eye"></i>
							</span>
						</div>
						<div class="password-strength">
							<div class="strength-bar" id="strengthBar"></div>
						</div>
						<div class="strength-text" id="strengthText"></div>
					</div>

					<div class="form-group">
						<label><i class="fas fa-check-circle"></i> Confirm
							Password</label>
						<div class="input-wrapper">
							<i class="fas fa-check input-icon"></i> <input type="password"
								name="confirmPassword" id="confirmPassword"
								placeholder="Confirm your password" required> <span
								class="password-toggle"
								onclick="togglePassword('confirmPassword')"> <i
								class="fas fa-eye"></i>
							</span>
						</div>
						<div id="matchMessage"></div>
					</div>

					<button type="submit" class="btn-auth" id="resetBtn">
						<span class="btn-text"><i class="fas fa-save"></i> Reset
							Password</span> <span class="spinner"></span>
					</button>
				</form>

				<div class="auth-links" style="margin-top: 20px;">
					<p>
						<a href="${pageContext.request.contextPath}/auth/login"><i
							class="fas fa-arrow-left"></i> Back to Login</a>
					</p>
				</div>
			</div>
		</div>
	</div>

	<script>
		function togglePassword(fieldId) {
			const input = document.getElementById(fieldId);
			const icon = input.parentElement
					.querySelector('.password-toggle i');
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

		// Password strength checker
		const passwordInput = document.getElementById('newPassword');
		const strengthBar = document.getElementById('strengthBar');
		const strengthText = document.getElementById('strengthText');

		passwordInput.addEventListener('input', function() {
			const password = this.value;
			let strength = 0;
			let message = '';
			let color = '';

			if (password.length >= 8)
				strength++;
			if (password.match(/[a-z]+/))
				strength++;
			if (password.match(/[A-Z]+/))
				strength++;
			if (password.match(/[0-9]+/))
				strength++;
			if (password.match(/[$@#&!]+/))
				strength++;

			switch (strength) {
			case 0:
			case 1:
				message = 'Weak';
				color = '#E6002E';
				strengthBar.style.width = '20%';
				break;
			case 2:
				message = 'Medium';
				color = '#FF9800';
				strengthBar.style.width = '50%';
				break;
			case 3:
				message = 'Good';
				color = '#3671C6';
				strengthBar.style.width = '75%';
				break;
			case 4:
			case 5:
				message = 'Strong';
				color = '#4CAF50';
				strengthBar.style.width = '100%';
				break;
			}

			strengthBar.style.background = color;
			strengthText.textContent = message;
			strengthText.style.color = color;
		});

		// Password match checker
		const confirmPassword = document.getElementById('confirmPassword');
		const matchMessage = document.getElementById('matchMessage');

		function checkPasswordMatch() {
			const password = passwordInput.value;
			const confirm = confirmPassword.value;

			if (confirm.length === 0) {
				matchMessage.textContent = '';
				return;
			}

			if (password === confirm) {
				matchMessage.innerHTML = '<i class="fas fa-check-circle"></i> Passwords match';
				matchMessage.className = 'match-success';
			} else {
				matchMessage.innerHTML = '<i class="fas fa-times-circle"></i> Passwords do not match';
				matchMessage.className = 'match-error';
			}
		}

		passwordInput.addEventListener('input', checkPasswordMatch);
		confirmPassword.addEventListener('input', checkPasswordMatch);

		document.getElementById('resetForm').addEventListener('submit',
				function(e) {
					const btn = document.getElementById('resetBtn');
					btn.classList.add('loading');
					btn.disabled = true;
				});
	</script>
</body>
</html>