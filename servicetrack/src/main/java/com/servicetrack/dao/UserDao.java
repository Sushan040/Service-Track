package com.servicetrack.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.servicetrack.config.DBConnection;
import com.servicetrack.model.User;
import com.servicetrack.util.PasswordUtil;

public class UserDao {

	// =====================================================
	// CREATE / REGISTER METHODS
	// =====================================================

	public boolean registerUser(User user) {
		String sql = "INSERT INTO users (full_name, email, password, phone, address, role) VALUES (?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setString(1, user.getFullName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
			pstmt.setString(4, user.getPhone());
			pstmt.setString(5, user.getAddress());
			pstmt.setString(6, user.getRole());

			int affected = pstmt.executeUpdate();
			if (affected > 0) {
				ResultSet rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					user.setId(rs.getInt(1));
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
	// LOGIN METHOD
	// =====================================================

	public User loginUser(String email, String password) {
		String sql = "SELECT * FROM users WHERE email = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, email);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				String hashedPassword = rs.getString("password");

				if (PasswordUtil.verifyPassword(password, hashedPassword) || password.equals(hashedPassword)) {
					return extractUserFromResultSet(rs);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	
	// =====================================================
	// READ / GET METHODS
	// =====================================================

	public User getUserById(int id) {
		String sql = "SELECT * FROM users WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				return extractUserFromResultSet(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public User getUserByEmail(String email) {
	    String sql = "SELECT * FROM users WHERE email = ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setString(1, email);
	        ResultSet rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            User user = new User();
	            user.setId(rs.getInt("id"));
	            user.setFullName(rs.getString("full_name"));
	            user.setEmail(rs.getString("email"));
	            user.setPassword(rs.getString("password"));
	            user.setPhone(rs.getString("phone"));
	            user.setAddress(rs.getString("address"));
	            user.setRole(rs.getString("role"));
	            user.setFailedLoginAttempts(rs.getInt("failed_login_attempts"));
	            user.setAccountLocked(rs.getBoolean("account_locked"));
	            user.setLockoutTime(rs.getTimestamp("lockout_time"));
	            user.setCreatedAt(rs.getTimestamp("created_at"));
	            user.setUpdatedAt(rs.getTimestamp("updated_at"));
	            return user;
	        }
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	public List<User> getAllUsers() {
		List<User> users = new ArrayList<>();
		String sql = "SELECT * FROM users ORDER BY created_at DESC";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				users.add(extractUserFromResultSet(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return users;
	}

	public List<User> getUsersByRole(String role) {
		List<User> users = new ArrayList<>();
		String sql = "SELECT * FROM users WHERE role = ? ORDER BY full_name";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, role);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				users.add(extractUserFromResultSet(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return users;
	}

	public List<User> searchUsers(String keyword) {
		List<User> users = new ArrayList<>();
		String sql = "SELECT * FROM users WHERE LOWER(full_name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?) OR phone LIKE ? ORDER BY full_name";
		String searchPattern = "%" + keyword + "%";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, searchPattern);
			pstmt.setString(2, searchPattern);
			pstmt.setString(3, searchPattern);
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				users.add(extractUserFromResultSet(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return users;
	}

	public boolean emailExists(String email) {
		String sql = "SELECT id FROM users WHERE email = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, email);
			ResultSet rs = pstmt.executeQuery();
			return rs.next();

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// =====================================================
	// COUNT METHODS
	// =====================================================

	public int getTotalUsersCount() {
		String sql = "SELECT COUNT(*) FROM users";

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

	public int getCountByRole(String role) {
		String sql = "SELECT COUNT(*) FROM users WHERE role = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, role);
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
	// UPDATE METHODS
	// =====================================================

	public boolean updateUser(User user) {
		String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, address = ?, role = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, user.getFullName());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getPhone());
			pstmt.setString(4, user.getAddress());
			pstmt.setString(5, user.getRole());
			pstmt.setInt(6, user.getId());

			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean updatePassword(int userId, String hashedPassword) {
		String sql = "UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, hashedPassword);
			pstmt.setInt(2, userId);

			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean updateUserRole(int userId, String newRole) {
		String sql = "UPDATE users SET role = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, newRole);
			pstmt.setInt(2, userId);

			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean updateLoyaltyPoints(int userId, int points) {
		String sql = "UPDATE users SET loyalty_points = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, points);
			pstmt.setInt(2, userId);

			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// =====================================================
	// ACCOUNT STATUS METHODS
	// =====================================================

	public boolean isUserActive(int userId) {
		String sql = "SELECT is_active FROM users WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getBoolean("is_active");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return true;
	}

	public void updateLastLogin(int userId) {
		String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// =====================================================
	// DELETE METHODS
	// =====================================================

	public boolean deleteUser(int userId) {
		String sql = "DELETE FROM users WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteUsersByRole(String role) {
		String sql = "DELETE FROM users WHERE role = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, role);
			int affected = pstmt.executeUpdate();
			return affected >= 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// =====================================================
	// HELPER METHOD
	// =====================================================

	private User extractUserFromResultSet(ResultSet rs) throws SQLException {
		User user = new User();
		user.setId(rs.getInt("id"));
		user.setFullName(rs.getString("full_name"));
		user.setEmail(rs.getString("email"));
		user.setPassword(rs.getString("password"));
		user.setPhone(rs.getString("phone"));
		user.setAddress(rs.getString("address"));
		user.setRole(rs.getString("role"));

		user.setCreatedAt(rs.getTimestamp("created_at"));
		user.setUpdatedAt(rs.getTimestamp("updated_at"));
		return user;
	}


	public boolean incrementFailedLoginAttempts(int userId) {
		String sql = "UPDATE users SET failed_login_attempts = failed_login_attempts + 1 WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean resetFailedLoginAttempts(int userId) {
		String sql = "UPDATE users SET failed_login_attempts = 0 WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean lockAccount(int userId) {
		String sql = "UPDATE users SET account_locked = TRUE, lockout_time = CURRENT_TIMESTAMP WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			return pstmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean unlockAccount(int userId) {
	    String sql = "UPDATE users SET account_locked = FALSE, failed_login_attempts = 0, lockout_time = NULL WHERE id = ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, userId);
	        int updated = pstmt.executeUpdate();
	        System.out.println("Unlocked account for user ID: " + userId + " - Rows affected: " + updated);
	        return updated > 0;
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	public boolean isAccountLocked(int userId) {
		String sql = "SELECT account_locked, lockout_time FROM users WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, userId);
			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				boolean locked = rs.getBoolean("account_locked");
				Timestamp lockoutTime = rs.getTimestamp("lockout_time");

				if (locked && lockoutTime != null) {
					// Check if lockout has expired (15 minutes)
					long lockoutDuration = 15 * 60 * 1000;
					long currentTime = System.currentTimeMillis();
					if ((currentTime - lockoutTime.getTime()) > lockoutDuration) {
						// Auto-unlock if expired
						unlockAccount(userId);
						return false;
					}
				}
				return locked;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
    public int getFailedLoginAttempts(int userId) {
        String sql = "SELECT failed_login_attempts FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("failed_login_attempts");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
 // Add these methods to UserDao.java

    public boolean savePasswordResetToken(String email, String token, Timestamp expiresAt) {
        String sql = "INSERT INTO password_resets (email, token, expires_at) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, token);
            pstmt.setTimestamp(3, expiresAt);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isValidResetToken(String token) {
        String sql = "SELECT * FROM password_resets WHERE token = ? AND expires_at > NOW()";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, token);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getEmailByResetToken(String token) {
        String sql = "SELECT email FROM password_resets WHERE token = ? AND expires_at > NOW()";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, token);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("email");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteResetToken(String token) {
        String sql = "DELETE FROM password_resets WHERE token = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, token);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}