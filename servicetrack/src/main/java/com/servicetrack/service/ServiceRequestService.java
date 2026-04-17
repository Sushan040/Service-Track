package com.servicetrack.service;

import com.servicetrack.dao.ServiceRequestDao;

public class ServiceRequestService {

    private ServiceRequestDao dao = new ServiceRequestDao();

    public void createRequest(int userId, String serviceType) {
        if (serviceType != null && !serviceType.isEmpty()) {
            dao.save(userId, serviceType);
        }
    }
}