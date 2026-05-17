package com.servicetrack.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.servicetrack.model.ServiceRequest;
import com.servicetrack.model.User;
import com.servicetrack.model.Vehicle;
import com.servicetrack.service.ServiceRequestService;
import com.servicetrack.service.VehicleService;

@WebServlet("/service/*")
public class ServiceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceRequestService service;
    private VehicleService vehicleService;

    @Override
    public void init() {
        service = new ServiceRequestService();
        vehicleService = new VehicleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String path = request.getPathInfo();
        User user = (User) session.getAttribute("user");

        System.out.println("ServiceController GET - Path: " + path);

        if ("/admin/manage".equals(path)) {
            String role = (String) session.getAttribute("role");
            if (!"admin".equals(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            List<ServiceRequest> services = service.getAllServiceRequests();
            System.out.println("Services found: " + (services != null ? services.size() : 0));
            request.setAttribute("services", services);
            request.getRequestDispatcher("/WEB-INF/views/admin/manage-services.jsp").forward(request, response);

        } else if ("/book".equals(path)) {
            request.setAttribute("vehicles", vehicleService.getVehiclesByUserId(user.getId()));
            request.getRequestDispatcher("/WEB-INF/views/user/book-service.jsp").forward(request, response);

        } else if ("/history".equals(path)) {
            List<ServiceRequest> services = service.getServiceRequestsByUserId(user.getId());
            request.setAttribute("services", services);
            request.getRequestDispatcher("/WEB-INF/views/user/service-history.jsp").forward(request, response);

        } else if ("/delete".equals(path)) {
            String role = (String) session.getAttribute("role");
            if (!"admin".equals(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            int requestId = Integer.parseInt(request.getParameter("id"));
            service.deleteServiceRequest(requestId);
            response.sendRedirect(request.getContextPath() + "/service/admin/manage");

        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String path = request.getPathInfo();
        User user = (User) session.getAttribute("user");
        
        System.out.println("ServiceController POST - Path: " + path);

        // =====================================================
        // HANDLE STATUS UPDATE VIA POST
        // =====================================================
        if ("/status".equals(path)) {
            String role = (String) session.getAttribute("role");
            if (!"admin".equals(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            int requestId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            
            System.out.println("Updating service " + requestId + " to status: " + status);
            
            boolean updated = service.updateServiceStatus(requestId, status);
            
            if (updated) {
                session.setAttribute("success", "Service status updated to " + status);
            } else {
                session.setAttribute("error", "Failed to update status");
            }
            
            response.sendRedirect(request.getContextPath() + "/service/admin/manage");
        }
        // =====================================================
        // HANDLE DELETE VIA POST
        // =====================================================
        else if ("/delete".equals(path)) {
            String role = (String) session.getAttribute("role");
            if (!"admin".equals(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            int requestId = Integer.parseInt(request.getParameter("id"));
            service.deleteServiceRequest(requestId);
            session.setAttribute("success", "Service request deleted successfully");
            response.sendRedirect(request.getContextPath() + "/service/admin/manage");
        }
        // =====================================================
        // HANDLE BOOK SERVICE VIA POST
        // =====================================================
        else if ("/book".equals(path)) {
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            String serviceType = request.getParameter("serviceType");
            String description = request.getParameter("description");
            Date preferredDate = Date.valueOf(request.getParameter("preferredDate"));
            String paymentMethod = request.getParameter("paymentMethod");

            ServiceRequest serviceRequest = new ServiceRequest();
            serviceRequest.setUserId(user.getId());
            serviceRequest.setVehicleId(vehicleId);
            serviceRequest.setServiceType(serviceType);
            serviceRequest.setDescription(description);
            serviceRequest.setPreferredDate(preferredDate);
            serviceRequest.setPaymentMethod(paymentMethod);

            double amount = getServiceAmount(serviceType);
            serviceRequest.setTotalAmount(amount);

            if (!"cash".equals(paymentMethod)) {
                serviceRequest.setPaymentStatus("paid");
            }

            try {
                service.createServiceRequest(serviceRequest);
                request.setAttribute("success", "Service booked successfully!");
            } catch (Exception e) {
                request.setAttribute("error", "Failed to book service: " + e.getMessage());
            }

            request.setAttribute("vehicles", vehicleService.getVehiclesByUserId(user.getId()));
            request.getRequestDispatcher("/WEB-INF/views/user/book-service.jsp").forward(request, response);

        } 
        // =====================================================
        // HANDLE ADD VEHICLE VIA POST
        // =====================================================
        else if ("/add-vehicle".equals(path)) {
            String vehicleNumber = request.getParameter("vehicleNumber");
            String model = request.getParameter("model");
            String brand = request.getParameter("brand");
            int year = Integer.parseInt(request.getParameter("year"));

            Vehicle vehicle = new Vehicle();
            vehicle.setUserId(user.getId());
            vehicle.setVehicleNumber(vehicleNumber);
            vehicle.setModel(model);
            vehicle.setBrand(brand);
            vehicle.setYear(year);

            try {
                vehicleService.addVehicle(vehicle);
                request.setAttribute("success", "Vehicle added successfully!");
            } catch (Exception e) {
                request.setAttribute("error", "Failed to add vehicle: " + e.getMessage());
            }

            request.setAttribute("vehicles", vehicleService.getVehiclesByUserId(user.getId()));
            request.getRequestDispatcher("/WEB-INF/views/user/book-service.jsp").forward(request, response);
        }
        else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private double getServiceAmount(String serviceType) {
        switch (serviceType) {
            case "Oil Change": return 2500;
            case "Engine Repair": return 15000;
            case "Brake Service": return 3500;
            case "Tire Rotation": return 1500;
            case "Battery Replacement": return 8000;
            case "AC Service": return 4000;
            case "Full Service": return 12000;
            default: return 5000;
        }
    }
}