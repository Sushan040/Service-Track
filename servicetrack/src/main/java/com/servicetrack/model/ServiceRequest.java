package com.servicetrack.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ServiceRequest {
    
    private int id;
    private int userId;
    private int vehicleId;
    private Integer packageId;
    private String serviceType;
    private String description;
    private Date preferredDate;
    private String preferredTime;
    private String status;
    private Integer assignedMechanicId;
    private double totalAmount;
    private String paymentStatus;
    private String paymentMethod;
    private String transactionId;
    private String couponCode;
    private double discountApplied;
    private boolean reminderSent;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp startedAt;
    private Timestamp completedAt;
    private String cancelledReason;
    
    // Transient fields for display
    private String customerName;
    private String vehicleModel;
    private String vehicleNumber;
    private String mechanicName;
    private String packageName;
    
    // Constructors
    public ServiceRequest() {}
    
    public ServiceRequest(int userId, int vehicleId, String serviceType, String description, Date preferredDate) {
        this.userId = userId;
        this.vehicleId = vehicleId;
        this.serviceType = serviceType;
        this.description = description;
        this.preferredDate = preferredDate;
        this.status = "pending";
        this.paymentStatus = "unpaid";
        this.discountApplied = 0;
        this.reminderSent = false;
    }
    
    // =====================================================
    // GETTERS AND SETTERS
    // =====================================================
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getVehicleId() {
        return vehicleId;
    }
    
    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }
    
    public Integer getPackageId() {
        return packageId;
    }
    
    public void setPackageId(Integer packageId) {
        this.packageId = packageId;
    }
    
    public String getServiceType() {
        return serviceType;
    }
    
    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Date getPreferredDate() {
        return preferredDate;
    }
    
    public void setPreferredDate(Date preferredDate) {
        this.preferredDate = preferredDate;
    }
    
    public String getPreferredTime() {
        return preferredTime;
    }
    
    public void setPreferredTime(String preferredTime) {
        this.preferredTime = preferredTime;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Integer getAssignedMechanicId() {
        return assignedMechanicId;
    }
    
    public void setAssignedMechanicId(Integer assignedMechanicId) {
        this.assignedMechanicId = assignedMechanicId;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    
    public String getCouponCode() {
        return couponCode;
    }
    
    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }
    
    public double getDiscountApplied() {
        return discountApplied;
    }
    
    public void setDiscountApplied(double discountApplied) {
        this.discountApplied = discountApplied;
    }
    
    public boolean isReminderSent() {
        return reminderSent;
    }
    
    public void setReminderSent(boolean reminderSent) {
        this.reminderSent = reminderSent;
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
    
    public Timestamp getStartedAt() {
        return startedAt;
    }
    
    public void setStartedAt(Timestamp startedAt) {
        this.startedAt = startedAt;
    }
    
    public Timestamp getCompletedAt() {
        return completedAt;
    }
    
    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }
    
    public String getCancelledReason() {
        return cancelledReason;
    }
    
    public void setCancelledReason(String cancelledReason) {
        this.cancelledReason = cancelledReason;
    }
    
    // =====================================================
    // TRANSIENT FIELDS GETTERS/SETTERS (for display)
    // =====================================================
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getVehicleModel() {
        return vehicleModel;
    }
    
    public void setVehicleModel(String vehicleModel) {
        this.vehicleModel = vehicleModel;
    }
    
    public String getVehicleNumber() {
        return vehicleNumber;
    }
    
    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }
    
    public String getMechanicName() {
        return mechanicName;
    }
    
    public void setMechanicName(String mechanicName) {
        this.mechanicName = mechanicName;
    }
    
    public String getPackageName() {
        return packageName;
    }
    
    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }
    
    // =====================================================
    // HELPER METHODS
    // =====================================================
    
    public double getFinalAmount() {
        return totalAmount - discountApplied;
    }
    
    public String getFormattedAmount() {
        return String.format("NPR %.2f", totalAmount);
    }
    
    public String getFormattedFinalAmount() {
        return String.format("NPR %.2f", getFinalAmount());
    }
    
    public boolean isCompleted() {
        return "completed".equals(status);
    }
    
    public boolean isInProgress() {
        return "in_progress".equals(status);
    }
    
    public boolean isPending() {
        return "pending".equals(status);
    }
    
    public boolean isCancelled() {
        return "cancelled".equals(status);
    }
    
    public boolean isPaid() {
        return "paid".equals(paymentStatus);
    }
    
    public String getStatusBadgeClass() {
        switch(status) {
            case "pending": return "status-pending";
            case "approved": return "status-approved";
            case "in_progress": return "status-in-progress";
            case "completed": return "status-completed";
            case "cancelled": return "status-cancelled";
            default: return "status-default";
        }
    }
    
    public String getStatusDisplay() {
        switch(status) {
            case "pending": return "Pending";
            case "approved": return "Approved";
            case "in_progress": return "In Progress";
            case "completed": return "Completed";
            case "cancelled": return "Cancelled";
            default: return status;
        }
    }
    
    public String getPaymentBadgeClass() {
        switch(paymentStatus) {
            case "paid": return "payment-paid";
            case "unpaid": return "payment-unpaid";
            case "refunded": return "payment-refunded";
            default: return "payment-default";
        }
    }
    
    public int getDurationDays() {
        if (startedAt != null && completedAt != null) {
            long diff = completedAt.getTime() - startedAt.getTime();
            return (int) (diff / (1000 * 60 * 60 * 24));
        }
        return 0;
    }
    
    @Override
    public String toString() {
        return "ServiceRequest{" +
                "id=" + id +
                ", serviceType='" + serviceType + '\'' +
                ", status='" + status + '\'' +
                ", totalAmount=" + totalAmount +
                '}';
    }
}