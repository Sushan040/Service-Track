<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password - ServiceTrack</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/auth.css">
<style>
.demo-link {
	background: #1a1d24;
	padding: 12px;
	border-radius: 8px;
	margin-top: 15px;
	word-break: break-all;
}

.demo-link a {
	color: #3671C6;
	text-decoration: none;
}

.demo-link a:hover {
	color: #E6002E;
}
</style>
</head>
<body>
	<div class="auth-container">
		<div class="auth-card">
			<div class="auth-header">
				<div class="auth-icon">
					<i class="fas fa-key"></i>
				</div>
				<h1>FORGOT PASSWORD</h1>
				<p>Reset your password</p>
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
				if (request.getAttribute("info") != null) {
				%>
				<div class="alert alert-info">
					<i class="fas fa-info-circle"></i>
					<%=request.getAttribute("info")%>
				</div>
				<%
				}
				%>

				<%
				String resetLink = (String) request.getAttribute("resetLink");
				String email = (String) request.getAttribute("email");
				if (resetLink != null && email != null) {
				%>
				<div class="demo-link">
					<strong style="color: white;">Demo Reset Link:</strong><br>
					<a href="${pageContext.request.contextPath}/auth/reset-password?token=<%= request.getAttribute("token") %>&email=<%= request.getAttribute("email") %>">
						${pageContext.request.contextPath}/auth/reset-password?token=<%=request.getAttribute("token")%>&email=<%=email%>
					</a>
				</div>
				<%
				}
				%>

				<div class="instruction-text"
					style="text-align: center; color: #8a8f99; margin-bottom: 25px;">
					<i class="fas fa-info-circle"></i> Enter your email address and
					we'll send you a link to reset your password.
				</div>

				<form
					action="${pageContext.request.contextPath}/auth/forgot-password"
					method="post" id="forgotForm">
					<div class="form-group">
						<label><i class="fas fa-envelope"></i> Email Address</label>
						<div class="input-wrapper">
							<i class="fas fa-user input-icon"></i> <input type="email"
								name="email" id="emailInput"
								placeholder="Enter your registered email" required>
						</div>
					</div>

					<button type="submit" class="btn-auth" id="resetBtn">
						<i class="fas fa-paper-plane"></i> Send Reset Link
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
		document
				.getElementById('forgotForm')
				.addEventListener(
						'submit',
						function() {
							const btn = document.getElementById('resetBtn');
							btn.disabled = true;
							btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
						});
	</script>
</body>
</html>