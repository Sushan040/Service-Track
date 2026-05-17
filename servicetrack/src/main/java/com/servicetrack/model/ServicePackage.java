package com.servicetrack.model;

public class ServicePackage {
	private int id;
	private String packageName;
	private String description;
	private String servicesIncluded;
	private double price;
	private int discountPercent;
	private boolean isActive;

	// Constructors
	public ServicePackage() {
	}

	// Getters and Setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getServicesIncluded() {
		return servicesIncluded;
	}

	public void setServicesIncluded(String servicesIncluded) {
		this.servicesIncluded = servicesIncluded;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public int getDiscountPercent() {
		return discountPercent;
	}

	public void setDiscountPercent(int discountPercent) {
		this.discountPercent = discountPercent;
	}

	public double getDiscountedPrice() {
		return price - (price * discountPercent / 100);
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean active) {
		isActive = active;
	}
}