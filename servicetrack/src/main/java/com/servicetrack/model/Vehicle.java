package com.servicetrack.model;

public class Vehicle {
    private int id;
    private int userId;
    private String vehicleNumber;
    private String model;
    private String brand;
    private int year;
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getVehicleNumber() { return vehicleNumber; }
    public void setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }
    
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    
    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }
}