<%@ page import="com.peerlearn.model.Post" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Post> wishlist = (List<Post>) session.getAttribute("wishlist");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Wishlist - PeerLearn</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .wishlist-item { background: white; padding: 1.5rem; border-radius: 8px; margin-bottom: 1rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
    </style>
</head>
<body>
    <header>
        <a href="PostServlet?action=list" class="brand">PeerLearn</a>
        <nav><a href="PostServlet?action=list">Back to Feed</a></nav>
    </header>

    <div class="container" style="max-width: 800px;">
        <h2 style="margin-bottom: 2rem; color: var(--primary-color);">My Saved Posts (Wishlist)</h2>
        
        <% if (wishlist == null || wishlist.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 3rem;">
                <p style="color: var(--text-muted);">Your session wishlist is currently empty.</p>
                <a href="PostServlet?action=list" class="btn-primary" style="display: inline-block; margin-top: 1rem; text-decoration: none;">Browse Feed</a>
            </div>
        <% } else { 
            for (Post p : wishlist) { %>
                <div class="wishlist-item">
                    <h3 style="margin: 0; font-size: 1.125rem;"><%= p.getTitle() %></h3>
                    <a href="PostServlet?action=view&id=<%= p.getId() %>" class="btn-primary" style="text-decoration: none; padding: 0.5rem 1rem;">View Post</a>
                </div>
        <%  } 
           } %>
    </div>
</body>
</html>
