package com.peerlearn.dao;

import com.peerlearn.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {
    
    public int getTotalUsers() {
        String query = "SELECT COUNT(*) FROM Users WHERE role != 'ADMIN'";
        return executeCount(query);
    }
    
    public int getTotalPosts() {
        String query = "SELECT COUNT(*) FROM Posts";
        return executeCount(query);
    }
    
    public int getPendingApprovalsCount() {
        String query = "SELECT COUNT(*) FROM Users WHERE status = 'PENDING'";
        return executeCount(query);
    }

    private int executeCount(String query) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
