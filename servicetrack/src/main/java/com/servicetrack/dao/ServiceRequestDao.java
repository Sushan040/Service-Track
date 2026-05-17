package com.servicetrack.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servicetrack.config.DBConnection;
import com.servicetrack.model.ServiceRequest;

public class ServiceRequestDao {

	// =====================================================
	// CREATE METHODS
	// =====================================================

	/**
	 * Create a new service request
	 */
	public boolean createServiceRequest(ServiceRequest request) {
		String sql = "INSERT INTO service_requests (user_id, vehicle_id, service_type, description, preferred_date, total_amount, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setInt(1, request.getUserId());
			pstmt.setInt(2, request.getVehicleId());
			pstmt.setString(3, request.getServiceType());
			pstmt.setString(4, request.getDescription());
			pstmt.setDate(5, request.getPreferredDate());
			pstmt.setDouble(6, request.getTotalAmount());
			pstmt.setString(7, request.getPaymentStatus() != null ? request.getPaymentStatus() : "unpaid");

			int affected = pstmt.executeUpdate();
			if (affected > 0) {
				ResultSet rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					request.setId(rs.getInt(1));
				}
				return true;
			}
			return false;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// =====================================================
	// READ METHODS
	// =====================================================

	/**
	 * Get all service requests (with joins for customer and vehicle info)
	 */

	/**
	 * Get service requests by user ID (customer's own history)
	 */
	public List<ServiceRequest> getServiceRequestsByUserId(int userId) {
	    List<ServiceRequest> requests = new ArrayList<>();
	    String sql = "SELECT sr.*, v.model as vehicle_model, v.vehicle_number " +
	                 "FROM service_requests sr " +
	                 "JOIN vehicles v ON sr.vehicle_id = v.id " +
	                 "WHERE sr.user_id = ? " +
	                 "ORDER BY sr.created_at DESC";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, userId);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            ServiceRequest request = new ServiceRequest();
	            request.setId(rs.getInt("id"));
	            request.setUserId(rs.getInt("user_id"));
	            request.setVehicleId(rs.getInt("vehicle_id"));
	            request.setServiceType(rs.getString("service_type"));
	            request.setDescription(rs.getString("description"));
	            request.setPreferredDate(rs.getDate("preferred_date"));
	            request.setStatus(rs.getString("status"));
	            request.setTotalAmount(rs.getDouble("total_amount"));
	            request.setPaymentStatus(rs.getString("payment_status"));
	            request.setCreatedAt(rs.getTimestamp("created_at"));
	            request.setVehicleModel(rs.getString("vehicle_model"));
	            request.setVehicleNumber(rs.getString("vehicle_number"));
	            requests.add(request);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return requests;
	}

	/**
	 * Get service request by ID
	 */
	public ServiceRequest getServiceRequestById(int id) {
		String sql = "SELECT sr.*, u.full_name as customer_name, v.model as vehicle_model, v.vehicle_number "
				+ "FROM service_requests sr " + "JOIN users u ON sr.user_id = u.id "
				+ "JOIN vehicles v ON sr.vehicle_id = v.id " + "WHERE sr.id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				ServiceRequest request = extractServiceRequest(rs);
				request.setCustomerName(rs.getString("customer_name"));
				request.setVehicleModel(rs.getString("vehicle_model"));
				request.setVehicleNumber(rs.getString("vehicle_number"));
				return request;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Get service requests by vehicle ID
	 */
	public List<ServiceRequest> getServiceRequestsByVehicleId(int vehicleId) {
		List<ServiceRequest> requests = new ArrayList<>();
		String sql = "SELECT sr.*, u.full_name as customer_name, v.model as vehicle_model, v.vehicle_number "
				+ "FROM service_requests sr " + "JOIN users u ON sr.user_id = u.id "
				+ "JOIN vehicles v ON sr.vehicle_id = v.id " + "WHERE sr.vehicle_id = ? "
				+ "ORDER BY sr.created_at DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, vehicleId);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				ServiceRequest request = extractServiceRequest(rs);
				request.setCustomerName(rs.getString("customer_name"));
				request.setVehicleModel(rs.getString("vehicle_model"));
				request.setVehicleNumber(rs.getString("vehicle_number"));
				requests.add(request);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return requests;
	}

	/**
	 * Get service requests by status
	 */
	public List<ServiceRequest> getServiceRequestsByStatus(String status) {
		List<ServiceRequest> requests = new ArrayList<>();
		String sql = "SELECT sr.*, u.full_name as customer_name, v.model as vehicle_model, v.vehicle_number "
				+ "FROM service_requests sr " + "JOIN users u ON sr.user_id = u.id "
				+ "JOIN vehicles v ON sr.vehicle_id = v.id " + "WHERE sr.status = ? "
				+ "ORDER BY sr.preferred_date ASC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, status);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				ServiceRequest request = extractServiceRequest(rs);
				request.setCustomerName(rs.getString("customer_name"));
				request.setVehicleModel(rs.getString("vehicle_model"));
				request.setVehicleNumber(rs.getString("vehicle_number"));
				requests.add(request);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return requests;
	}

	// =====================================================
	// UPDATE METHODS
	// =====================================================

	/**
	 * Update service request status
	 */
	public boolean updateServiceStatus(int requestId, String status) {
		String sql = "UPDATE service_requests SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, status);
			pstmt.setInt(2, requestId);

			// If status is 'in_progress', set started_at
			if ("in_progress".equals(status)) {
				String startSql = "UPDATE service_requests SET started_at = CURRENT_TIMESTAMP WHERE id = ?";
				try (PreparedStatement pstmt2 = conn.prepareStatement(startSql)) {
					pstmt2.setInt(1, requestId);
					pstmt2.executeUpdate();
				}
			}

			// If status is 'completed', set completed_at
			if ("completed".equals(status)) {
				String completeSql = "UPDATE service_requests SET completed_at = CURRENT_TIMESTAMP WHERE id = ?";
				try (PreparedStatement pstmt2 = conn.prepareStatement(completeSql)) {
					pstmt2.setInt(1, requestId);
					pstmt2.executeUpdate();
				}
			}

			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Update full service request
	 */
	public boolean updateServiceRequest(ServiceRequest request) {
		String sql = "UPDATE service_requests SET service_type = ?, description = ?, preferred_date = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, request.getServiceType());
			pstmt.setString(2, request.getDescription());
			pstmt.setDate(3, request.getPreferredDate());
			pstmt.setInt(4, request.getId());

			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Update payment information for a service request
	 */
	public boolean updatePaymentInfo(int requestId, String paymentMethod, String transactionId, double amount) {
		String sql = "UPDATE service_requests SET payment_method = ?, transaction_id = ?, total_amount = ?, payment_status = 'paid' WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, paymentMethod);
			pstmt.setString(2, transactionId);
			pstmt.setDouble(3, amount);
			pstmt.setInt(4, requestId);

			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// =====================================================
	// DELETE METHODS
	// =====================================================

	/**
	 * Delete service request
	 */
	public boolean deleteServiceRequest(int requestId) {
		String sql = "DELETE FROM service_requests WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, requestId);
			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Delete all service requests for a vehicle
	 */
	public boolean deleteByVehicleId(int vehicleId) {
		String sql = "DELETE FROM service_requests WHERE vehicle_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, vehicleId);
			pstmt.executeUpdate();
			return true;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Delete all service requests for a user
	 */
	public boolean deleteByUserId(int userId) {
		String sql = "DELETE FROM service_requests WHERE user_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			pstmt.executeUpdate();
			return true;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// =====================================================
	// COUNT METHODS
	// =====================================================

	/**
	 * Get count by status
	 */
	public int getCountByStatus(String status) {
		String sql = "SELECT COUNT(*) FROM service_requests WHERE status = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, status);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	/**
	 * Get count by user ID and status
	 */
	public int getCountByUserAndStatus(int userId, String status) {
		String sql = "SELECT COUNT(*) FROM service_requests WHERE user_id = ? AND status = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			pstmt.setString(2, status);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	/**
	 * Get total count of all service requests
	 */
	public int getTotalCount() {
		String sql = "SELECT COUNT(*) FROM service_requests";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	/**
	 * Get total count for a specific user
	 */
	// Add these methods to ServiceRequestDao.java

	public int getTotalCountByUser(int userId) {
	    String sql = "SELECT COUNT(*) FROM service_requests WHERE user_id = ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, userId);
	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return 0;
	}

	// =====================================================
	// PAYMENT/EARNINGS METHODS
	// =====================================================

	/**
	 * Get total earnings from all paid services
	 */
	public double getTotalEarnings() {
		String sql = "SELECT SUM(total_amount) FROM service_requests WHERE payment_status = 'paid'";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			if (rs.next()) {
				return rs.getDouble(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	/**
	 * Get total earnings for current month
	 */
	public double getMonthlyEarnings() {
		String sql = "SELECT SUM(total_amount) FROM service_requests WHERE payment_status = 'paid' AND MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			if (rs.next()) {
				return rs.getDouble(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	/**
	 * Get monthly earnings for chart (last 6 months)
	 */
	public List<Object[]> getMonthlyEarningsChart() {
		List<Object[]> earnings = new ArrayList<>();
		String sql = "SELECT MONTH(created_at) as month, SUM(total_amount) as total " + "FROM service_requests "
				+ "WHERE payment_status = 'paid' " + "AND created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) "
				+ "GROUP BY MONTH(created_at) " + "ORDER BY month ASC";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				Object[] row = new Object[2];
				row[0] = rs.getInt("month");
				row[1] = rs.getDouble("total");
				earnings.add(row);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return earnings;
	}

	// =====================================================
	// STATISTICS METHODS
	// =====================================================

	/**
	 * Get monthly service count for chart
	 */
	public List<Object[]> getMonthlyServiceCount() {
		List<Object[]> stats = new ArrayList<>();
		String sql = "SELECT MONTHNAME(created_at) as month, COUNT(*) as count " + "FROM service_requests "
				+ "WHERE YEAR(created_at) = YEAR(CURDATE()) " + "GROUP BY MONTH(created_at) "
				+ "ORDER BY MONTH(created_at)";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				Object[] stat = new Object[2];
				stat[0] = rs.getString("month");
				stat[1] = rs.getInt("count");
				stats.add(stat);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return stats;
	}

	/**
	 * Get most popular service types
	 */
	public List<Object[]> getPopularServices() {
		List<Object[]> stats = new ArrayList<>();
		String sql = "SELECT service_type, COUNT(*) as count " + "FROM service_requests " + "GROUP BY service_type "
				+ "ORDER BY count DESC LIMIT 5";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				Object[] stat = new Object[2];
				stat[0] = rs.getString("service_type");
				stat[1] = rs.getInt("count");
				stats.add(stat);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return stats;
	}

	/**
	 * Get recent service requests (for dashboard widget)
	 */
	public List<ServiceRequest> getRecentServiceRequests(int limit) {
        List<ServiceRequest> requests = new ArrayList<>();
        String sql = "SELECT sr.*, u.full_name as customer_name, v.model as vehicle_model, v.vehicle_number " +
                     "FROM service_requests sr " +
                     "INNER JOIN users u ON sr.user_id = u.id " +
                     "INNER JOIN vehicles v ON sr.vehicle_id = v.id " +
                     "ORDER BY sr.created_at DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ServiceRequest request = new ServiceRequest();
                request.setId(rs.getInt("id"));
                request.setUserId(rs.getInt("user_id"));
                request.setVehicleId(rs.getInt("vehicle_id"));
                request.setServiceType(rs.getString("service_type"));
                request.setDescription(rs.getString("description"));
                request.setPreferredDate(rs.getDate("preferred_date"));
                request.setStatus(rs.getString("status"));
                request.setTotalAmount(rs.getDouble("total_amount"));
                request.setPaymentStatus(rs.getString("payment_status"));
                request.setPaymentMethod(rs.getString("payment_method"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                request.setCustomerName(rs.getString("customer_name"));
                request.setVehicleModel(rs.getString("vehicle_model"));
                request.setVehicleNumber(rs.getString("vehicle_number"));
                
                requests.add(request);
            }
            
            System.out.println("getRecentServiceRequests found: " + requests.size() + " records");
            
        } catch (SQLException e) {
            System.err.println("Error in getRecentServiceRequests: " + e.getMessage());
            e.printStackTrace();
        }
        return requests;
    }
	
	
    public List<ServiceRequest> getAllServiceRequests() {
        List<ServiceRequest> requests = new ArrayList<>();
        String sql = "SELECT sr.*, u.full_name as customer_name, v.model as vehicle_model, v.vehicle_number " +
                     "FROM service_requests sr " +
                     "INNER JOIN users u ON sr.user_id = u.id " +
                     "INNER JOIN vehicles v ON sr.vehicle_id = v.id " +
                     "ORDER BY sr.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                ServiceRequest request = new ServiceRequest();
                request.setId(rs.getInt("id"));
                request.setUserId(rs.getInt("user_id"));
                request.setVehicleId(rs.getInt("vehicle_id"));
                request.setServiceType(rs.getString("service_type"));
                request.setDescription(rs.getString("description"));
                request.setPreferredDate(rs.getDate("preferred_date"));
                request.setStatus(rs.getString("status"));
                request.setTotalAmount(rs.getDouble("total_amount"));
                request.setPaymentStatus(rs.getString("payment_status"));
                request.setPaymentMethod(rs.getString("payment_method"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                request.setCustomerName(rs.getString("customer_name"));
                request.setVehicleModel(rs.getString("vehicle_model"));
                request.setVehicleNumber(rs.getString("vehicle_number"));
                requests.add(request);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

	// =====================================================
	// HELPER METHODS
	// =====================================================

	/**
	 * Extract ServiceRequest object from ResultSet
	 */
	private ServiceRequest extractServiceRequest(ResultSet rs) throws SQLException {
		ServiceRequest request = new ServiceRequest();
		request.setId(rs.getInt("id"));
		request.setUserId(rs.getInt("user_id"));
		request.setVehicleId(rs.getInt("vehicle_id"));

		int packageId = rs.getInt("package_id");
		if (!rs.wasNull()) {
			request.setPackageId(packageId);
		}

		request.setServiceType(rs.getString("service_type"));
		request.setDescription(rs.getString("description"));
		request.setPreferredDate(rs.getDate("preferred_date"));
		request.setPreferredTime(rs.getString("preferred_time"));
		request.setStatus(rs.getString("status"));

		int mechanicId = rs.getInt("assigned_mechanic_id");
		if (!rs.wasNull()) {
			request.setAssignedMechanicId(mechanicId);
		}

		request.setTotalAmount(rs.getDouble("total_amount"));
		request.setPaymentStatus(rs.getString("payment_status"));
		request.setPaymentMethod(rs.getString("payment_method"));
		request.setTransactionId(rs.getString("transaction_id"));
		request.setCouponCode(rs.getString("coupon_code"));
		request.setDiscountApplied(rs.getDouble("discount_applied"));
		request.setReminderSent(rs.getBoolean("reminder_sent"));
		request.setCreatedAt(rs.getTimestamp("created_at"));
		request.setUpdatedAt(rs.getTimestamp("updated_at"));
		request.setStartedAt(rs.getTimestamp("started_at"));
		request.setCompletedAt(rs.getTimestamp("completed_at"));
		request.setCancelledReason(rs.getString("cancelled_reason"));

		return request;
	}


	public List<ServiceRequest> getServiceRequestsByUserAndStatus(int userId, String status) {
	    List<ServiceRequest> requests = new ArrayList<>();
	    String sql = "SELECT sr.*, v.model as vehicle_model, v.vehicle_number " +
	                 "FROM service_requests sr " +
	                 "JOIN vehicles v ON sr.vehicle_id = v.id " +
	                 "WHERE sr.user_id = ? AND sr.status = ? " +
	                 "ORDER BY sr.created_at DESC";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, userId);
	        pstmt.setString(2, status);
	        ResultSet rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            ServiceRequest request = new ServiceRequest();
	            request.setId(rs.getInt("id"));
	            request.setUserId(rs.getInt("user_id"));
	            request.setVehicleId(rs.getInt("vehicle_id"));
	            request.setServiceType(rs.getString("service_type"));
	            request.setDescription(rs.getString("description"));
	            request.setPreferredDate(rs.getDate("preferred_date"));
	            request.setStatus(rs.getString("status"));
	            request.setTotalAmount(rs.getDouble("total_amount"));
	            request.setPaymentStatus(rs.getString("payment_status"));
	            request.setCreatedAt(rs.getTimestamp("created_at"));
	            request.setVehicleModel(rs.getString("vehicle_model"));
	            request.setVehicleNumber(rs.getString("vehicle_number"));
	            requests.add(request);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return requests;
	}
}