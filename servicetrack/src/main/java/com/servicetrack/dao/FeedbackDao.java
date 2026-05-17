package com.servicetrack.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servicetrack.config.DBConnection;
import com.servicetrack.model.Feedback;

public class FeedbackDao {
    
    public boolean submitFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (service_request_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, feedback.getServiceRequestId());
            pstmt.setInt(2, feedback.getUserId());
            pstmt.setInt(3, feedback.getRating());
            pstmt.setString(4, feedback.getComment());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Feedback> getFeedbackByUserId(int userId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, sr.service_type FROM feedback f " +
                     "JOIN service_requests sr ON f.service_request_id = sr.id " +
                     "WHERE f.user_id = ? ORDER BY f.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setId(rs.getInt("id"));
                f.setServiceRequestId(rs.getInt("service_request_id"));
                f.setUserId(rs.getInt("user_id"));
                f.setRating(rs.getInt("rating"));
                f.setComment(rs.getString("comment"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                f.setServiceType(rs.getString("service_type"));
                feedbacks.add(f);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name as user_name, sr.service_type " +
                     "FROM feedback f " +
                     "JOIN users u ON f.user_id = u.id " +
                     "JOIN service_requests sr ON f.service_request_id = sr.id " +
                     "ORDER BY f.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setId(rs.getInt("id"));
                f.setServiceRequestId(rs.getInt("service_request_id"));
                f.setUserId(rs.getInt("user_id"));
                f.setRating(rs.getInt("rating"));
                f.setComment(rs.getString("comment"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                f.setUserName(rs.getString("user_name"));
                f.setServiceType(rs.getString("service_type"));
                feedbacks.add(f);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    
    public double getAverageRating() {
        String sql = "SELECT AVG(rating) as avg_rating FROM feedback";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public boolean hasUserReviewed(int userId, int serviceRequestId) {
        String sql = "SELECT id FROM feedback WHERE user_id = ? AND service_request_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, serviceRequestId);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}