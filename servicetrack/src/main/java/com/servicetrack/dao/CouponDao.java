package com.servicetrack.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servicetrack.config.DBConnection;
import com.servicetrack.model.Coupon;

public class CouponDao {
    
    // Create new coupon
    public boolean createCoupon(Coupon coupon) {
        String sql = "INSERT INTO coupons (code, description, discount_type, discount_value, min_order_amount, max_discount, valid_from, valid_until, usage_limit, used_count, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, coupon.getCode());
            pstmt.setString(2, coupon.getDescription());
            pstmt.setString(3, coupon.getDiscountType());
            pstmt.setDouble(4, coupon.getDiscountValue());
            pstmt.setDouble(5, coupon.getMinOrderAmount());
            if (coupon.getMaxDiscount() != null) {
                pstmt.setDouble(6, coupon.getMaxDiscount());
            } else {
                pstmt.setNull(6, Types.DOUBLE);
            }
            pstmt.setDate(7, coupon.getValidFrom());
            pstmt.setDate(8, coupon.getValidUntil());
            pstmt.setInt(9, coupon.getUsageLimit());
            pstmt.setInt(10, coupon.getUsedCount());
            pstmt.setBoolean(11, coupon.isActive());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all coupons
    public List<Coupon> getAllCoupons() {
        List<Coupon> coupons = new ArrayList<>();
        String sql = "SELECT * FROM coupons ORDER BY valid_until DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Coupon c = new Coupon();
                c.setId(rs.getInt("id"));
                c.setCode(rs.getString("code"));
                c.setDescription(rs.getString("description"));
                c.setDiscountType(rs.getString("discount_type"));
                c.setDiscountValue(rs.getDouble("discount_value"));
                c.setMinOrderAmount(rs.getDouble("min_order_amount"));
                double maxDiscount = rs.getDouble("max_discount");
                if (!rs.wasNull()) {
                    c.setMaxDiscount(maxDiscount);
                }
                c.setValidFrom(rs.getDate("valid_from"));
                c.setValidUntil(rs.getDate("valid_until"));
                c.setUsageLimit(rs.getInt("usage_limit"));
                c.setUsedCount(rs.getInt("used_count"));
                c.setActive(rs.getBoolean("is_active"));
                coupons.add(c);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return coupons;
    }
    
    // Get coupon by ID
    public Coupon getCouponById(int id) {
        String sql = "SELECT * FROM coupons WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Coupon c = new Coupon();
                c.setId(rs.getInt("id"));
                c.setCode(rs.getString("code"));
                c.setDescription(rs.getString("description"));
                c.setDiscountType(rs.getString("discount_type"));
                c.setDiscountValue(rs.getDouble("discount_value"));
                c.setMinOrderAmount(rs.getDouble("min_order_amount"));
                double maxDiscount = rs.getDouble("max_discount");
                if (!rs.wasNull()) {
                    c.setMaxDiscount(maxDiscount);
                }
                c.setValidFrom(rs.getDate("valid_from"));
                c.setValidUntil(rs.getDate("valid_until"));
                c.setUsageLimit(rs.getInt("usage_limit"));
                c.setUsedCount(rs.getInt("used_count"));
                c.setActive(rs.getBoolean("is_active"));
                return c;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get coupon by code
    public Coupon getCouponByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, code);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Coupon c = new Coupon();
                c.setId(rs.getInt("id"));
                c.setCode(rs.getString("code"));
                c.setDescription(rs.getString("description"));
                c.setDiscountType(rs.getString("discount_type"));
                c.setDiscountValue(rs.getDouble("discount_value"));
                c.setMinOrderAmount(rs.getDouble("min_order_amount"));
                double maxDiscount = rs.getDouble("max_discount");
                if (!rs.wasNull()) {
                    c.setMaxDiscount(maxDiscount);
                }
                c.setValidFrom(rs.getDate("valid_from"));
                c.setValidUntil(rs.getDate("valid_until"));
                c.setUsageLimit(rs.getInt("usage_limit"));
                c.setUsedCount(rs.getInt("used_count"));
                c.setActive(rs.getBoolean("is_active"));
                return c;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Update coupon
    public boolean updateCoupon(Coupon coupon) {
        String sql = "UPDATE coupons SET code = ?, description = ?, discount_type = ?, discount_value = ?, min_order_amount = ?, max_discount = ?, valid_from = ?, valid_until = ?, usage_limit = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, coupon.getCode());
            pstmt.setString(2, coupon.getDescription());
            pstmt.setString(3, coupon.getDiscountType());
            pstmt.setDouble(4, coupon.getDiscountValue());
            pstmt.setDouble(5, coupon.getMinOrderAmount());
            if (coupon.getMaxDiscount() != null) {
                pstmt.setDouble(6, coupon.getMaxDiscount());
            } else {
                pstmt.setNull(6, Types.DOUBLE);
            }
            pstmt.setDate(7, coupon.getValidFrom());
            pstmt.setDate(8, coupon.getValidUntil());
            pstmt.setInt(9, coupon.getUsageLimit());
            pstmt.setBoolean(10, coupon.isActive());
            pstmt.setInt(11, coupon.getId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete coupon
    public boolean deleteCoupon(int id) {
        String sql = "DELETE FROM coupons WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Increment usage count
    public boolean incrementUsage(String code) {
        String sql = "UPDATE coupons SET used_count = used_count + 1 WHERE code = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, code);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}