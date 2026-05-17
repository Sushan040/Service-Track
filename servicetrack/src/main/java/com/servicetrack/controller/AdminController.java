package com.servicetrack.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.servicetrack.model.Coupon;
import com.servicetrack.model.ServicePackage;
import com.servicetrack.model.ServiceRequest;
import com.servicetrack.model.User;
import com.servicetrack.service.ServiceRequestService;
import com.servicetrack.service.UserService;
import com.servicetrack.service.PackageService;
import com.servicetrack.service.CouponService;
import com.servicetrack.util.PasswordUtil;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService;
	private ServiceRequestService serviceRequestService;
	private PackageService packageService;
	private CouponService couponService;

	@Override
	public void init() {
		userService = new UserService();
		serviceRequestService = new ServiceRequestService();
		packageService = new PackageService();
		couponService = new CouponService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/auth/login");
			return;
		}

		String path = request.getPathInfo();
		System.out.println("AdminController GET - Path: " + path);

		if (path == null || "/dashboard".equals(path)) {
			showDashboard(request, response);
		} else if ("/users".equals(path)) {
			showManageUsers(request, response);
		} else if ("/users/edit".equals(path)) {
			editUserForm(request, response);
		}else if ("/users/unlock".equals(path)) {
		    unlockUser(request, response);
		} else if ("/users/delete".equals(path)) {
			deleteUser(request, response);
		} else if ("/packages".equals(path)) {
			showManagePackages(request, response);
		} else if ("/packages/edit".equals(path)) {
			editPackageForm(request, response);
		} else if ("/packages/delete".equals(path)) {
			deletePackage(request, response);
		} else if ("/coupons".equals(path)) {
			showManageCoupons(request, response);
		} else if ("/coupons/edit".equals(path)) {
			editCouponForm(request, response);
		} else if ("/coupons/delete".equals(path)) {
			deleteCoupon(request, response);
		} else if ("/reports".equals(path)) {
			showReports(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/auth/login");
			return;
		}

		String path = request.getPathInfo();
		System.out.println("AdminController POST - Path: " + path);

		if ("/users/save".equals(path)) {
			saveUser(request, response);
		} else if ("/packages/save".equals(path)) {
			savePackage(request, response);
		} else if ("/coupons/save".equals(path)) {
			saveCoupon(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "POST handler not found: " + path);
		}
	}

	// =====================================================
	// DASHBOARD METHODS
	// =====================================================

	private void showDashboard(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Fetch real data from database
		int totalUsers = userService.getTotalUsersCount();
		int pendingServices = serviceRequestService.getPendingServicesCount();
		int activeServices = serviceRequestService.getActiveServicesCount();
		int completedServices = serviceRequestService.getCompletedServicesCount();
		int totalServices = serviceRequestService.getTotalServicesCount();

		// Get recent service requests
		List<ServiceRequest> recentServices = serviceRequestService.getRecentServiceRequests(5);

		// Set attributes for JSP
		request.setAttribute("totalUsers", totalUsers);
		request.setAttribute("pendingServices", pendingServices);
		request.setAttribute("activeServices", activeServices);
		request.setAttribute("completedServices", completedServices);
		request.setAttribute("totalServices", totalServices);
		request.setAttribute("recentServices", recentServices);

		request.getRequestDispatcher("/WEB-INF/views/admin/admin-dashboard.jsp").forward(request, response);
	}
	
	private List<Map<String, String>> getRecentActivities() {
        List<Map<String, String>> activities = new ArrayList<>();
        
        // Get recent service requests as activities
        List<ServiceRequest> recentServices = serviceRequestService.getRecentServiceRequests(5);
        
        for (ServiceRequest sr : recentServices) {
            Map<String, String> activity = new HashMap<>();
            activity.put("message", "New service request from " + (sr.getCustomerName() != null ? sr.getCustomerName() : "Customer"));
            activity.put("time", sr.getCreatedAt() != null ? sr.getCreatedAt().toString() : "Just now");
            activity.put("type", "service");
            activities.add(activity);
        }
        
        // If no activities, add placeholder
        if (activities.isEmpty()) {
            Map<String, String> activity = new HashMap<>();
            activity.put("message", "No recent activities");
            activity.put("time", "");
            activity.put("type", "empty");
            activities.add(activity);
        }
        
        return activities;
    }

	// =====================================================
	// USER MANAGEMENT METHODS
	// =====================================================

	private void showManageUsers(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<User> users = userService.getAllUsers();
		request.setAttribute("users", users);
		request.getRequestDispatcher("/WEB-INF/views/admin/manage-users.jsp").forward(request, response);
	}

    private void editUserForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("id"));
        User user = userService.getUserById(userId);
        
        if (user == null) {
            request.getSession().setAttribute("error", "User not found");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.setAttribute("editUser", user);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/manage-users.jsp").forward(request, response);
    }

	private void saveUser(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String userIdParam = request.getParameter("userId");
		String fullName = request.getParameter("fullName");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");
		String role = request.getParameter("role");
		String password = request.getParameter("password");

		try {
			if (userIdParam != null && !userIdParam.isEmpty()) {
				// Update existing user
				int userId = Integer.parseInt(userIdParam);
				User existingUser = userService.getUserById(userId);

				existingUser.setFullName(fullName);
				existingUser.setEmail(email);
				existingUser.setPhone(phone);
				existingUser.setAddress(address);
				existingUser.setRole(role);

				if (password != null && !password.trim().isEmpty()) {
					existingUser.setPassword(PasswordUtil.hashPassword(password));
				}

				userService.updateUser(existingUser);
				request.getSession().setAttribute("success", "User updated successfully!");
			} else {
				// Create new user
				if (password == null || password.trim().isEmpty()) {
					request.getSession().setAttribute("error", "Password is required for new user");
					response.sendRedirect(request.getContextPath() + "/admin/users");
					return;
				}

				User newUser = new User();
				newUser.setFullName(fullName);
				newUser.setEmail(email);
				newUser.setPassword(password);
				newUser.setPhone(phone);
				newUser.setAddress(address);
				newUser.setRole(role);

				userService.registerUser(newUser);
				request.getSession().setAttribute("success", "User created successfully!");
			}
		} catch (Exception e) {
			request.getSession().setAttribute("error", "Failed to save user: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/admin/users");
	}

	private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int userId = Integer.parseInt(request.getParameter("id"));
		HttpSession session = request.getSession();
		User currentAdmin = (User) session.getAttribute("user");

		if (currentAdmin.getId() == userId) {
			session.setAttribute("error", "You cannot delete your own account!");
		} else {
			userService.deleteUser(userId);
			session.setAttribute("success", "User deleted successfully!");
		}

		response.sendRedirect(request.getContextPath() + "/admin/users");
	}

	// =====================================================
	// PACKAGE MANAGEMENT METHODS
	// =====================================================

	private void showManagePackages(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<ServicePackage> packages = packageService.getAllPackages();
		request.setAttribute("packages", packages);
		request.getRequestDispatcher("/WEB-INF/views/admin/manage-packages.jsp").forward(request, response);
	}

	private void editPackageForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int packageId = Integer.parseInt(request.getParameter("id"));
		ServicePackage pkg = packageService.getPackageById(packageId);

		if (pkg == null) {
			request.getSession().setAttribute("error", "Package not found");
			response.sendRedirect(request.getContextPath() + "/admin/packages");
			return;
		}

		List<ServicePackage> packages = packageService.getAllPackages();
		request.setAttribute("packages", packages);
		request.setAttribute("editPackage", pkg);

		request.getRequestDispatcher("/WEB-INF/views/admin/manage-packages.jsp").forward(request, response);
	}

	private void savePackage(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String packageIdParam = request.getParameter("packageId");
		String packageName = request.getParameter("packageName");
		String description = request.getParameter("description");
		String servicesIncluded = request.getParameter("servicesIncluded");
		double price = Double.parseDouble(request.getParameter("price"));
		int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));

		ServicePackage pkg = new ServicePackage();
		pkg.setPackageName(packageName);
		pkg.setDescription(description);
		pkg.setServicesIncluded(servicesIncluded);
		pkg.setPrice(price);
		pkg.setDiscountPercent(discountPercent);
		pkg.setActive(true);

		try {
			if (packageIdParam != null && !packageIdParam.isEmpty()) {
				pkg.setId(Integer.parseInt(packageIdParam));
				packageService.updatePackage(pkg);
				request.getSession().setAttribute("success", "Package updated successfully!");
			} else {
				packageService.addPackage(pkg);
				request.getSession().setAttribute("success", "Package added successfully!");
			}
		} catch (Exception e) {
			request.getSession().setAttribute("error", "Failed to save package: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/admin/packages");
	}

	private void deletePackage(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int packageId = Integer.parseInt(request.getParameter("id"));
		packageService.deletePackage(packageId);
		request.getSession().setAttribute("success", "Package deleted successfully!");
		response.sendRedirect(request.getContextPath() + "/admin/packages");
	}

	// =====================================================
	// REPORTS METHODS
	// =====================================================

	private void showReports(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Get statistics
		int totalServices = serviceRequestService.getTotalServicesCount();
		int totalEarnings = (int) serviceRequestService.getTotalEarnings();
		double avgRating = serviceRequestService.getAverageRating();
		int totalUsers = userService.getTotalUsersCount();

		// Get status statistics
		Map<String, Integer> statusStats = new HashMap<>();
		statusStats.put("pending", serviceRequestService.getPendingServicesCount());
		statusStats.put("in_progress", serviceRequestService.getActiveServicesCount());
		statusStats.put("completed", serviceRequestService.getCompletedServicesCount());
		statusStats.put("cancelled", serviceRequestService.getCancelledServicesCount());

		// Get monthly revenue data
		List<Object[]> monthlyData = serviceRequestService.getMonthlyEarningsChart();
		List<String> months = new ArrayList<>();
		List<Double> revenues = new ArrayList<>();

		String[] monthNames = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
		for (int i = 1; i <= 6; i++) {
			months.add(monthNames[i - 1]);
			revenues.add(0.0);
		}

		for (Object[] data : monthlyData) {
			int monthIndex = ((Number) data[0]).intValue() - 1;
			if (monthIndex >= 0 && monthIndex < 6) {
				revenues.set(monthIndex, ((Number) data[1]).doubleValue());
			}
		}

		request.setAttribute("totalServices", totalServices);
		request.setAttribute("totalEarnings", totalEarnings);
		request.setAttribute("avgRating", avgRating);
		request.setAttribute("totalUsers", totalUsers);
		request.setAttribute("statusStats", statusStats);
		request.setAttribute("months", months);
		request.setAttribute("revenues", revenues);

		request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
	}

	// =====================================================
	// COUPON MANAGEMENT METHODS
	// =====================================================

	private void showManageCoupons(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Coupon> coupons = couponService.getAllCoupons();
		request.setAttribute("coupons", coupons);
		request.getRequestDispatcher("/WEB-INF/views/admin/manage-coupons.jsp").forward(request, response);
	}

	private void saveCoupon(HttpServletRequest request, HttpServletResponse response) throws IOException {

		try {
			String couponIdParam = request.getParameter("couponId");
			String code = request.getParameter("code");
			String description = request.getParameter("description");
			String discountType = request.getParameter("discountType");
			double discountValue = Double.parseDouble(request.getParameter("discountValue"));
			double minOrderAmount = Double.parseDouble(request.getParameter("minOrderAmount"));
			String maxDiscountStr = request.getParameter("maxDiscount");
			Date validFrom = Date.valueOf(request.getParameter("validFrom"));
			Date validUntil = Date.valueOf(request.getParameter("validUntil"));
			int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));

			Double maxDiscount = (maxDiscountStr != null && !maxDiscountStr.isEmpty())
					? Double.parseDouble(maxDiscountStr)
					: null;

			Coupon coupon = new Coupon();
			coupon.setCode(code.toUpperCase());
			coupon.setDescription(description);
			coupon.setDiscountType(discountType);
			coupon.setDiscountValue(discountValue);
			coupon.setMinOrderAmount(minOrderAmount);
			coupon.setMaxDiscount(maxDiscount);
			coupon.setValidFrom(validFrom);
			coupon.setValidUntil(validUntil);
			coupon.setUsageLimit(usageLimit);
			coupon.setUsedCount(0);
			coupon.setActive(true);

			if (couponIdParam != null && !couponIdParam.isEmpty()) {
				coupon.setId(Integer.parseInt(couponIdParam));
				couponService.updateCoupon(coupon);
				request.getSession().setAttribute("success", "Coupon updated successfully!");
			} else {
				couponService.addCoupon(coupon);
				request.getSession().setAttribute("success", "Coupon added successfully!");
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.getSession().setAttribute("error", "Failed to save coupon: " + e.getMessage());
		}

		response.sendRedirect(request.getContextPath() + "/admin/coupons");
	}

	private void editCouponForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int couponId = Integer.parseInt(request.getParameter("id"));
		Coupon coupon = couponService.getCouponById(couponId);

		if (coupon == null) {
			request.getSession().setAttribute("error", "Coupon not found");
			response.sendRedirect(request.getContextPath() + "/admin/coupons");
			return;
		}

		List<Coupon> coupons = couponService.getAllCoupons();
		request.setAttribute("coupons", coupons);
		request.setAttribute("editCoupon", coupon);

		request.getRequestDispatcher("/WEB-INF/views/admin/manage-coupons.jsp").forward(request, response);
	}

	private void deleteCoupon(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int couponId = Integer.parseInt(request.getParameter("id"));
		couponService.deleteCoupon(couponId);
		request.getSession().setAttribute("success", "Coupon deleted successfully!");
		response.sendRedirect(request.getContextPath() + "/admin/coupons");
	}
	
	private void unlockUser(HttpServletRequest request, HttpServletResponse response) 
	        throws IOException {
	    
	    int userId = Integer.parseInt(request.getParameter("id"));
	    userService.unlockAccount(userId);
	    request.getSession().setAttribute("success", "User account unlocked successfully!");
	    response.sendRedirect(request.getContextPath() + "/admin/users");
	}
}