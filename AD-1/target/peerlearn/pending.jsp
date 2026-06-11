<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration Pending</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container" style="display: flex; justify-content: center; align-items: center; height: 100vh;">
        <div class="form-container" style="text-align: center;">
            <h2 style="color: var(--primary-color);">Account Pending Approval</h2>
            <p style="margin-top: 1rem; color: var(--text-muted);">
                Your registration has been submitted successfully. An administrator must approve your account before you can access the platform features. Please check back later.
            </p>
            <a href="AuthServlet?action=logout" class="btn-primary" style="display: inline-block; margin-top: 2rem; text-decoration: none;">Log Out</a>
        </div>
    </div>
</body>
</html>
