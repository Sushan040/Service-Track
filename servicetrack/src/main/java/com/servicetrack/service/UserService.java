package com.servicetrack.service;

import java.sql.Timestamp;
import java.util.List;
import com.servicetrack.dao.UserDao;
import com.servicetrack.model.User;
import com.servicetrack.util.PasswordUtil;
import com.servicetrack.util.ValidationUtil;

public class UserService {

	private UserDao userDao;

	public UserService() {
		this.userDao = new UserDao();
	}

	// =====================================================
	// REGISTRATION & LOGIN METHODS
	// =====================================================

	public boolean registerUser(User user) {
		if (!ValidationUtil.isValidName(user.getFullName())) {
			throw new IllegalArgumentException("Invalid full name");
		}
		if (!ValidationUtil.isValidEmail(user.getEmail())) {
			throw new IllegalArgumentException("Invalid email format");
		}
		if (!ValidationUtil.isValidPassword(user.getPassword())) {
			throw new IllegalArgumentException("Password must be at least 6 characters");
		}
		if (user.getPhone() != null && !user.getPhone().isEmpty() && !ValidationUtil.isValidPhone(user.getPhone())) {
			throw new IllegalArgumentException("Invalid phone number");
		}

		if (userDao.emailExists(user.getEmail())) {
			throw new IllegalArgumentException("Email already registered");
		}

		if (user.getRole() == null || user.getRole().isEmpty()) {
			user.setRole("customer");
		}

		return userDao.registerUser(user);
	}

	public User loginUser(String email, String password) {
		if (!ValidationUtil.isValidEmail(email)) {
			throw new IllegalArgumentException("Please enter a valid email address");
		}
		if (!ValidationUtil.isValidPassword(password)) {
			throw new IllegalArgumentException("Password must be at least 6 characters");
		}
		return userDao.loginUser(email, password);
	}

	// =====================================================
	// READ / GET METHODS - ADD THESE
	// =====================================================

	public User getUserById(int id) {
		if (id <= 0) {
			throw new IllegalArgumentException("Invalid user ID");
		}
		return userDao.getUserById(id);
	}

	public User getUserByEmail(String email) {
		if (!ValidationUtil.isValidEmail(email)) {
			throw new IllegalArgumentException("Invalid email format");
		}
		return userDao.getUserByEmail(email);
	}

	public List<User> getAllUsers() {
		return userDao.getAllUsers();
	}

	public List<User> getUsersByRole(String role) {
		if (role == null || role.trim().isEmpty()) {
			throw new IllegalArgumentException("Role is required");
		}
		return userDao.getUsersByRole(role);
	}

	public List<User> searchUsers(String keyword) {
		if (keyword == null || keyword.trim().isEmpty()) {
			throw new IllegalArgumentException("Search keyword is required");
		}
		return userDao.searchUsers(keyword);
	}

	public boolean emailExists(String email) {
		return userDao.emailExists(email);
	}

	// =====================================================
	// COUNT METHODS
	// =====================================================

	public int getTotalUsersCount() {
		return userDao.getTotalUsersCount();
	}

	public int getCustomersCount() {
		return userDao.getCountByRole("customer");
	}

	public int getAdminsCount() {
		return userDao.getCountByRole("admin");
	}

	// =====================================================
	// UPDATE METHODS
	// =====================================================

	public boolean updateUser(User user) {
		if (user.getId() <= 0) {
			throw new IllegalArgumentException("Invalid user ID");
		}
		return userDao.updateUser(user);
	}

	public boolean updatePassword(int userId, String newHashedPassword) {
		if (userId <= 0) {
			throw new IllegalArgumentException("Invalid user ID");
		}
		if (newHashedPassword == null || newHashedPassword.trim().isEmpty()) {
			throw new IllegalArgumentException("Password cannot be empty");
		}
		return userDao.updatePassword(userId, newHashedPassword);
	}

	public boolean updateUserRole(int userId, String newRole) {
		if (userId <= 0) {
			throw new IllegalArgumentException("Invalid user ID");
		}
		if (!"admin".equals(newRole) && !"customer".equals(newRole)) {
			throw new IllegalArgumentException("Invalid role");
		}
		return userDao.updateUserRole(userId, newRole);
	}

	public boolean verifyPassword(int userId, String currentPassword) {
		User user = userDao.getUserById(userId);
		if (user == null) {
			return false;
		}
		return PasswordUtil.verifyPassword(currentPassword, user.getPassword());
	}

	// =====================================================
	// ACCOUNT STATUS METHODS
	// =====================================================

	public boolean isUserActive(int userId) {
		return userDao.isUserActive(userId);
	}

	public void updateLastLogin(int userId) {
		userDao.updateLastLogin(userId);
	}

	// =====================================================
	// DELETE METHODS
	// =====================================================

	public boolean deleteUser(int userId) {
		if (userId <= 0) {
			throw new IllegalArgumentException("Invalid user ID");
		}
		return userDao.deleteUser(userId);
	}

	public boolean deleteAllCustomers() {
		return userDao.deleteUsersByRole("customer");
	}

	// =====================================================
	// VALIDATION METHODS
	// =====================================================

	public boolean isValidUser(User user) {
		try {
			if (user.getFullName() == null || user.getFullName().trim().length() < 2)
				return false;
			if (user.getEmail() == null || !ValidationUtil.isValidEmail(user.getEmail()))
				return false;
			if (user.getPassword() == null || user.getPassword().length() < 6)
				return false;
			return true;
		} catch (Exception e) {
			return false;
		}
	}


	public boolean incrementFailedLoginAttempts(int userId) {
		return userDao.incrementFailedLoginAttempts(userId);
	}

	public boolean resetFailedLoginAttempts(int userId) {
		return userDao.resetFailedLoginAttempts(userId);
	}

	public boolean lockAccount(int userId) {
		return userDao.lockAccount(userId);
	}

	public boolean unlockAccount(int userId) {
		return userDao.unlockAccount(userId);
	}

	public boolean isAccountLocked(int userId) {
		return userDao.isAccountLocked(userId);
	}
	
	public int getFailedLoginAttempts(int userId) {
	    return userDao.getFailedLoginAttempts(userId);
	}
	
	// Add these methods to UserService.java

	public boolean savePasswordResetToken(String email, String token, Timestamp expiresAt) {
	    return userDao.savePasswordResetToken(email, token, expiresAt);
	}

	public boolean isValidResetToken(String token) {
	    return userDao.isValidResetToken(token);
	}

	public String getEmailByResetToken(String token) {
	    return userDao.getEmailByResetToken(token);
	}

	public boolean deleteResetToken(String token) {
	    return userDao.deleteResetToken(token);
	}

}