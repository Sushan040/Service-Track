package com.servicetrack.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servicetrack.config.DBConnection;
import com.servicetrack.model.Reminder;

public class ReminderDao {
    
    public List<Reminder> getRemindersByUserId(int userId) {
        List<Reminder> reminders = new ArrayList<>();
        String sql = "SELECT r.*, v.model as vehicle_model, v.vehicle_number " +
                     "FROM reminders r " +
                     "JOIN vehicles v ON r.vehicle_id = v.id " +
                     "WHERE r.user_id = ? AND r.reminder_date >= CURDATE() AND r.is_sent = FALSE " +
                     "ORDER BY r.reminder_date ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Reminder r = new Reminder();
                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setVehicleId(rs.getInt("vehicle_id"));
                r.setReminderType(rs.getString("reminder_type"));
                r.setReminderDate(rs.getDate("reminder_date"));
                r.setMessage(rs.getString("message"));
                r.setSent(rs.getBoolean("is_sent"));
                r.setVehicleModel(rs.getString("vehicle_model"));
                r.setVehicleNumber(rs.getString("vehicle_number"));
                reminders.add(r);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reminders;
    }
    
    public boolean markAsSent(int id) {
        String sql = "UPDATE reminders SET is_sent = TRUE WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean createReminder(Reminder reminder) {
        String sql = "INSERT INTO reminders (user_id, vehicle_id, reminder_type, reminder_date, message) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reminder.getUserId());
            pstmt.setInt(2, reminder.getVehicleId());
            pstmt.setString(3, reminder.getReminderType());
            pstmt.setDate(4, reminder.getReminderDate());
            pstmt.setString(5, reminder.getMessage());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}