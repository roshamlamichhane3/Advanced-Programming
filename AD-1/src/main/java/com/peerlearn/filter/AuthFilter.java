package com.peerlearn.filter;

import com.peerlearn.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Static resources and public pages bypass filter
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/") ||
                path.equals("/login.jsp") || path.equals("/register.jsp") || path.equals("/AuthServlet") ||
                path.equals("/error.jsp") || path.equals("/about.jsp") || path.equals("/contact.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            httpResponse
                    .sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=Please login to access this page.");
            return;
        }

        // Admin only pages enforcement
        if (path.startsWith("/admin") && !"ADMIN".equals(loggedInUser.getRole())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/error.jsp?code=403");
            return;
        }

        // Pending users shouldn't access full user features, redirect to wait page
        if ("PENDING".equals(loggedInUser.getStatus()) && !path.equals("/pending.jsp")
                && !path.equals("/AuthServlet")) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/pending.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
