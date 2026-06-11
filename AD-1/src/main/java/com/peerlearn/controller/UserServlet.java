package com.peerlearn.controller;

import com.peerlearn.dao.UserDAO;
import com.peerlearn.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("viewProfile".equals(action)) {
            HttpSession session = request.getSession();
            User sessionUser = (User) session.getAttribute("user");
            
            // Refresh user from DB to catch latest changes
            User user = userDAO.getUserById(sessionUser.getId());
            session.setAttribute("user", user); // update session natively
            
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        if ("updateProfile".equals(action)) {
            try {
                loggedInUser.setFullName(request.getParameter("full_name"));
                
                String dateStr = request.getParameter("dob");
                if (dateStr != null && !dateStr.isEmpty()) {
                    loggedInUser.setDateOfBirth(java.sql.Date.valueOf(dateStr));
                }
                
                loggedInUser.setContactDetails(request.getParameter("contact"));
                loggedInUser.setCoursesEnrolled(request.getParameter("courses"));
                loggedInUser.setAcademicLevel(request.getParameter("level"));
                loggedInUser.setAcademicYear(Integer.parseInt(request.getParameter("year")));
                
                if (userDAO.updateUserProfile(loggedInUser)) {
                    session.setAttribute("msg", "Profile updated successfully!");
                } else {
                    session.setAttribute("error", "Error updating profile.");
                }
            } catch (Exception e) {
                session.setAttribute("error", "Invalid data format submitted.");
            }
            response.sendRedirect("UserServlet?action=viewProfile");
        }
    }
}
