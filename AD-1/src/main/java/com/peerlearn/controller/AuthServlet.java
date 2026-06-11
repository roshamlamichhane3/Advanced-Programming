package com.peerlearn.controller;

import com.peerlearn.model.User;
import com.peerlearn.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        this.userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            login(request, response);
        } else if ("register".equals(action)) {
            register(request, response);
        } else if ("logout".equals(action)) {
            logout(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            logout(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = userService.authenticate(request.getParameter("username"), request.getParameter("password"));
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin/dashboard.jsp");
            } else if ("PENDING".equals(user.getStatus())) {
                response.sendRedirect("pending.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setEmail(request.getParameter("email"));
            user.setFullName(request.getParameter("full_name"));
            user.setContactDetails(request.getParameter("contact"));
            user.setCoursesEnrolled(request.getParameter("courses"));
            user.setAcademicLevel(request.getParameter("level"));
            user.setAcademicYear(Integer.parseInt(request.getParameter("year")));
            
            String dateStr = request.getParameter("dob");
            if (dateStr != null && !dateStr.isEmpty()) {
                user.setDateOfBirth(java.sql.Date.valueOf(dateStr));
            }

            userService.registerUser(user, request.getParameter("password")); // Saves via DAO
            
            request.setAttribute("success", "Registration successful! Please wait for admin approval.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp?msg=Logged out successfully");
    }
}
