<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - ServiceTrack</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="main-wrapper">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-left">
                    <div class="brand">
                        <div class="brand-icon">
                            <i class="fas fa-car"></i>
                            <i class="fas fa-tools"></i>
                        </div>
                        <h1>ServiceTrack</h1>
                    </div>
                    <div class="stats">
                        <div class="stat">
                            <h3>500+</h3>
                            <p>Happy Customers</p>
                        </div>
                        <div class="stat">
                            <h3>1000+</h3>
                            <p>Services Done</p>
                        </div>
                        <div class="stat">
                            <h3>50+</h3>
                            <p>Expert Mechanics</p>
                        </div>
                    </div>
                </div>
                
                <div class="auth-right">
                    <div class="auth-form">
                        <h2>Create Account</h2>
                        <p class="subtitle">Register to get started</p>
                        
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle"></i>
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <form action="${pageContext.request.contextPath}/auth/register" method="post" id="registerForm">
                            <div class="form-row">
                                <div class="input-group">
                                    <label for="fullName">
                                        <i class="fas fa-user"></i>
                                        Full Name
                                    </label>
                                    <input type="text" id="fullName" name="fullName" required>
                                </div>
                                
                                <div class="input-group">
                                    <label for="phone">
                                        <i class="fas fa-phone"></i>
                                        Phone Number
                                    </label>
                                    <input type="text" id="phone" name="phone">
                                </div>
                            </div>
                            
                            <div class="input-group">
                                <label for="email">
                                    <i class="fas fa-envelope"></i>
                                    Email Address
                                </label>
                                <input type="email" id="email" name="email" required>
                            </div>
                            
                            <div class="form-row">
                                <div class="input-group">
                                    <label for="password">
                                        <i class="fas fa-lock"></i>
                                        Password
                                    </label>
                                    <input type="password" id="password" name="password" required>
                                </div>
                                
                                <div class="input-group">
                                    <label for="confirmPassword">
                                        <i class="fas fa-check-circle"></i>
                                        Confirm Password
                                    </label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                                </div>
                            </div>
                            
                            <div class="input-group">
                                <label for="address">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Address
                                </label>
                                <textarea id="address" name="address" rows="2"></textarea>
                            </div>
                            
                            <!-- Role Selection - Side by Side -->
                            <div class="input-group">
                                <label>
                                    <i class="fas fa-user-tag"></i>
                                    Register As
                                </label>
                                <div class="radio-group">
                                    <label class="radio-label">
                                        <input type="radio" name="role" value="customer" checked>
                                        <span class="radio-custom"></span>
                                        <i class="fas fa-user"></i>
                                        Customer
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="role" value="admin">
                                        <span class="radio-custom"></span>
                                        <i class="fas fa-user-shield"></i>
                                        Admin
                                    </label>
                                </div>
                            </div>
                            
                            <!-- Admin Registration Key -->
                            <div class="input-group admin-key-field" style="display: none;">
                                <label for="adminKey">
                                    <i class="fas fa-key"></i>
                                    Admin Registration Key
                                </label>
                                <input type="password" id="adminKey" name="adminKey" placeholder="Enter admin registration key">
                                <small class="help-text">
                                    <i class="fas fa-info-circle"></i>
                                    Only users with valid admin key can register as admin
                                </small>
                            </div>
                            
                            <button type="submit" class="btn-register">
                                <i class="fas fa-user-plus"></i>
                                Register Now
                            </button>
                        </form>
                        
                        <div class="auth-footer">
                            <p>Already have an account? <a href="${pageContext.request.contextPath}/auth/login">Sign In</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Show/hide admin key field based on role selection
        const roleRadios = document.querySelectorAll('input[name="role"]');
        const adminKeyField = document.querySelector('.admin-key-field');
        
        roleRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                if (this.value === 'admin') {
                    adminKeyField.style.display = 'block';
                    adminKeyField.style.animation = 'slideDown 0.3s ease-out';
                } else {
                    adminKeyField.style.display = 'none';
                }
            });
        });
        
        // Password match validation
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        
        function validatePassword() {
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity("Passwords don't match");
                confirmPassword.style.borderColor = '#E6002E';
            } else {
                confirmPassword.setCustomValidity('');
                confirmPassword.style.borderColor = '#3671C6';
            }
        }
        
        password.addEventListener('change', validatePassword);
        password.addEventListener('keyup', validatePassword);
        confirmPassword.addEventListener('keyup', validatePassword);
        
        // Form submission validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const selectedRole = document.querySelector('input[name="role"]:checked').value;
            const adminKey = document.getElementById('adminKey');
            
            if (selectedRole === 'admin' && adminKey.style.display !== 'none') {
                if (!adminKey.value.trim()) {
                    e.preventDefault();
                    alert('Admin registration key is required for admin registration');
                    adminKey.focus();
                    return false;
                }
            }
            
            if (password.value !== confirmPassword.value) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.value.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long!');
                return false;
            }
        });
    </script>
</body>
</html>