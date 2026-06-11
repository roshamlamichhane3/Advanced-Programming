package com.peerlearn.dao;

import com.peerlearn.model.Post;
import com.peerlearn.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {

    public List<Post> getAllPosts(String keyword, String categoryId) {
        List<Post> posts = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT p.*, u.username as author_name, c.name as category_name " +
            "FROM Posts p " +
            "JOIN Users u ON p.user_id = u.id " +
            "JOIN Categories c ON p.category_id = c.id " +
            "WHERE (p.title LIKE ? OR u.username LIKE ?) "
        );

        if (categoryId != null && !categoryId.trim().isEmpty()) {
            query.append(" AND p.category_id = ? ");
        }
        query.append(" ORDER BY p.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            
            String searchPattern = "%" + (keyword == null ? "" : keyword) + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                ps.setInt(3, Integer.parseInt(categoryId));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    posts.add(extractPost(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return posts;
    }

    public Post getPostById(int id) {
        String query = "SELECT p.*, u.username as author_name, c.name as category_name " +
                       "FROM Posts p " +
                       "JOIN Users u ON p.user_id = u.id " +
                       "JOIN Categories c ON p.category_id = c.id " +
                       "WHERE p.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPost(rs);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean createPost(Post post) {
        String query = "INSERT INTO Posts (user_id, category_id, title, content) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, post.getUserId());
            ps.setInt(2, post.getCategoryId());
            ps.setString(3, post.getTitle());
            ps.setString(4, post.getContent());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updatePost(Post post) {
        String query = "UPDATE Posts SET title = ?, content = ?, category_id = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setInt(3, post.getCategoryId());
            ps.setInt(4, post.getId());
            ps.setInt(5, post.getUserId()); // Ensure only owner can update
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deletePost(int postId, int userId) {
        String query = "DELETE FROM Posts WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, postId);
            ps.setInt(2, userId); // Ensure only owner can delete
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Post extractPost(ResultSet rs) throws SQLException {
        Post post = new Post();
        post.setId(rs.getInt("id"));
        post.setUserId(rs.getInt("user_id"));
        post.setCategoryId(rs.getInt("category_id"));
        post.setTitle(rs.getString("title"));
        post.setContent(rs.getString("content"));
        post.setCreatedAt(rs.getTimestamp("created_at"));
        post.setAuthorName(rs.getString("author_name"));
        post.setCategoryName(rs.getString("category_name"));
        return post;
    }

    public boolean adminDeletePost(int postId) {
        String query = "DELETE FROM Posts WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
