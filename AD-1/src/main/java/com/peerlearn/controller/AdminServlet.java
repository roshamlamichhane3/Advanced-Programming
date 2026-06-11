package com.peerlearn.controller;

import com.peerlearn.dao.AdminDAO;
import com.peerlearn.dao.PostDAO;
import com.peerlearn.dao.UserDAO;
import com.peerlearn.model.Post;
import com.peerlearn.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/AdminServlet")
public class AdminServlet extends HttpServlet {
    private UserDAO userDAO;
    private PostDAO postDAO;
    private AdminDAO adminDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
        this.postDAO = new PostDAO();
        this.adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) action = "dashboard";
        
        if ("approvals".equals(action)) {
            List<User> pendingUsers = userDAO.getPendingUsers();
            request.setAttribute("pendingUsers", pendingUsers);
            request.getRequestDispatcher("approvals.jsp").forward(request, response);
            
        } else if ("users".equals(action)) {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("manage_users.jsp").forward(request, response);
            
        } else if ("posts".equals(action)) {
            List<Post> posts = postDAO.getAllPosts(null, null);
            request.setAttribute("posts", posts);
            request.getRequestDispatcher("manage_posts.jsp").forward(request, response);
            
        } else if ("dashboard".equals(action)) {
            request.setAttribute("totalUsers", adminDAO.getTotalUsers());
            request.setAttribute("totalPosts", adminDAO.getTotalPosts());
            request.setAttribute("pendingCount", adminDAO.getPendingApprovalsCount());
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect("AdminServlet?action=dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("approveUser".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.updateUserStatus(userId, "APPROVED");
            response.sendRedirect("AdminServlet?action=approvals");
            
        } else if ("rejectUser".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.updateUserStatus(userId, "REJECTED");
            response.sendRedirect("AdminServlet?action=approvals");
            
        } else if ("updateStatus".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status"); // APPROVED or BLOCKED
            userDAO.updateUserStatus(userId, status);
            response.sendRedirect("AdminServlet?action=users");
            
        } else if ("deleteUser".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.deleteUser(userId);
            response.sendRedirect("AdminServlet?action=users");
            
        } else if ("deletePost".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            postDAO.adminDeletePost(postId);
            response.sendRedirect("AdminServlet?action=posts");
        }
    }
}
