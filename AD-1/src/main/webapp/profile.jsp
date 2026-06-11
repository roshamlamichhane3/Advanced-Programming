<%@ page import="com.peerlearn.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - PeerLearn</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
        function validateForm() {
            var fullName = document.getElementById("full_name").value;
            if (/\d/.test(fullName)) {
                alert("Full name cannot contain numeric characters!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <header>
        <a href="index.jsp" class="brand">PeerLearn</a>
        <nav>
            <a href="index.jsp">Feed</a>
            <a href="PostServlet?action=wishlist">Wishlist</a>
            <a href="AuthServlet?action=logout">Logout</a>
        </nav>
    </header>

    <div class="container">
        <div class="form-container" style="max-width: 600px;">
            <h2 style="text-align: center; margin-bottom: 2rem; color: var(--primary-color);">My Profile</h2>
            
            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= session.getAttribute("error") %></div>
                <% session.removeAttribute("error"); %>
            <% } %>
            
            <% if (session.getAttribute("msg") != null) { %>
                <div class="alert alert-success"><%= session.getAttribute("msg") %></div>
                <% session.removeAttribute("msg"); %>
            <% } %>

            <form action="UserServlet" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="updateProfile">
                
                <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <!-- Static Informational Data -->
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" value="<%= user.getUsername() %>" disabled style="background-color: #f3f4f6;">
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" value="<%= user.getEmail() %>" disabled style="background-color: #f3f4f6;">
                    </div>
                    
                    <div class="form-group" style="grid-column: span 2; margin-top: 1rem;">
                        <h4 style="margin-bottom: 0.5rem; color: var(--text-muted);">Personal Information</h4>
                        <hr style="margin-bottom: 1rem; border: 0; border-top: 1px solid #e5e7eb;">
                    </div>

                    <div class="form-group">
                        <label for="full_name">Full Name</label>
                        <input type="text" id="full_name" name="full_name" value="<%= user.getFullName() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob" value="<%= user.getDateOfBirth() != null ? user.getDateOfBirth().toString() : "" %>" required>
                    </div>
                    <div class="form-group" style="grid-column: span 2;">
                        <label for="contact">Contact Number</label>
                        <input type="text" id="contact" name="contact" value="<%= user.getContactDetails() %>" pattern="\d{10}" title="Ten digit contact number">
                    </div>

                    <div class="form-group" style="grid-column: span 2; margin-top: 1rem;">
                        <h4 style="margin-bottom: 0.5rem; color: var(--text-muted);">Academic Information</h4>
                        <hr style="margin-bottom: 1rem; border: 0; border-top: 1px solid #e5e7eb;">
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label for="courses">Courses Enrolled</label>
                        <input type="text" id="courses" name="courses" value="<%= user.getCoursesEnrolled() %>">
                    </div>
                    <div class="form-group">
                        <label for="level">Academic Level</label>
                        <select id="level" name="level">
                            <option value="Undergraduate" <%= "Undergraduate".equals(user.getAcademicLevel()) ? "selected" : "" %>>Undergraduate</option>
                            <option value="Postgraduate" <%= "Postgraduate".equals(user.getAcademicLevel()) ? "selected" : "" %>>Postgraduate</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="year">Year of Study</label>
                        <input type="number" id="year" name="year" min="1" max="6" value="<%= user.getAcademicYear() %>">
                    </div>
                </div>
                
                <button type="submit" class="btn-primary" style="margin-top: 2rem;">Update Profile</button>
            </form>
        </div>
    </div>
</body>
</html>
