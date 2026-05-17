package com.servicetrack.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.servicetrack.dao.ServiceRequestDao;
import com.servicetrack.dao.VehicleDao;
import com.servicetrack.dao.FeedbackDao;
import com.servicetrack.dao.PackageDao;
import com.servicetrack.dao.ReminderDao;
import com.servicetrack.model.ServiceRequest;
import com.servicetrack.model.Feedback;
import com.servicetrack.model.Reminder;
import com.servicetrack.model.ServicePackage;
import com.servicetrack.model.Vehicle;

public class ServiceRequestService {
    
    private ServiceRequestDao serviceRequestDao;
    private VehicleDao vehicleDao;
    private PackageDao packageDao;
    private FeedbackDao feedbackDao;
    private ReminderDao reminderDao;
    
    public ServiceRequestService() {
        this.serviceRequestDao = new ServiceRequestDao();
        this.vehicleDao = new VehicleDao();
        this.packageDao = new PackageDao();
        this.feedbackDao = new FeedbackDao();
        this.reminderDao = new ReminderDao();

    }
    
    // =====================================================
    // SERVICE REQUEST METHODS
    // =====================================================
    
    /**
     * Create a new service request
     */
    public boolean createServiceRequest(ServiceRequest request) {
        // Validate required fields
        if (request.getUserId() <= 0) {
            throw new IllegalArgumentException("User ID is required");
        }
        if (request.getVehicleId() <= 0) {
            throw new IllegalArgumentException("Vehicle ID is required");
        }
        if (request.getServiceType() == null || request.getServiceType().trim().isEmpty()) {
            throw new IllegalArgumentException("Service type is required");
        }
        if (request.getPreferredDate() == null) {
            throw new IllegalArgumentException("Preferred date is required");
        }
        
        return serviceRequestDao.createServiceRequest(request);
    }
    
 // Add this method to ServiceRequestService.java

    public List<ServiceRequest> getServiceRequestsByUserIdAndStatus(int userId, String status) {
        return serviceRequestDao.getServiceRequestsByUserAndStatus(userId, status);
    }
    
    /**
     * Get all service requests (Admin only)
     */
    public List<ServiceRequest> getAllServiceRequests() {
        return serviceRequestDao.getAllServiceRequests();
    }
    
    /**
     * Get service requests by user ID (Customer's own history)
     */
    public List<ServiceRequest> getServiceRequestsByUserId(int userId) {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        return serviceRequestDao.getServiceRequestsByUserId(userId);
    }
    
    /**
     * Get service request by ID
     */
    public ServiceRequest getServiceRequestById(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("Invalid service request ID");
        }
        return serviceRequestDao.getServiceRequestById(id);
    }
    
    /**
     * Update service request status
     */
    public boolean updateServiceStatus(int requestId, String status) {
        if (requestId <= 0) {
            throw new IllegalArgumentException("Invalid service request ID");
        }
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status is required");
        }
        
        // Validate status value
        String[] validStatuses = {"pending", "approved", "in_progress", "completed", "cancelled"};
        boolean isValid = false;
        for (String s : validStatuses) {
            if (s.equals(status)) {
                isValid = true;
                break;
            }
        }
        if (!isValid) {
            throw new IllegalArgumentException("Invalid status value");
        }
        
        return serviceRequestDao.updateServiceStatus(requestId, status);
    }
    
    /**
     * Update full service request
     */
    public boolean updateServiceRequest(ServiceRequest request) {
        if (request.getId() <= 0) {
            throw new IllegalArgumentException("Invalid service request ID");
        }
        return serviceRequestDao.updateServiceRequest(request);
    }
    
    /**
     * Delete service request (Admin only)
     */
    public boolean deleteServiceRequest(int requestId) {
        if (requestId <= 0) {
            throw new IllegalArgumentException("Invalid service request ID");
        }
        return serviceRequestDao.deleteServiceRequest(requestId);
    }
    
    // =====================================================
    // PAYMENT METHODS
    // =====================================================
    
    /**
     * Update payment information for a service request
     */
    public boolean updatePaymentInfo(int requestId, String paymentMethod, String transactionId, double amount) {
        if (requestId <= 0) {
            throw new IllegalArgumentException("Invalid service request ID");
        }
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            throw new IllegalArgumentException("Payment method is required");
        }
        if (amount <= 0) {
            throw new IllegalArgumentException("Amount must be greater than 0");
        }
        
        return serviceRequestDao.updatePaymentInfo(requestId, paymentMethod, transactionId, amount);
    }
    
    /**
     * Get total earnings from all paid services
     */
    public double getTotalEarnings() {
        return serviceRequestDao.getTotalEarnings();
    }
    
    /**
     * Get total earnings for current month
     */
    public double getMonthlyEarnings() {
        return serviceRequestDao.getMonthlyEarnings();
    }
    
    /**
     * Get monthly earnings for chart (last 6 months)
     */
    public List<Object[]> getMonthlyEarningsChart() {
        return serviceRequestDao.getMonthlyEarningsChart();
    }
    
    // =====================================================
    // COUNT METHODS - FOR DASHBOARD
    // =====================================================
    
    /**
     * Get total count of all service requests
     */
    public int getTotalServicesCount() {
        return serviceRequestDao.getTotalCount();
    }
    
    /**
     * Get count of pending services
     */
    public int getPendingServicesCount() {
        return serviceRequestDao.getCountByStatus("pending");
    }
    
    /**
     * Get count of approved services
     */
    public int getApprovedServicesCount() {
        return serviceRequestDao.getCountByStatus("approved");
    }
    
    /**
     * Get count of in-progress services
     */
    public int getActiveServicesCount() {
        return serviceRequestDao.getCountByStatus("in_progress");
    }
    
    /**
     * Get count of completed services
     */
    public int getCompletedServicesCount() {
        return serviceRequestDao.getCountByStatus("completed");
    }
    
    /**
     * Get count of cancelled services
     */
    public int getCancelledServicesCount() {
        return serviceRequestDao.getCountByStatus("cancelled");
    }
    
    /**
     * Get count by status for a specific user
     */
    public int getCountByUserAndStatus(int userId, String status) {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        return serviceRequestDao.getCountByUserAndStatus(userId, status);
    }
    
    /**
     * Get total count for a specific user
     */
    public int getTotalCountByUser(int userId) {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        return serviceRequestDao.getTotalCountByUser(userId);
    }
    
    // =====================================================
    // USER DASHBOARD METHODS
    // =====================================================
    
    /**
     * Get active services count for a specific user (in_progress)
     */
    public int getActiveServicesCountByUser(int userId) {
        return getCountByUserAndStatus(userId, "in_progress");
    }
    
    /**
     * Get completed services count for a specific user
     */
    public int getCompletedServicesCountByUser(int userId) {
        return getCountByUserAndStatus(userId, "completed");
    }
    
    /**
     * Get pending services count for a specific user
     */
    public int getPendingServicesCountByUser(int userId) {
        return getCountByUserAndStatus(userId, "pending");
    }
    
    /**
     * Get cancelled services count for a specific user
     */
    public int getCancelledServicesCountByUser(int userId) {
        return getCountByUserAndStatus(userId, "cancelled");
    }
    

    public List<ServiceRequest> getCompletedServicesByUser(int userId) {
        return serviceRequestDao.getServiceRequestsByUserAndStatus(userId, "completed");
    }

    public void submitFeedback(int serviceId, int userId, int rating, String comment) {
        Feedback feedback = new Feedback();
        feedback.setServiceRequestId(serviceId);
        feedback.setUserId(userId);
        feedback.setRating(rating);
        feedback.setComment(comment);
        feedbackDao.submitFeedback(feedback);
    }

    public List<Reminder> getRemindersByUserId(int userId) {
        return reminderDao.getRemindersByUserId(userId);
    }

    public void dismissReminder(int reminderId) {
        reminderDao.markAsSent(reminderId);
    }

    public int getTotalServicesCountByUser(int userId) {
        return serviceRequestDao.getTotalCountByUser(userId);
    }
    // =====================================================
    // VEHICLE METHODS (for service booking)
    // =====================================================
    
    /**
     * Get all vehicles for a user
     */
    public List<Vehicle> getUserVehicles(int userId) {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        return vehicleDao.getVehiclesByUserId(userId);
    }
    
    /**
     * Add a new vehicle
     */
    public boolean addVehicle(Vehicle vehicle) {
        if (vehicle.getUserId() <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        if (vehicle.getVehicleNumber() == null || vehicle.getVehicleNumber().trim().isEmpty()) {
            throw new IllegalArgumentException("Vehicle number is required");
        }
        if (vehicle.getBrand() == null || vehicle.getBrand().trim().isEmpty()) {
            throw new IllegalArgumentException("Brand is required");
        }
        if (vehicle.getModel() == null || vehicle.getModel().trim().isEmpty()) {
            throw new IllegalArgumentException("Model is required");
        }
        
        // Check if vehicle number already exists for this user
        if (vehicleDao.vehicleNumberExists(vehicle.getUserId(), vehicle.getVehicleNumber())) {
            throw new IllegalArgumentException("Vehicle number already exists for this user");
        }
        
        return vehicleDao.createVehicle(vehicle);
    }
    
    /**
     * Update vehicle information
     */
    public boolean updateVehicle(Vehicle vehicle) {
        return vehicleDao.updateVehicle(vehicle);
    }
    
    /**
     * Delete vehicle
     */
    public boolean deleteVehicle(int vehicleId) {
        // Check if vehicle has any service requests
        List<ServiceRequest> services = serviceRequestDao.getServiceRequestsByVehicleId(vehicleId);
        if (services != null && !services.isEmpty()) {
            throw new IllegalArgumentException("Cannot delete vehicle with existing service requests");
        }
        return vehicleDao.deleteVehicle(vehicleId);
    }
    
    /**
     * Get vehicle by ID
     */
    public Vehicle getVehicleById(int vehicleId) {
        return vehicleDao.getVehicleById(vehicleId);
    }
    
    // =====================================================
    // SERVICE PACKAGE METHODS
    // =====================================================
    
    /**
     * Get all available service packages
     */
    public List<ServicePackage> getAllPackages() {
        return packageDao.getAllPackages();
    }
    
    /**
     * Get package by ID
     */
    public ServicePackage getPackageById(int id) {
        return packageDao.getPackageById(id);
    }
    
    /**
     * Add new service package (Admin only)
     */
    public boolean addPackage(ServicePackage pkg) {
        if (pkg.getPackageName() == null || pkg.getPackageName().trim().isEmpty()) {
            throw new IllegalArgumentException("Package name is required");
        }
        if (pkg.getPrice() <= 0) {
            throw new IllegalArgumentException("Price must be greater than 0");
        }
        return packageDao.createPackage(pkg);
    }
    
    /**
     * Update service package (Admin only)
     */
    public boolean updatePackage(ServicePackage pkg) {
        return packageDao.updatePackage(pkg);
    }
    
    /**
     * Delete service package (Admin only)
     */
    public boolean deletePackage(int id) {
        return packageDao.deletePackage(id);
    }
    
    // =====================================================
    // STATISTICS METHODS (for reports)
    // =====================================================
    
    /**
     * Get service statistics by status
     */
    public Map<String, Integer> getStatusStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("pending", getPendingServicesCount());
        stats.put("approved", getApprovedServicesCount());
        stats.put("in_progress", getActiveServicesCount());
        stats.put("completed", getCompletedServicesCount());
        stats.put("cancelled", getCancelledServicesCount());
        return stats;
    }
    
    /**
     * Get monthly service statistics
     */
    public Map<String, Integer> getMonthlyStats() {
        Map<String, Integer> monthlyStats = new HashMap<>();
        String[] months = {"January", "February", "March", "April", "May", "June", 
                           "July", "August", "September", "October", "November", "December"};
        
        // Initialize with zeros
        for (String month : months) {
            monthlyStats.put(month, 0);
        }
        
        // Get actual data
        List<Object[]> stats = serviceRequestDao.getMonthlyServiceCount();
        for (Object[] stat : stats) {
            monthlyStats.put((String) stat[0], ((Number) stat[1]).intValue());
        }
        
        return monthlyStats;
    }
    

    public double getAverageRating() {
        return feedbackDao.getAverageRating();
    }
    
    /**
     * Get most popular service types
     */
    public List<Object[]> getPopularServices() {
        return serviceRequestDao.getPopularServices();
    }
    
    /**
     * Get recent service requests (for dashboard)
     */
    public List<ServiceRequest> getRecentServiceRequests(int limit) {
        return serviceRequestDao.getRecentServiceRequests(limit);
    }
    
    /**
     * Get revenue by month for chart
     */
    public double[] getMonthlyRevenueArray() {
        List<Object[]> earnings = serviceRequestDao.getMonthlyEarningsChart();
        double[] revenues = new double[6];
        
        // Default to zeros
        for (int i = 0; i < 6; i++) {
            revenues[i] = 0;
        }
        
        // Fill with actual data
        for (Object[] e : earnings) {
            int monthIndex = ((Number) e[0]).intValue() - 1;
            if (monthIndex >= 0 && monthIndex < 6) {
                revenues[monthIndex] = ((Number) e[1]).doubleValue();
            }
        }
        
        return revenues;
    }
    
    // =====================================================
    // VALIDATION METHODS
    // =====================================================
    
    /**
     * Validate service request data
     */
    public boolean isValidServiceRequest(ServiceRequest request) {
        try {
            if (request.getUserId() <= 0) return false;
            if (request.getVehicleId() <= 0) return false;
            if (request.getServiceType() == null || request.getServiceType().trim().isEmpty()) return false;
            if (request.getPreferredDate() == null) return false;
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Calculate estimated cost based on service type
     */
    public double calculateEstimatedCost(String serviceType) {
        switch(serviceType.toLowerCase()) {
            case "oil change":
                return 2500;
            case "engine repair":
                return 15000;
            case "brake service":
                return 3500;
            case "tire rotation":
                return 1500;
            case "battery replacement":
                return 8000;
            case "ac service":
                return 4000;
            case "full service":
                return 12000;
            default:
                return 5000;
        }
    }
    
    /**
     * Get estimated hours for service type
     */
    public double getEstimatedHours(String serviceType) {
        switch(serviceType.toLowerCase()) {
            case "oil change":
                return 1.0;
            case "engine repair":
                return 6.0;
            case "brake service":
                return 2.0;
            case "tire rotation":
                return 1.0;
            case "battery replacement":
                return 0.5;
            case "ac service":
                return 2.0;
            case "full service":
                return 4.0;
            default:
                return 2.0;
        }
    }
}