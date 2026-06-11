package com.peerlearn.dao;

import com.peerlearn.model.User;
import com.peerlearn.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public User authenticateUser(String username, String passwordHash) {
        // Authenticates based on hash match. Pre-hashing or post-hashing compare happens in Service
        return null; // Will implement properly in service via fetching user by username
    }

    public User getUserByUsername(String username) {
        User user = null;
        String query = "SELECT * FROM Users WHERE username = ? OR email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return user;
    }

    public boolean registerUser(User user) {
        String query = "INSERT INTO Users (username, email, password_hash, full_name, date_of_birth, contact_details, courses_enrolled, academic_level, academic_year, status) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getFullName());
            ps.setDate(5, user.getDateOfBirth());
            ps.setString(6, user.getContactDetails());
            ps.setString(7, user.getCoursesEnrolled());
            ps.setString(8, user.getAcademicLevel());
            ps.setInt(9, user.getAcademicYear());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<User> getPendingUsers() {
        List<User> pendingUsers = new ArrayList<>();
        String query = "SELECT * FROM Users WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
             while (rs.next()) {
                 pendingUsers.add(extractUserFromResultSet(rs));
             }
        } catch (SQLException e) { e.printStackTrace(); }
        return pendingUsers;
    }

    public boolean updateUserStatus(int userId, String status) {
        String query = "UPDATE Users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             ps.setString(1, status);
             ps.setInt(2, userId);
             return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    
    public boolean checkUserExists(String email, String username) {
        String query = "SELECT id FROM Users WHERE email = ? OR username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             ps.setString(1, email);
             ps.setString(2, username);
             try(ResultSet rs = ps.executeQuery()) {
                 return rs.next();
             }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setFullName(rs.getString("full_name"));
        user.setDateOfBirth(rs.getDate("date_of_birth"));
        user.setContactDetails(rs.getString("contact_details"));
        user.setCoursesEnrolled(rs.getString("courses_enrolled"));
        user.setAcademicLevel(rs.getString("academic_level"));
        user.setAcademicYear(rs.getInt("academic_year"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

    public boolean updateUserProfile(User user) {
        String query = "UPDATE Users SET full_name = ?, date_of_birth = ?, contact_details = ?, courses_enrolled = ?, academic_level = ?, academic_year = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, user.getFullName());
            ps.setDate(2, user.getDateOfBirth());
            ps.setString(3, user.getContactDetails());
            ps.setString(4, user.getCoursesEnrolled());
            ps.setString(5, user.getAcademicLevel());
            ps.setInt(6, user.getAcademicYear());
            ps.setInt(7, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public User getUserById(int id) {
        User user = null;
        String query = "SELECT * FROM Users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return user;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM Users WHERE role != 'ADMIN' ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return users;
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM Users WHERE id = ? AND role != 'ADMIN'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
