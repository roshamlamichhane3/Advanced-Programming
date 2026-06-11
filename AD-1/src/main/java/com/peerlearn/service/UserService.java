package com.peerlearn.service;

import com.peerlearn.dao.UserDAO;
import com.peerlearn.model.User;
import com.peerlearn.util.PasswordUtil;
import com.peerlearn.util.ValidationUtil;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public User authenticate(String username, String rawPassword) throws Exception {
        if (ValidationUtil.isNullOrEmpty(username) || ValidationUtil.isNullOrEmpty(rawPassword)) {
            throw new Exception("Username and password cannot be empty.");
        }
        
        User user = userDAO.getUserByUsername(username);
        if (user == null) {
            throw new Exception("User not found.");
        }
        
        if (!PasswordUtil.checkPassword(rawPassword, user.getPasswordHash())) {
            throw new Exception("Invalid password.");
        }
        
        if ("REJECTED".equals(user.getStatus())) {
            throw new Exception("Your account registration has been rejected.");
        }
        
        // Allowed: PENDING (with limited access) or APPROVED
        
        return user;
    }

    public void registerUser(User user, String rawPassword) throws Exception {
        if (ValidationUtil.containsNumbers(user.getFullName())) {
            throw new Exception("Full name cannot contain numeric characters.");
        }
        if (!ValidationUtil.isValidEmail(user.getEmail())) {
            throw new Exception("Invalid email format.");
        }
        
        if (userDAO.checkUserExists(user.getEmail(), user.getUsername())) {
            throw new Exception("A user with this email or username already exists.");
        }
        
        user.setPasswordHash(PasswordUtil.hashPassword(rawPassword));
        
        boolean registered = userDAO.registerUser(user);
        if (!registered) {
            throw new Exception("Failed to register. Please try again.");
        }
    }
}
