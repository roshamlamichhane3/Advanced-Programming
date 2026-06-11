package com.peerlearn.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private String role;
    private String status;
    private String fullName;
    private java.sql.Date dateOfBirth;
    private String contactDetails;
    private String coursesEnrolled;
    private String academicLevel;
    private int academicYear;
    private Timestamp createdAt;

    // Default constructor
    public User() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public java.sql.Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(java.sql.Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getContactDetails() { return contactDetails; }
    public void setContactDetails(String contactDetails) { this.contactDetails = contactDetails; }

    public String getCoursesEnrolled() { return coursesEnrolled; }
    public void setCoursesEnrolled(String coursesEnrolled) { this.coursesEnrolled = coursesEnrolled; }

    public String getAcademicLevel() { return academicLevel; }
    public void setAcademicLevel(String academicLevel) { this.academicLevel = academicLevel; }

    public int getAcademicYear() { return academicYear; }
    public void setAcademicYear(int academicYear) { this.academicYear = academicYear; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
