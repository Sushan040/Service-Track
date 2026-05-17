<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Server Error - ServiceTrack</title>
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
	background: linear-gradient(135deg, #0a0c10 0%, #1a1d24 100%);
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #fff;
}

.error-container {
	text-align: center;
	max-width: 600px;
	padding: 40px;
	animation: fadeInUp 0.5s ease-out;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(30px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.error-code {
	font-size: 120px;
	font-weight: 800;
	background: linear-gradient(135deg, #E6002E, #3671C6);
	-webkit-background-clip: text;
	background-clip: text;
	color: transparent;
	margin-bottom: 20px;
}

.error-icon {
	font-size: 80px;
	color: #E6002E;
	margin-bottom: 20px;
}

.error-title {
	font-size: 28px;
	font-weight: 700;
	margin-bottom: 15px;
}

.error-message {
	color: #8a8f99;
	font-size: 16px;
	margin-bottom: 30px;
	line-height: 1.6;
}

.btn-primary {
	background: linear-gradient(135deg, #E6002E, #3671C6);
	padding: 12px 28px;
	border: none;
	border-radius: 10px;
	color: white;
	text-decoration: none;
	font-weight: 600;
	display: inline-flex;
	align-items: center;
	gap: 8px;
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 5px 20px rgba(230, 0, 46, 0.3);
}

.btn-secondary {
	background: transparent;
	border: 1px solid #2a2d35;
	padding: 12px 28px;
	border-radius: 10px;
	color: white;
	text-decoration: none;
	font-weight: 600;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	margin-left: 15px;
}

.btn-secondary:hover {
	border-color: #E6002E;
	color: #E6002E;
}

@media ( max-width : 600px) {
	.error-code {
		font-size: 80px;
	}
	.btn-primary, .btn-secondary {
		display: block;
		margin: 10px;
	}
}
</style>
</head>
<body>
	<div class="error-container">
		<div class="error-icon">
			<i class="fas fa-exclamation-triangle"></i>
		</div>
		<div class="error-code">500</div>
		<h1 class="error-title">Server Error</h1>
		<p class="error-message">Something went wrong on our end. Our team
			has been notified.</p>
		<div>
			<a href="${pageContext.request.contextPath}/" class="btn-primary"><i
				class="fas fa-home"></i> Go to Homepage</a> <a
				href="javascript:location.reload()" class="btn-secondary"><i
				class="fas fa-sync-alt"></i> Try Again</a>
		</div>
	</div>
</body>
</html>