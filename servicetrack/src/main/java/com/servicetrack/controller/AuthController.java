package com.servicetrack.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.servicetrack.model.User;
import com.servicetrack.service.UserService;
import com.servicetrack.util.PasswordUtil;

@WebServlet("/auth/*")
public class AuthController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService;

	// Admin registration key - in production, store this in database
	private static final String ADMIN_REGISTRATION_KEY = "ADMIN123";

	@Override
	public void init() {
		userService = new UserService();
	}

	// =====================================================
	// HANDLE GET REQUESTS
	// =====================================================

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getPathInfo();
		System.out.println("AuthController GET - Path: " + path);

		if (path == null || "/login".equals(path)) {
			// Check if user is already logged in
			HttpSession session = request.getSession(false);
			if (session != null && session.getAttribute("user") != null) {
				User user = (User) session.getAttribute("user");
				if ("admin".equals(user.getRole())) {
					response.sendRedirect(request.getContextPath() + "/admin/dashboard");
				} else {
					response.sendRedirect(request.getContextPath() + "/user/dashboard");
				}
				return;
			}
			request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);

		} else if ("/register".equals(path)) {
			request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);

		} else if ("/forgot-password".equals(path)) {
			request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);

		} else if ("/reset-password".equals(path)) {
			String token = request.getParameter("token");
			String email = request.getParameter("email");

			if (token == null || token.isEmpty() || email == null || email.isEmpty()) {
				response.sendRedirect(request.getContextPath() + "/auth/forgot-password");
				return;
			}

			// Verify token from session
			HttpSession session = request.getSession();
			Object storedToken = session.getAttribute("reset_token_" + email);
			Long expiry = (Long) session.getAttribute("reset_token_expiry_" + email);

			if (storedToken == null || !storedToken.equals(token)) {
				request.setAttribute("error", "Invalid or expired reset token");
				request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
				return;
			}

			if (expiry == null || expiry < System.currentTimeMillis()) {
				request.setAttribute("error", "Reset token has expired. Please request a new one.");
				request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
				return;
			}

			request.setAttribute("token", token);
			request.setAttribute("email", email);
			request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);

		} else if ("/logout".equals(path)) {
			logout(request, response);

		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	// =====================================================
	// HANDLE POST REQUESTS
	// =====================================================

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getPathInfo();
		System.out.println("AuthController POST - Path: " + path);

		if ("/login".equals(path)) {
			login(request, response);
		} else if ("/register".equals(path)) {
			register(request, response);
		} else if ("/forgot-password".equals(path)) {
			forgotPassword(request, response);
		} else if ("/reset-password".equals(path)) {
			resetPassword(request, response);
		} else if ("/logout".equals(path)) {
			logout(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	// =====================================================
	// LOGIN METHOD
	// =====================================================

	private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String email = request.getParameter("email");
		String password = request.getParameter("password");

		if (email == null || email.trim().isEmpty()) {
			request.setAttribute("error", "Please enter your email address");
			request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
			return;
		}

		if (password == null || password.trim().isEmpty()) {
			request.setAttribute("error", "Please enter your password");
			request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
			return;
		}

		try {
			// Get user from database
			User user = userService.getUserByEmail(email.trim());

			if (user == null) {
				request.setAttribute("error", "No account found with this email address");
				request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
				return;
			}

			// Check if account is locked
			if (user.isAccountLocked()) {
				Timestamp lockoutTime = user.getLockoutTime();
				if (lockoutTime != null) {
					long lockoutDuration = 15 * 60 * 1000;
					long currentTime = System.currentTimeMillis();
					if ((currentTime - lockoutTime.getTime()) > lockoutDuration) {
						userService.unlockAccount(user.getId());
					} else {
						long remainingMinutes = (lockoutDuration - (currentTime - lockoutTime.getTime())) / (60 * 1000);
						request.setAttribute("error", "Your account is locked. Please try again after "
								+ (remainingMinutes + 1) + " minutes.");
						request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
						return;
					}
				} else {
					request.setAttribute("error", "Your account has been locked. Please contact administrator.");
					request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
					return;
				}
			}

			// Verify password
			User loggedInUser = userService.loginUser(email.trim(), password);

			if (loggedInUser == null) {
				int currentAttempts = user.getFailedLoginAttempts();
				int newAttempts = currentAttempts + 1;
				userService.incrementFailedLoginAttempts(user.getId());

				if (newAttempts >= 5) {
					userService.lockAccount(user.getId());
					request.setAttribute("error",
							"Your account has been locked due to 5 failed login attempts. Please try again after 15 minutes.");
				} else {
					int remainingAttempts = 5 - newAttempts;
					request.setAttribute("error",
							"Incorrect password. " + remainingAttempts + " attempt(s) remaining before account lock.");
				}
				request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
				return;
			}

			// Login successful - reset failed attempts
			userService.resetFailedLoginAttempts(user.getId());

			// Create session
			HttpSession session = request.getSession();
			session.setAttribute("user", loggedInUser);
			session.setAttribute("userId", loggedInUser.getId());
			session.setAttribute("userName", loggedInUser.getFullName());
			session.setAttribute("role", loggedInUser.getRole());
			session.setAttribute("userEmail", loggedInUser.getEmail());
			session.setMaxInactiveInterval(30 * 60);

			// Redirect based on role
			if ("admin".equals(loggedInUser.getRole())) {
				response.sendRedirect(request.getContextPath() + "/admin/dashboard");
			} else {
				response.sendRedirect(request.getContextPath() + "/user/dashboard");
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "An unexpected error occurred. Please try again.");
			request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
		}
	}

	// =====================================================
	// REGISTER METHOD
	// =====================================================

	private void register(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String fullName = request.getParameter("fullName");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String role = request.getParameter("role");
		String adminKey = request.getParameter("adminKey");

		if (fullName == null || fullName.trim().length() < 2) {
			request.setAttribute("error", "Please enter your full name (minimum 2 characters)");
			request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
			return;
		}

		if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
			request.setAttribute("error", "Please enter a valid email address");
			request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
			return;
		}

		if (password == null || password.length() < 6) {
			request.setAttribute("error", "Password must be at least 6 characters long");
			request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
			return;
		}

		if (!password.equals(confirmPassword)) {
			request.setAttribute("error", "Passwords do not match");
			request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
			return;
		}

		String userRole = "customer";
		if (role != null && role.equals("admin")) {
			if (adminKey == null || !adminKey.equals(ADMIN_REGISTRATION_KEY)) {
				request.setAttribute("error", "Invalid admin registration key");
				request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
				return;
			}
			userRole = "admin";
		}

		User user = new User();
		user.setFullName(fullName.trim());
		user.setEmail(email.trim().toLowerCase());
		user.setPassword(password);
		user.setPhone(phone);
		user.setAddress(address);
		user.setRole(userRole);

		try {
			if (userService.emailExists(email.trim().toLowerCase())) {
				request.setAttribute("error", "Email address is already registered. Please login instead.");
				request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
				return;
			}

			boolean registered = userService.registerUser(user);
			if (registered) {
				String successMessage = userRole.equals("admin") ? "Admin registration successful! Please login."
						: "Registration successful! Please login.";
				request.setAttribute("success", successMessage);
				request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
			} else {
				request.setAttribute("error", "Registration failed. Please try again.");
				request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
			}
		} catch (IllegalArgumentException e) {
			request.setAttribute("error", e.getMessage());
			request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "An unexpected error occurred. Please try again.");
			request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
		}
	}

	// =====================================================
	// LOGOUT METHOD
	// =====================================================

	private void logout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session != null) {
			session.removeAttribute("user");
			session.removeAttribute("userId");
			session.removeAttribute("userName");
			session.removeAttribute("role");
			session.removeAttribute("userEmail");
			session.invalidate();
		}

		response.sendRedirect(request.getContextPath() + "/index.jsp");
	}

	// =====================================================
	// FORGOT PASSWORD METHOD
	// =====================================================

	private void forgotPassword(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String email = request.getParameter("email");

		if (email == null || email.trim().isEmpty()) {
			request.setAttribute("error", "Please enter your email address");
			request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
			return;
		}

		try {
			User user = userService.getUserByEmail(email.trim());

			// Generate reset token
			String token = UUID.randomUUID().toString();

			// Store token in session
			request.getSession().setAttribute("reset_token_" + email, token);
			request.getSession().setAttribute("reset_token_expiry_" + email, System.currentTimeMillis() + 3600000);

			if (user != null) {
				request.setAttribute("info", "Password reset link has been sent to your email.");
				request.setAttribute("token", token);
				request.setAttribute("email", email);
				request.setAttribute("resetLink",
						request.getContextPath() + "/auth/reset-password?token=" + token + "&email=" + email);
			} else {
				request.setAttribute("info",
						"If an account exists with this email, you will receive a password reset link.");
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "An error occurred. Please try again.");
		}

		request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
	}

	// =====================================================
	// RESET PASSWORD METHOD
	// =====================================================

	private void resetPassword(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String token = request.getParameter("token");
		String email = request.getParameter("email");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		// Validate token and email
		if (token == null || token.isEmpty() || email == null || email.isEmpty()) {
			request.setAttribute("error", "Invalid reset link");
			request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
			return;
		}

		// Verify token from session
		HttpSession session = request.getSession();
		Object storedToken = session.getAttribute("reset_token_" + email);
		Long expiry = (Long) session.getAttribute("reset_token_expiry_" + email);

		if (storedToken == null || !storedToken.equals(token)) {
			request.setAttribute("error", "Invalid or expired reset token");
			request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
			return;
		}

		if (expiry == null || expiry < System.currentTimeMillis()) {
			request.setAttribute("error", "Reset token has expired. Please request a new one.");
			request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
			return;
		}

		// Validate passwords
		if (newPassword == null || newPassword.length() < 6) {
			request.setAttribute("error", "Password must be at least 6 characters long");
			request.setAttribute("token", token);
			request.setAttribute("email", email);
			request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
			return;
		}

		if (!newPassword.equals(confirmPassword)) {
			request.setAttribute("error", "Passwords do not match");
			request.setAttribute("token", token);
			request.setAttribute("email", email);
			request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
			return;
		}

		try {
			// Update password
			User user = userService.getUserByEmail(email);
			if (user == null) {
				request.setAttribute("error", "User not found");
				request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
				return;
			}

			boolean updated = userService.updatePassword(user.getId(), PasswordUtil.hashPassword(newPassword));

			if (updated) {
				// Clear reset tokens
				session.removeAttribute("reset_token_" + email);
				session.removeAttribute("reset_token_expiry_" + email);

				request.setAttribute("success", "Password reset successfully! Please login with your new password.");
				request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
			} else {
				request.setAttribute("error", "Failed to reset password. Please try again.");
				request.setAttribute("token", token);
				request.setAttribute("email", email);
				request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "An error occurred. Please try again.");
			request.setAttribute("token", token);
			request.setAttribute("email", email);
			request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
		}
	}
}