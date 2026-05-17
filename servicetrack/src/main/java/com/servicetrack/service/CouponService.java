package com.servicetrack.service;

import java.util.List;
import com.servicetrack.dao.CouponDao;
import com.servicetrack.model.Coupon;

public class CouponService {
    
    private CouponDao couponDao;
    
    public CouponService() {
        this.couponDao = new CouponDao();
    }
    
    public List<Coupon> getAllCoupons() {
        return couponDao.getAllCoupons();
    }
    
    public Coupon getCouponById(int id) {
        return couponDao.getCouponById(id);
    }
    
    public Coupon getCouponByCode(String code) {
        return couponDao.getCouponByCode(code);
    }
    
    public boolean addCoupon(Coupon coupon) {
        // Validation
        if (coupon.getCode() == null || coupon.getCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Coupon code is required");
        }
        if (coupon.getDiscountValue() <= 0) {
            throw new IllegalArgumentException("Discount value must be greater than 0");
        }
        if (coupon.getValidFrom() == null || coupon.getValidUntil() == null) {
            throw new IllegalArgumentException("Valid from and valid until dates are required");
        }
        if (coupon.getValidUntil().before(coupon.getValidFrom())) {
            throw new IllegalArgumentException("Valid until date must be after valid from date");
        }
        
        return couponDao.createCoupon(coupon);
    }
    
    public boolean updateCoupon(Coupon coupon) {
        return couponDao.updateCoupon(coupon);
    }
    
    public boolean deleteCoupon(int id) {
        return couponDao.deleteCoupon(id);
    }
    
    public boolean incrementUsage(String code) {
        return couponDao.incrementUsage(code);
    }
    
    public double validateAndGetDiscount(String code, double amount) {
        Coupon coupon = couponDao.getCouponByCode(code);
        
        if (coupon == null || !coupon.isActive()) {
            return 0;
        }
        
        java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
        if (today.before(coupon.getValidFrom()) || today.after(coupon.getValidUntil())) {
            return 0;
        }
        
        if (coupon.getUsedCount() >= coupon.getUsageLimit()) {
            return 0;
        }
        
        if (amount < coupon.getMinOrderAmount()) {
            return 0;
        }
        
        double discount = 0;
        if ("percentage".equals(coupon.getDiscountType())) {
            discount = amount * coupon.getDiscountValue() / 100;
            if (coupon.getMaxDiscount() != null && discount > coupon.getMaxDiscount()) {
                discount = coupon.getMaxDiscount();
            }
        } else {
            discount = coupon.getDiscountValue();
        }
        
        return discount;
    }
}