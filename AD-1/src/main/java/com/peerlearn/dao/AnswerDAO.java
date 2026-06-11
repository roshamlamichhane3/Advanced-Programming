package com.peerlearn.dao;

import com.peerlearn.model.Answer;
import com.peerlearn.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AnswerDAO {
    
    public List<Answer> getAnswersForPost(int postId) {
        List<Answer> answers = new ArrayList<>();
        String query = "SELECT a.*, u.username as author_name FROM Answers a " +
                       "JOIN Users u ON a.user_id = u.id " +
                       "WHERE a.post_id = ? ORDER BY a.likes_count DESC, a.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Answer ans = new Answer();
                    ans.setId(rs.getInt("id"));
                    ans.setPostId(rs.getInt("post_id"));
                    ans.setUserId(rs.getInt("user_id"));
                    ans.setContent(rs.getString("content"));
                    ans.setLikesCount(rs.getInt("likes_count"));
                    ans.setCreatedAt(rs.getTimestamp("created_at"));
                    ans.setAuthorName(rs.getString("author_name"));
                    answers.add(ans);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return answers;
    }

    public boolean createAnswer(Answer answer) {
        String query = "INSERT INTO Answers (post_id, user_id, content) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, answer.getPostId());
            ps.setInt(2, answer.getUserId());
            ps.setString(3, answer.getContent());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean likeAnswer(int answerId, int userId) {
        // Enforce DB constraint checking
        String queryInsert = "INSERT INTO Likes (answer_id, user_id) VALUES (?, ?)";
        String queryUpdate = "UPDATE Answers SET likes_count = likes_count + 1 WHERE id = ?";
        
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;
        
        try {
            conn.setAutoCommit(false);
            
            try (PreparedStatement psInsert = conn.prepareStatement(queryInsert)) {
                psInsert.setInt(1, answerId);
                psInsert.setInt(2, userId);
                psInsert.executeUpdate();
            }
            
            try (PreparedStatement psUpdate = conn.prepareStatement(queryUpdate)) {
                psUpdate.setInt(1, answerId);
                psUpdate.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            // IntegrityConstraintViolation (Duplicate entry) means user already liked
            return false;
        } finally {
            try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
