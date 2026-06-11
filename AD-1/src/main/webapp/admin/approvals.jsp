<%@ page import="com.peerlearn.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
        response.sendRedirect("../error.jsp?code=403");
        return;
    }
    List<User> pendingUsers = (List<User>) request.getAttribute("pendingUsers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Approvals - Admin</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #e5e7eb; }
        th { background-color: #f9fafb; color: var(--text-muted); }
        .action-btns { display: flex; gap: 0.5rem; }
        .btn-sm { padding: 0.5rem 1rem; border: none; border-radius: 4px; cursor: pointer; color: white; }
        .btn-approve { background-color: var(--success); }
        .btn-reject { background-color: var(--error); }
    </style>
</head>
<body>
    <header>
        <a href="dashboard.jsp" class="brand">PeerLearn Admin</a>
        <nav>
            <a href="AdminServlet?action=approvals">Approvals</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="../AuthServlet?action=logout">Logout</a>
        </nav>
    </header>

    <div class="container">
        <h2>Pending Registration Approvals</h2>
        
        <% if (session.getAttribute("msg") != null) { %>
            <div class="alert alert-success" style="margin-top: 1rem;"><%= session.getAttribute("msg") %></div>
            <% session.removeAttribute("msg"); %>
        <% } %>

        <div class="card" style="margin-top: 2rem;">
            <% if (pendingUsers != null && !pendingUsers.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Username</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Role Applied</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(User u : pendingUsers) { %>
                        <tr>
                            <td><%= u.getUsername() %></td>
                            <td><%= u.getFullName() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getRole() %></td>
                            <td class="action-btns">
                                <form action="AdminServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="approveUser">
                                    <input type="hidden" name="userId" value="<%= u.getId() %>">
                                    <button type="submit" class="btn-sm btn-approve">Approve</button>
                                </form>
                                <form action="AdminServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="rejectUser">
                                    <input type="hidden" name="userId" value="<%= u.getId() %>">
                                    <button type="submit" class="btn-sm btn-reject">Reject</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p style="color: var(--text-muted); margin-top: 1rem;">No pending users found.</p>
            <% } %>
        </div>
    </div>
</body>
</html>
