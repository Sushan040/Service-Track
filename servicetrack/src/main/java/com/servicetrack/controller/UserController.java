package com.servicetrack.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.servicetrack.dao.FeedbackDao;
import com.servicetrack.dao.ReminderDao;
import com.servicetrack.model.Feedback;
import com.servicetrack.model.Reminder;
import com.servicetrack.model.ServiceRequest;
import com.servicetrack.model.User;
import com.servicetrack.model.Vehicle;
import com.servicetrack.service.ServiceRequestService;
import com.servicetrack.service.UserService;
import com.servicetrack.service.VehicleService;
import com.servicetrack.util.PasswordUtil;

@WebServlet("/user/*")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService;
	private VehicleService vehicleService;
	private ServiceRequestService serviceRequestService;
	private FeedbackDao feedbackDao;
	private ReminderDao reminderDao;

	@Override
	public void init() {
		userService = new UserService();
		vehicleService = new VehicleService();
		serviceRequestService = new ServiceRequestService();
		feedbackDao = new FeedbackDao();
		reminderDao = new ReminderDao();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/auth/login");
			return;
		}

		String path = request.getPathInfo();
		User user = (User) session.getAttribute("user");

		System.out.println("UserController GET - Path: " + path);
		System.out.println("User ID: " + user.getId());

		if (path == null || "/dashboard".equals(path)) {
			showDashboard(request, response, user);
		} else if ("/vehicles".equals(path)) {
			showMyVehicles(request, response, user);
		} else if ("/vehicles/edit".equals(path)) {
			editVehicleForm(request, response, user);
		} else if ("/vehicles/delete".equals(path)) {
			deleteVehicle(request, response, user);
		} else if ("/profile".equals(path)) {
			showProfile(request, response, user);
		} else if ("/reminders".equals(path)) {
			showReminders(request, response, user);
		} else if ("/feedback".equals(path)) {
			showFeedback(request, response, user);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/auth/login");
			return;
		}

		String path = request.getPathInfo();
		User user = (User) session.getAttribute("user");

		if ("/vehicles/save".equals(path)) {
			saveVehicle(request, response, user);
		} else if ("/profile/update".equals(path)) {
			updateProfile(request, response, user);
		} else if ("/profile/password".equals(path)) {
			changePassword(request, response, user);
		} else if ("/reminders/dismiss".equals(path)) {
			dismissReminder(request, response, user);
		} else if ("/feedback/submit".equals(path)) {
			submitFeedback(request, response, user);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	// =====================================================
	// DASHBOARD METHOD - FETCHES REAL DATA
	// =====================================================

	private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		try {
			// Fetch real data from database
			int activeServices = serviceRequestService.getActiveServicesCountByUser(user.getId());
			int completedServices = serviceRequestService.getCompletedServicesCountByUser(user.getId());
			int myVehicles = vehicleService.getVehiclesByUserId(user.getId()).size();
			int myServices = serviceRequestService.getTotalServicesCountByUser(user.getId());

			// Get recent services (last 5)
			List<ServiceRequest> recentServices = serviceRequestService.getServiceRequestsByUserId(user.getId());
			if (recentServices != null && recentServices.size() > 5) {
				recentServices = recentServices.subList(0, 5);
			}

			// Debug output
			System.out.println("=== DASHBOARD DATA ===");
			System.out.println("Active Services: " + activeServices);
			System.out.println("Completed Services: " + completedServices);
			System.out.println("My Vehicles: " + myVehicles);
			System.out.println("My Services: " + myServices);
			System.out.println("Recent Services Count: " + (recentServices != null ? recentServices.size() : 0));

			// Set attributes for JSP
			request.setAttribute("activeServices", activeServices);
			request.setAttribute("completedServices", completedServices);
			request.setAttribute("myVehicles", myVehicles);
			request.setAttribute("myServices", myServices);
			request.setAttribute("recentServices", recentServices);

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("activeServices", 0);
			request.setAttribute("completedServices", 0);
			request.setAttribute("myVehicles", 0);
			request.setAttribute("myServices", 0);
			request.setAttribute("recentServices", null);
		}

		request.getRequestDispatcher("/WEB-INF/views/user/dashboard.jsp").forward(request, response);
	}

	// =====================================================
	// VEHICLE METHODS
	// =====================================================

	private void showMyVehicles(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		List<Vehicle> vehicles = vehicleService.getVehiclesByUserId(user.getId());
		request.setAttribute("vehicles", vehicles);
		request.getRequestDispatcher("/WEB-INF/views/user/my-vehicles.jsp").forward(request, response);
	}

	private void editVehicleForm(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		int vehicleId = Integer.parseInt(request.getParameter("id"));
		Vehicle vehicle = vehicleService.getVehicleById(vehicleId);

		if (vehicle.getUserId() != user.getId()) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		List<Vehicle> vehicles = vehicleService.getVehiclesByUserId(user.getId());
		request.setAttribute("vehicles", vehicles);
		request.setAttribute("editVehicle", vehicle);
		request.getRequestDispatcher("/WEB-INF/views/user/my-vehicles.jsp").forward(request, response);
	}

	private void saveVehicle(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {

		String vehicleIdParam = request.getParameter("vehicleId");
		String vehicleNumber = request.getParameter("vehicleNumber");
		String brand = request.getParameter("brand");
		String model = request.getParameter("model");
		int year = Integer.parseInt(request.getParameter("year"));

		try {
			if (vehicleIdParam != null && !vehicleIdParam.isEmpty()) {
				int vehicleId = Integer.parseInt(vehicleIdParam);
				Vehicle existingVehicle = vehicleService.getVehicleById(vehicleId);
				if (existingVehicle.getUserId() != user.getId()) {
					response.sendError(HttpServletResponse.SC_FORBIDDEN);
					return;
				}
				existingVehicle.setVehicleNumber(vehicleNumber);
				existingVehicle.setBrand(brand);
				existingVehicle.setModel(model);
				existingVehicle.setYear(year);
				vehicleService.updateVehicle(existingVehicle);
				request.getSession().setAttribute("success", "Vehicle updated successfully!");
			} else {
				Vehicle newVehicle = new Vehicle();
				newVehicle.setUserId(user.getId());
				newVehicle.setVehicleNumber(vehicleNumber);
				newVehicle.setBrand(brand);
				newVehicle.setModel(model);
				newVehicle.setYear(year);
				vehicleService.addVehicle(newVehicle);
				request.getSession().setAttribute("success", "Vehicle added successfully!");
			}
		} catch (Exception e) {
			request.getSession().setAttribute("error", e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/user/vehicles");
	}

	private void deleteVehicle(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {

		int vehicleId = Integer.parseInt(request.getParameter("id"));
		Vehicle vehicle = vehicleService.getVehicleById(vehicleId);

		if (vehicle.getUserId() != user.getId()) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		vehicleService.deleteVehicle(vehicleId);
		request.getSession().setAttribute("success", "Vehicle deleted successfully!");
		response.sendRedirect(request.getContextPath() + "/user/vehicles");
	}

	// =====================================================
	// PROFILE METHODS
	// =====================================================

	private void showProfile(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		int vehicleCount = vehicleService.getVehiclesByUserId(user.getId()).size();
		int serviceCount = serviceRequestService.getTotalServicesCountByUser(user.getId());
		int completedCount = serviceRequestService.getCompletedServicesCountByUser(user.getId());

		request.setAttribute("vehicleCount", vehicleCount);
		request.setAttribute("serviceCount", serviceCount);
		request.setAttribute("completedCount", completedCount);

		request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
	}

	private void updateProfile(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {

		String fullName = request.getParameter("fullName");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");

		try {
			user.setFullName(fullName);
			user.setEmail(email);
			user.setPhone(phone);
			user.setAddress(address);
			userService.updateUser(user);

			HttpSession session = request.getSession();
			session.setAttribute("user", user);
			session.setAttribute("userName", user.getFullName());

			request.getSession().setAttribute("success", "Profile updated successfully!");
		} catch (Exception e) {
			request.getSession().setAttribute("error", "Failed to update profile: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/user/profile");
	}

	private void changePassword(HttpServletRequest request, HttpServletResponse response, User user)
			throws IOException {

		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		if (!newPassword.equals(confirmPassword)) {
			request.getSession().setAttribute("error", "New passwords do not match!");
		} else if (!userService.verifyPassword(user.getId(), currentPassword)) {
			request.getSession().setAttribute("error", "Current password is incorrect!");
		} else if (newPassword.length() < 6) {
			request.getSession().setAttribute("error", "Password must be at least 6 characters!");
		} else {
			userService.updatePassword(user.getId(), PasswordUtil.hashPassword(newPassword));
			request.getSession().setAttribute("success", "Password changed successfully!");
		}

		response.sendRedirect(request.getContextPath() + "/user/profile");
	}

	// =====================================================
	// REMINDER METHODS
	// =====================================================

	private void showReminders(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		List<Reminder> reminders = reminderDao.getRemindersByUserId(user.getId());
		request.setAttribute("reminders", reminders);
		request.getRequestDispatcher("/WEB-INF/views/user/reminders.jsp").forward(request, response);
	}

	private void dismissReminder(HttpServletRequest request, HttpServletResponse response, User user)
			throws IOException {

		int reminderId = Integer.parseInt(request.getParameter("id"));
		reminderDao.markAsSent(reminderId);
		request.getSession().setAttribute("success", "Reminder dismissed!");
		response.sendRedirect(request.getContextPath() + "/user/reminders");
	}

	// =====================================================
	// FEEDBACK METHODS
	// =====================================================

	private void showFeedback(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		List<ServiceRequest> completedServices = serviceRequestService.getServiceRequestsByUserIdAndStatus(user.getId(),
				"completed");
		List<Feedback> myFeedback = feedbackDao.getFeedbackByUserId(user.getId());

		request.setAttribute("completedServices", completedServices);
		request.setAttribute("myFeedback", myFeedback);
		request.getRequestDispatcher("/WEB-INF/views/user/feedback.jsp").forward(request, response);
	}

	private void submitFeedback(HttpServletRequest request, HttpServletResponse response, User user)
			throws IOException {

		int serviceId = Integer.parseInt(request.getParameter("serviceId"));
		int rating = Integer.parseInt(request.getParameter("rating"));
		String comment = request.getParameter("comment");

		if (feedbackDao.hasUserReviewed(user.getId(), serviceId)) {
			request.getSession().setAttribute("error", "You have already reviewed this service!");
			response.sendRedirect(request.getContextPath() + "/user/feedback");
			return;
		}

		if (rating == 0) {
			request.getSession().setAttribute("error", "Please select a rating!");
			response.sendRedirect(request.getContextPath() + "/user/feedback");
			return;
		}

		Feedback feedback = new Feedback();
		feedback.setServiceRequestId(serviceId);
		feedback.setUserId(user.getId());
		feedback.setRating(rating);
		feedback.setComment(comment);

		boolean submitted = feedbackDao.submitFeedback(feedback);

		if (submitted) {
			request.getSession().setAttribute("success", "Thank you for your feedback!");
		} else {
			request.getSession().setAttribute("error", "Failed to submit feedback");
		}

		response.sendRedirect(request.getContextPath() + "/user/feedback");
	}
}