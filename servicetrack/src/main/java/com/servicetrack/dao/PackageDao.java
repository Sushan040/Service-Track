package com.servicetrack.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servicetrack.config.DBConnection;
import com.servicetrack.model.ServicePackage;

public class PackageDao {
    
    public boolean createPackage(ServicePackage pkg) {
        String sql = "INSERT INTO service_packages (package_name, description, services_included, price, discount_percent, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, pkg.getPackageName());
            pstmt.setString(2, pkg.getDescription());
            pstmt.setString(3, pkg.getServicesIncluded());
            pstmt.setDouble(4, pkg.getPrice());
            pstmt.setInt(5, pkg.getDiscountPercent());
            pstmt.setBoolean(6, pkg.isActive());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<ServicePackage> getAllPackages() {
        List<ServicePackage> packages = new ArrayList<>();
        String sql = "SELECT * FROM service_packages WHERE is_active = TRUE ORDER BY price";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                ServicePackage pkg = new ServicePackage();
                pkg.setId(rs.getInt("id"));
                pkg.setPackageName(rs.getString("package_name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setServicesIncluded(rs.getString("services_included"));
                pkg.setPrice(rs.getDouble("price"));
                pkg.setDiscountPercent(rs.getInt("discount_percent"));
                pkg.setActive(rs.getBoolean("is_active"));
                packages.add(pkg);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }
    
    public ServicePackage getPackageById(int id) {
        String sql = "SELECT * FROM service_packages WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                ServicePackage pkg = new ServicePackage();
                pkg.setId(rs.getInt("id"));
                pkg.setPackageName(rs.getString("package_name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setServicesIncluded(rs.getString("services_included"));
                pkg.setPrice(rs.getDouble("price"));
                pkg.setDiscountPercent(rs.getInt("discount_percent"));
                pkg.setActive(rs.getBoolean("is_active"));
                return pkg;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updatePackage(ServicePackage pkg) {
        String sql = "UPDATE service_packages SET package_name = ?, description = ?, services_included = ?, price = ?, discount_percent = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, pkg.getPackageName());
            pstmt.setString(2, pkg.getDescription());
            pstmt.setString(3, pkg.getServicesIncluded());
            pstmt.setDouble(4, pkg.getPrice());
            pstmt.setInt(5, pkg.getDiscountPercent());
            pstmt.setBoolean(6, pkg.isActive());
            pstmt.setInt(7, pkg.getId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deletePackage(int id) {
        String sql = "DELETE FROM service_packages WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}