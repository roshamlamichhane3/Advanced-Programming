<%@ page import="com.peerlearn.model.User" %>
<%@ page import="com.peerlearn.model.Post" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || !"ADMIN".equals(sessionUser.getRole())) {
        response.sendRedirect("../error.jsp"); return;
    }
    List<Post> posts = (List<Post>) request.getAttribute("posts");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Posts - Admin</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #e5e7eb; }
        th { background: #f9fafb; font-weight: 600; color: var(--text-muted); }
    </style>
</head>
<body>
    <header>
        <a href="AdminServlet?action=dashboard" class="brand">PeerLearn Admin</a>
        <nav>
            <a href="AdminServlet?action=approvals">Approvals</a>
            <a href="AdminServlet?action=users">Manage Users</a>
            <a href="AdminServlet?action=posts" style="color: var(--primary-color);">Manage Posts</a>
            <a href="../AuthServlet?action=logout">Logout</a>
        </nav>
    </header>

    <div class="container">
        <h2>Content Moderation</h2>
        <div class="card" style="margin-top: 2rem; overflow-x: auto;">
            <% if(posts == null || posts.isEmpty()) { %>
                <p style="color: var(--text-muted);">No posts active on the platform.</p>
            <% } else { %>
            <table>
                <tr>
                    <th>ID</th><th>Author</th><th>Title</th><th>Category</th><th>Posted At</th><th>Actions</th>
                </tr>
                <% for (Post p : posts) { %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td><%= p.getAuthorName() %></td>
                    <td><strong><%= p.getTitle() %></strong></td>
                    <td><%= p.getCategoryName() %></td>
                    <td><%= p.getCreatedAt() %></td>
                    <td style="display: flex; gap: 1rem;">
                        <a href="../PostServlet?action=view&id=<%= p.getId() %>" style="color: var(--primary-color); text-decoration: none; font-size: 0.875rem; font-weight: 500;">Inspect</a>
                        <form action="AdminServlet" method="POST" style="margin: 0;" onsubmit="return confirm('Remove this post completely from the platform?');">
                            <input type="hidden" name="action" value="deletePost">
                            <input type="hidden" name="postId" value="<%= p.getId() %>">
                            <button type="submit" style="background: none; border: none; color: var(--error); cursor: pointer; text-decoration: underline; font-weight: 500; font-size: 0.875rem; padding: 0;">Force Delete</button>
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
