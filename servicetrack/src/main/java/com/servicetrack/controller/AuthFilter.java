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
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());
        
        // Allow access to login, register, and static resources
        boolean isAuthPage = path.startsWith("/auth/login") || path.startsWith("/auth/register");
        boolean isStaticResource = path.startsWith("/assets/") || path.startsWith("/css/") || 
                                   path.startsWith("/js/") || path.startsWith("/images/");
        boolean isIndexPage = path.equals("/") || path.equals("/index.jsp");
        
        if (isAuthPage || isStaticResource || isIndexPage) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(contextPath + "/auth/login");
            return;
        }
        
        // Role-based access control
        String role = (String) session.getAttribute("role");
        
        if (path.startsWith("/admin") && !"admin".equals(role)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        if (path.startsWith("/user") && !"customer".equals(role)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {}
}