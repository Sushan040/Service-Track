// Form validation utilities
function validateRegistration() {
    var fullName = document.getElementById("fullName");
    var email = document.getElementById("email");
    var password = document.getElementById("password");
    var confirmPassword = document.getElementById("confirmPassword");
    var terms = document.getElementById("terms");
    
    // Validate full name
    if (fullName.value.trim().length < 2) {
        showError(fullName, "Please enter your full name");
        return false;
    }
    
    // Validate email
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email.value)) {
        showError(email, "Please enter a valid email address");
        return false;
    }
    
    // Validate password
    if (password.value.length < 6) {
        showError(password, "Password must be at least 6 characters long");
        return false;
    }
    
    // Check password match
    if (password.value !== confirmPassword.value) {
        showError(confirmPassword, "Passwords do not match");
        return false;
    }
    
    // Check terms agreement
    if (!terms.checked) {
        alert("Please agree to the Terms of Service and Privacy Policy");
        return false;
    }
    
    return true;
}

function validateLogin() {
    var email = document.getElementById("email");
    var password = document.getElementById("password");
    
    if (!email.value) {
        showError(email, "Please enter your email");
        return false;
    }
    
    if (!password.value) {
        showError(password, "Please enter your password");
        return false;
    }
    
    return true;
}

function showError(field, message) {
    field.style.borderColor = "#f44336";
    
    // Remove existing error message
    var existingError = field.parentElement.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
    
    // Add error message
    var error = document.createElement('div');
    error.className = 'field-error';
    error.style.color = '#f44336';
    error.style.fontSize = '11px';
    error.style.marginTop = '5px';
    error.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + message;
    field.parentElement.appendChild(error);
    
    // Remove error on input
    field.addEventListener('input', function() {
        field.style.borderColor = '#e0e0e0';
        var err = field.parentElement.querySelector('.field-error');
        if (err) err.remove();
    });
}

// Password strength checker
function checkPasswordStrength(password) {
    let strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.match(/[a-z]+/)) strength++;
    if (password.match(/[A-Z]+/)) strength++;
    if (password.match(/[0-9]+/)) strength++;
    if (password.match(/[$@#&!]+/)) strength++;
    
    return strength;
}

// Format phone number as user types
function formatPhoneNumber(input) {
    let value = input.value.replace(/\D/g, '');
    if (value.length >= 10) {
        value = value.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
    } else if (value.length >= 6) {
        value = value.replace(/(\d{3})(\d{3})/, '($1) $2');
    } else if (value.length >= 3) {
        value = value.replace(/(\d{3})/, '($1)');
    }
    input.value = value;
}

function editCoupon(id) {
    // Fetch coupon data via AJAX or redirect to edit page
    window.location.href = '${pageContext.request.contextPath}/admin/coupons/edit?id=' + id;
}

// Add loading animation to buttons
document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', function() {
        const submitBtn = this.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
        }
    });
});