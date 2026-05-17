package com.servicetrack.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servicetrack.config.DBConnection;
import com.servicetrack.model.Vehicle;

public class VehicleDao {
    
    // Create new vehicle
    public boolean createVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO vehicles (user_id, vehicle_number, model, brand, year) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, vehicle.getUserId());
            pstmt.setString(2, vehicle.getVehicleNumber());
            pstmt.setString(3, vehicle.getModel());
            pstmt.setString(4, vehicle.getBrand());
            pstmt.setInt(5, vehicle.getYear());
            
            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    vehicle.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get vehicles by user ID
    public List<Vehicle> getVehiclesByUserId(int userId) {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT * FROM vehicles WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Vehicle v = new Vehicle();
                v.setId(rs.getInt("id"));
                v.setUserId(rs.getInt("user_id"));
                v.setVehicleNumber(rs.getString("vehicle_number"));
                v.setModel(rs.getString("model"));
                v.setBrand(rs.getString("brand"));
                v.setYear(rs.getInt("year"));
                vehicles.add(v);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vehicles;
    }
    
    // Get vehicle by ID
    public Vehicle getVehicleById(int id) {
        String sql = "SELECT * FROM vehicles WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Vehicle v = new Vehicle();
                v.setId(rs.getInt("id"));
                v.setUserId(rs.getInt("user_id"));
                v.setVehicleNumber(rs.getString("vehicle_number"));
                v.setModel(rs.getString("model"));
                v.setBrand(rs.getString("brand"));
                v.setYear(rs.getInt("year"));
                return v;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update vehicle
    public boolean updateVehicle(Vehicle vehicle) {
        String sql = "UPDATE vehicles SET vehicle_number = ?, model = ?, brand = ?, year = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, vehicle.getVehicleNumber());
            pstmt.setString(2, vehicle.getModel());
            pstmt.setString(3, vehicle.getBrand());
            pstmt.setInt(4, vehicle.getYear());
            pstmt.setInt(5, vehicle.getId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete vehicle
    public boolean deleteVehicle(int id) {
        String sql = "DELETE FROM vehicles WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Check if vehicle number exists for user
    public boolean vehicleNumberExists(int userId, String vehicleNumber) {
        String sql = "SELECT id FROM vehicles WHERE user_id = ? AND vehicle_number = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setString(2, vehicleNumber);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}