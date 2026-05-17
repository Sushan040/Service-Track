package com.servicetrack.controller;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

	// List of valid URL prefixes (add all your valid paths here)
	private static final String[] VALID_PATHS = { "/auth/login", "/auth/register", "/auth/forgot-password",
			"/auth/reset-password", "/auth/logout", "/admin/dashboard", "/admin/users", "/admin/packages",
			"/admin/coupons", "/admin/reports", "/user/dashboard", "/user/profile", "/user/vehicles", "/user/feedback",
			"/user/reminders", "/service/book", "/service/history", "/service/admin/manage", "/assets/", "/css/",
			"/js/", "/images/", "/error-page", "/test-500" };

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		String uri = httpRequest.getRequestURI();
		String contextPath = httpRequest.getContextPath();
		String path = uri.substring(contextPath.length());

		System.out.println("AuthFilter - Path: " + path);

		// =====================================================
		// PUBLIC PAGES - No authentication required
		// =====================================================

		// Allow access to error page
		if (path.startsWith("/error-page")) {
			chain.doFilter(request, response);
			return;
		}

		// Allow static resources
		if (path.startsWith("/assets/") || path.startsWith("/css/") || path.startsWith("/js/")
				|| path.startsWith("/images/")) {
			chain.doFilter(request, response);
			return;
		}

		// Allow home page
		if (path.equals("/") || path.equals("/index.jsp")) {
			chain.doFilter(request, response);
			return;
		}

		// Allow public auth pages (no login required)
		if (path.equals("/auth/login") || path.equals("/auth/register") || path.equals("/auth/forgot-password")
				|| path.equals("/auth/reset-password")) {
			chain.doFilter(request, response);
			return;
		}

		// =====================================================
		// VALID PATH CHECK
		// =====================================================

		// Check if the path is valid (exists in our application)
		boolean isValidPath = false;
		for (String validPath : VALID_PATHS) {
			if (path.startsWith(validPath)) {
				isValidPath = true;
				break;
			}
		}

		// If not a valid path, show 404 error page
		if (!isValidPath) {
			System.out.println("Invalid path detected: " + path + " - Showing 404");
			httpResponse.sendRedirect(contextPath + "/error-page?code=404");
			return;
		}

		// =====================================================
		// AUTHENTICATION REQUIRED FROM HERE
		// =====================================================

		// Check if user is logged in for protected paths
		HttpSession session = httpRequest.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			httpResponse.sendRedirect(contextPath + "/auth/login");
			return;
		}

		// Role-based access control
		String role = (String) session.getAttribute("role");

		if (path.startsWith("/admin") && !"admin".equals(role)) {
			httpResponse.sendRedirect(contextPath + "/error-page?code=404");
			return;
		}

		if (path.startsWith("/user") && !"customer".equals(role)) {
			httpResponse.sendRedirect(contextPath + "/error-page?code=404");
			return;
		}

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
	}
}