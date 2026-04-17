package com.servicetrack.dao;

import com.servicetrack.config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ServiceRequestDao {

    public void save(int userId, String serviceType) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO service_requests(user_id, service_type, status) VALUES (?, ?, 'PENDING')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, serviceType);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}