package com.servicetrack.model;

import java.sql.Timestamp;

public class User {
	private int id;
	private String fullName;
	private String email;
	private String password;
	private String phone;
	private String address;
	private String role;
	private int failedLoginAttempts;
	private boolean accountLocked;
	private Timestamp lockoutTime;
	private Timestamp createdAt;
	private Timestamp updatedAt;

	public User() {
	}

	public User(String fullName, String email, String password, String phone, String address, String role) {
		this.fullName = fullName;
		this.email = email;
		this.password = password;
		this.phone = phone;
		this.address = address;
		this.role = role;
		this.failedLoginAttempts = 0;
		this.accountLocked = false;
	}

	// Getters and Setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public int getFailedLoginAttempts() {
		return failedLoginAttempts;
	}

	public void setFailedLoginAttempts(int failedLoginAttempts) {
		this.failedLoginAttempts = failedLoginAttempts;
	}

	public boolean isAccountLocked() {
		return accountLocked;
	}

	public void setAccountLocked(boolean accountLocked) {
		this.accountLocked = accountLocked;
	}

	public Timestamp getLockoutTime() {
		return lockoutTime;
	}

	public void setLockoutTime(Timestamp lockoutTime) {
		this.lockoutTime = lockoutTime;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}

	// Helper Methods
	public boolean isAdmin() {
		return "admin".equals(role);
	}

	public boolean isCustomer() {
		return "customer".equals(role);
	}

	public void incrementFailedAttempts() {
		this.failedLoginAttempts++;
	}

	public void resetFailedAttempts() {
		this.failedLoginAttempts = 0;
	}

	public void lockAccount() {
		this.accountLocked = true;
		this.lockoutTime = new Timestamp(System.currentTimeMillis());
	}

	public void unlockAccount() {
		this.accountLocked = false;
		this.failedLoginAttempts = 0;
		this.lockoutTime = null;
	}

	public boolean isLockoutExpired() {
		if (!accountLocked || lockoutTime == null)
			return false;
		// Lockout expires after 15 minutes (900000 milliseconds)
		long lockoutDuration = 15 * 60 * 1000;
		long currentTime = System.currentTimeMillis();
		return (currentTime - lockoutTime.getTime()) > lockoutDuration;
	}
}