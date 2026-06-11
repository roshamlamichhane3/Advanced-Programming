<%@ page import="com.peerlearn.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("../error.jsp?code=403");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - PeerLearn</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-card h3 { color: var(--text-muted); font-size: 1rem; }
        .stat-card p { font-size: 2rem; font-weight: bold; color: var(--primary-color); }
    </style>
</head>
<body>
    <header>
        <a href="AdminServlet?action=dashboard" class="brand">PeerLearn Admin</a>
        <nav>
            <a href="AdminServlet?action=approvals">Approvals</a>
            <a href="AdminServlet?action=users">Manage Users</a>
            <a href="AdminServlet?action=posts">Manage Posts</a>
            <a href="../AuthServlet?action=logout">Logout</a>
        </nav>
    </header>

    <div class="container">
        <h2>Dashboard Overview</h2>
        
        <div class="dashboard-stats" style="margin-top: 2rem;">
            <div class="stat-card">
                <h3>Pending Approvals</h3>
                <p><%= request.getAttribute("pendingCount") != null ? request.getAttribute("pendingCount") : "0" %></p>
            </div>
            <div class="stat-card">
                <h3>Active Posts</h3>
                <p><%= request.getAttribute("totalPosts") != null ? request.getAttribute("totalPosts") : "0" %></p>
            </div>
            <div class="stat-card">
                <h3>Total Users</h3>
                <p><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0" %></p>
            </div>
        </div>
        
        <div class="card" style="margin-top: 2rem; text-align: center;">
            <h3 style="margin-bottom: 1rem;">System running nominally</h3>
            <p style="color: var(--text-muted);">Use the navigation bar to manage the platform's constraints.</p>
        </div>
    </div>
</body>
</html>
