package com.servicetrack.dao;

import java.sql.*;
import com.servicetrack.config.DBConnection;
import com.servicetrack.model.User;
import com.servicetrack.util.PasswordUtil;

public class UserDao {
    
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, address, role) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error in registerUser: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                // Don't close connection here - let it be reused
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                
                // Check if password matches (supports both hashed and plain for testing)
                if (PasswordUtil.verifyPassword(password, hashedPassword) || password.equals(hashedPassword)) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));
                    System.out.println("User logged in successfully: " + email);
                    return user;
                } else {
                    System.out.println("Password mismatch for user: " + email);
                    return null;
                }
            } else {
                System.out.println("User not found with email: " + email);
                return null;
            }
            
        } catch (SQLException e) {
            System.err.println("Error in loginUser: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                return user;
            }
            
        } catch (SQLException e) {
            System.err.println("Error in getUserById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
    
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.err.println("Error in emailExists: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}