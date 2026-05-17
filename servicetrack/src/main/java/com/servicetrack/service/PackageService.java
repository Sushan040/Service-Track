package com.servicetrack.service;

import java.util.List;
import com.servicetrack.dao.PackageDao;
import com.servicetrack.model.ServicePackage;

public class PackageService {
    
    private PackageDao packageDao;
    
    public PackageService() {
        this.packageDao = new PackageDao();
    }
    
    public List<ServicePackage> getAllPackages() {
        return packageDao.getAllPackages();
    }
    
    public ServicePackage getPackageById(int id) {
        return packageDao.getPackageById(id);
    }
    
    public boolean addPackage(ServicePackage pkg) {
        if (pkg.getPackageName() == null || pkg.getPackageName().trim().isEmpty()) {
            throw new IllegalArgumentException("Package name is required");
        }
        if (pkg.getPrice() <= 0) {
            throw new IllegalArgumentException("Price must be greater than 0");
        }
        return packageDao.createPackage(pkg);
    }
    
    public boolean updatePackage(ServicePackage pkg) {
        return packageDao.updatePackage(pkg);
    }
    
    public boolean deletePackage(int id) {
        return packageDao.deletePackage(id);
    }
}