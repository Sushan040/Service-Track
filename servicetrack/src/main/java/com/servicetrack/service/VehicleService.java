package com.servicetrack.service;

import java.util.List;
import com.servicetrack.dao.VehicleDao;
import com.servicetrack.model.Vehicle;

public class VehicleService {
    
    private VehicleDao vehicleDao;
    
    public VehicleService() {
        this.vehicleDao = new VehicleDao();
    }
    
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
        
        if (vehicleDao.vehicleNumberExists(vehicle.getUserId(), vehicle.getVehicleNumber())) {
            throw new IllegalArgumentException("Vehicle number already exists");
        }
        
        return vehicleDao.createVehicle(vehicle);
    }
    
    public List<Vehicle> getVehiclesByUserId(int userId) {
        return vehicleDao.getVehiclesByUserId(userId);
    }
    
    public Vehicle getVehicleById(int vehicleId) {
        return vehicleDao.getVehicleById(vehicleId);
    }
    
    public boolean updateVehicle(Vehicle vehicle) {
        return vehicleDao.updateVehicle(vehicle);
    }
    
    public boolean deleteVehicle(int vehicleId) {
        return vehicleDao.deleteVehicle(vehicleId);
    }
    
    public boolean vehicleNumberExists(int userId, String number) {
        return vehicleDao.vehicleNumberExists(userId, number);
    }
}