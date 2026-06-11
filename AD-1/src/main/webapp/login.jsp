<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - PeerLearn</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <a href="login.jsp" class="brand">PeerLearn</a>
        <nav>
            <a href="register.jsp">Register</a>
            <a href="about.jsp">About</a>
            <a href="contact.jsp">Contact</a>
        </nav>
    </header>

    <div class="container">
        <div class="form-container">
            <h2 style="text-align: center; margin-bottom: 2rem; color: var(--primary-color);">Welcome Back</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error"><%= request.getParameter("error") %></div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>
            
            <% if (request.getParameter("msg") != null) { %>
                <div class="alert alert-success"><%= request.getParameter("msg") %></div>
            <% } %>

            <form action="AuthServlet" method="POST">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <button type="submit" class="btn-primary">Sign In</button>
            </form>
            <p style="text-align: center; margin-top: 1rem;">
                Don't have an account? <a href="register.jsp" style="color: var(--primary-color);">Register here</a>
            </p>
        </div>
    </div>
</body>
</html>
