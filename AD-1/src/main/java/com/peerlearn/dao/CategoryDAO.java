package com.peerlearn.dao;

import com.peerlearn.model.Category;
import com.peerlearn.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM Categories ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category cat = new Category();
                cat.setId(rs.getInt("id"));
                cat.setName(rs.getString("name"));
                categories.add(cat);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return categories;
    }
}
