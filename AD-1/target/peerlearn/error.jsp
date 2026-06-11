<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Oops! Error Occurred</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container" style="display: flex; justify-content: center; align-items: center; height: 100vh;">
        <div class="form-container" style="text-align: center;">
            <h1 style="color: var(--error); font-size: 3rem; margin-bottom: 1rem;">
                <%= request.getParameter("code") != null ? request.getParameter("code") : "500" %>
            </h1>
            <h2>Something went wrong</h2>
            <p style="margin-top: 1rem; color: var(--text-muted);">
                <% if ("404".equals(request.getParameter("code"))) { %>
                    The page you are looking for does not exist.
                <% } else if ("403".equals(request.getParameter("code"))) { %>
                    You do not have permission to access this resource.
                <% } else { %>
                    An unexpected server error occurred.
                    <% if (exception != null) { %>
                        <br><small><%= exception.getMessage() %></small>
                    <% } %>
                <% } %>
            </p>
            <a href="index.jsp" class="btn-primary" style="display: inline-block; margin-top: 2rem; text-decoration: none;">Return Home</a>
        </div>
    </div>
</body>
</html>
