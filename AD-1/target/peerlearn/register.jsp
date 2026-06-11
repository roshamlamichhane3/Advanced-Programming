<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - PeerLearn</title>
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
        <a href="login.jsp" class="brand">PeerLearn</a>
        <nav>
            <a href="login.jsp">Login</a>
            <a href="about.jsp">About</a>
        </nav>
    </header>

    <div class="container">
        <div class="form-container" style="max-width: 600px;">
            <h2 style="text-align: center; margin-bottom: 2rem; color: var(--primary-color);">Create Account</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="AuthServlet" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="register">
                
                <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <!-- Account Details -->
                    <div class="form-group" style="grid-column: span 2;">
                        <h4 style="margin-bottom: 0.5rem; color: var(--text-muted);">Account Information</h4>
                        <hr style="margin-bottom: 1rem; border: 0; border-top: 1px solid #e5e7eb;">
                    </div>

                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group" style="grid-column: span 2;">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <!-- Personal Details -->
                    <div class="form-group" style="grid-column: span 2; margin-top: 1rem;">
                        <h4 style="margin-bottom: 0.5rem; color: var(--text-muted);">Personal Information</h4>
                        <hr style="margin-bottom: 1rem; border: 0; border-top: 1px solid #e5e7eb;">
                    </div>

                    <div class="form-group">
                        <label for="full_name">Full Name</label>
                        <input type="text" id="full_name" name="full_name" required>
                    </div>
                    <div class="form-group">
                        <label for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob" required>
                    </div>
                    <div class="form-group" style="grid-column: span 2;">
                        <label for="contact">Contact Number</label>
                        <input type="text" id="contact" name="contact" pattern="\d{10}" title="Ten digit contact number">
                    </div>

                    <!-- Academic Details -->
                    <div class="form-group" style="grid-column: span 2; margin-top: 1rem;">
                        <h4 style="margin-bottom: 0.5rem; color: var(--text-muted);">Academic Information</h4>
                        <hr style="margin-bottom: 1rem; border: 0; border-top: 1px solid #e5e7eb;">
                    </div>

                    <div class="form-group" style="grid-column: span 2;">
                        <label for="courses">Courses Enrolled (comma separated)</label>
                        <input type="text" id="courses" name="courses">
                    </div>
                    <div class="form-group">
                        <label for="level">Academic Level</label>
                        <select id="level" name="level">
                            <option value="Undergraduate">Undergraduate</option>
                            <option value="Postgraduate">Postgraduate</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="year">Year of Study</label>
                        <input type="number" id="year" name="year" min="1" max="6" value="1">
                    </div>
                </div>
                
                <button type="submit" class="btn-primary" style="margin-top: 2rem;">Register Account</button>
            </form>
        </div>
    </div>
</body>
</html>
