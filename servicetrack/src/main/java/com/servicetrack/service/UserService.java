package com.servicetrack.service;

import com.servicetrack.dao.UserDao;
import com.servicetrack.model.User;
import com.servicetrack.util.ValidationUtil;

public class UserService {
    
    private UserDao userDao;
    
    public UserService() {
        this.userDao = new UserDao();
    }
    
    public boolean registerUser(User user) {
        // Validate input
        if (!ValidationUtil.isValidName(user.getFullName())) {
            throw new IllegalArgumentException("Invalid full name. Name must be at least 2 characters.");
        }
        if (!ValidationUtil.isValidEmail(user.getEmail())) {
            throw new IllegalArgumentException("Invalid email format. Please enter a valid email address.");
        }
        if (!ValidationUtil.isValidPassword(user.getPassword())) {
            throw new IllegalArgumentException("Password must be at least 6 characters long.");
        }
        if (user.getPhone() != null && !user.getPhone().isEmpty() && 
            !ValidationUtil.isValidPhone(user.getPhone())) {
            throw new IllegalArgumentException("Invalid phone number. Must be 10 digits.");
        }
        
        // Check if email already exists
        if (userDao.emailExists(user.getEmail())) {
            throw new IllegalArgumentException("Email already registered. Please use a different email or login.");
        }
        
        // Role is already set by controller
        return userDao.registerUser(user);
    }
    
    public User loginUser(String email, String password) {
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Please enter a valid email address.");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException("Password must be at least 6 characters.");
        }
        
        User user = userDao.loginUser(email, password);
        return user;
    }
    
    public User getUserById(int id) {
        return userDao.getUserById(id);
    }
    
    public boolean emailExists(String email) {
        return userDao.emailExists(email);
    }
}