<%@ page import="com.peerlearn.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"ADMIN".equals(sessionUser.getRole())) {
        response.sendRedirect("../error.jsp"); return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Admin</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #e5e7eb; }
        th { background: #f9fafb; font-weight: 600; color: var(--text-muted); }
        .action-form { display: inline-block; margin-right: 0.5rem; }
        td form button { background: none; border: none; cursor: pointer; text-decoration: underline; font-weight: 500;}
    </style>
</head>
<body>
    <header>
        <a href="AdminServlet?action=dashboard" class="brand">PeerLearn Admin</a>
        <nav>
            <a href="AdminServlet?action=approvals">Approvals</a>
            <a href="AdminServlet?action=users" style="color: var(--primary-color);">Manage Users</a>
            <a href="AdminServlet?action=posts">Manage Posts</a>
            <a href="../AuthServlet?action=logout">Logout</a>
        </nav>
    </header>

    <div class="container">
        <h2>Manage Platform Users</h2>
        <div class="card" style="margin-top: 2rem; overflow-x: auto;">
            <% if(users == null || users.isEmpty()) { %>
                <p style="color: var(--text-muted);">No users registered yet.</p>
            <% } else { %>
            <table>
                <tr>
                    <th>ID</th><th>Username</th><th>Name</th><th>Status</th><th>Actions</th>
                </tr>
                <% for (User u : users) { %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><%= u.getUsername() %></td>
                    <td><%= u.getFullName() %></td>
                    <td>
                        <%
                            String statusColor = "var(--primary-color)";
                            if ("BLOCKED".equals(u.getStatus())) statusColor = "var(--error)";
                            else if ("PENDING".equals(u.getStatus())) statusColor = "#d97706";
                        %>
                        <span style="color: <%= statusColor %>; font-weight: 600;">
                            <%= u.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <!-- Block/Unblock -->
                        <form action="AdminServlet" method="POST" class="action-form">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="userId" value="<%= u.getId() %>">
                            <% if ("BLOCKED".equals(u.getStatus())) { %>
                                <input type="hidden" name="status" value="APPROVED">
                                <button type="submit" style="color: var(--primary-color);">Unblock</button>
                            <% } else { %>
                                <input type="hidden" name="status" value="BLOCKED">
                                <button type="submit" style="color: #d97706;">Block</button>
                            <% } %>
                        </form>
                        
                        <!-- Delete User -->
                        <form action="AdminServlet" method="POST" class="action-form" onsubmit="return confirm('WARNING: Are you sure you want to completely delete user <%= u.getUsername() %>? This will remove all their posts and activity!');">
                            <input type="hidden" name="action" value="deleteUser">
                            <input type="hidden" name="userId" value="<%= u.getId() %>">
                            <button type="submit" style="color: var(--error);">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } %>
        </div>
    </div>
</body>
</html>
