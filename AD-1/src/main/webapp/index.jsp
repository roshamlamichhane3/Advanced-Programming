<%@ page import="com.peerlearn.model.User" %>
<%@ page import="com.peerlearn.model.Post" %>
<%@ page import="com.peerlearn.model.Category" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || "PENDING".equals(user.getStatus())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Post> posts = (List<Post>) request.getAttribute("posts");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    
    // Safety redirect if attributes missing
    if(posts == null) {
        response.sendRedirect("PostServlet?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PeerLearn - Feed</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .filter-bar { display: flex; gap: 1rem; margin-bottom: 2rem; background: white; padding: 1rem; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .post-title { margin: 0.5rem 0; color: var(--text-main); font-size: 1.25rem; }
        .post-meta { font-size: 0.875rem; color: var(--text-muted); margin-bottom: 1rem; }
    </style>
</head>
<body>
    <header>
        <a href="PostServlet?action=list" class="brand">PeerLearn</a>
        <nav>
            <a href="UserServlet?action=viewProfile">My Profile</a>
            <a href="PostServlet?action=wishlist">Wishlist</a>
            <% if ("ADMIN".equals(user.getRole())) { %>
                <a href="admin/dashboard.jsp" style="color: var(--primary-color);">Admin Panel</a>
            <% } %>
            <a href="AuthServlet?action=logout">Logout</a>
        </nav>
    </header>

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
            <h2>Community Feed</h2>
            <a href="PostServlet?action=new" class="btn-primary" style="text-decoration: none;">+ Ask Question</a>
        </div>

        <div class="filter-bar">
            <form action="PostServlet" method="GET" style="display: flex; gap: 1rem; width: 100%;">
                <input type="hidden" name="action" value="list">
                
                <input type="text" name="search" placeholder="Search titles or authors..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" 
                       style="flex-grow: 1;">
                       
                <select name="category_id" style="width: 200px;">
                    <option value="">All Categories</option>
                    <% if (categories != null) { 
                        String selectedCat = request.getParameter("category_id");
                        for (Category cat : categories) { %>
                            <option value="<%= cat.getId() %>" <%= (selectedCat != null && selectedCat.equals(String.valueOf(cat.getId()))) ? "selected" : "" %>>
                                <%= cat.getName() %>
                            </option>
                    <%  } 
                       } %>
                </select>
                
                <button type="submit" class="btn-primary" style="width: auto;">Filter</button>
            </form>
        </div>

        <div class="grid">
            <% if (posts.isEmpty()) { %>
                <p style="color: var(--text-muted); grid-column: 1 / -1; text-align: center; padding: 3rem;">No posts found matching your criteria.</p>
            <% } else { 
                for(Post p : posts) { %>
                <div class="card" style="display: flex; flex-direction: column;">
                    <span style="color: var(--primary-color); font-weight: 600; font-size: 0.875rem;"><%= p.getCategoryName() %></span>
                    <h3 class="post-title"><%= p.getTitle() %></h3>
                    <p class="post-meta">Posted by <strong><%= p.getAuthorName() %></strong> on <%= p.getCreatedAt() %></p>
                    
                    <div style="margin-top: auto; display: flex; justify-content: space-between;">
                        <a href="PostServlet?action=view&id=<%= p.getId() %>" class="btn-primary" style="text-decoration: none; padding: 0.5rem 1rem; font-size: 0.875rem;">View Discussion</a>
                        <form action="PostServlet" method="POST" style="margin: 0;">
                            <input type="hidden" name="action" value="addToWishlist">
                            <input type="hidden" name="postId" value="<%= p.getId() %>">
                            <input type="hidden" name="postTitle" value="<%= p.getTitle() %>">
                            <button type="submit" style="background:none; border:none; cursor:pointer; color: var(--primary-color); text-decoration: underline; font-size: 0.875rem;">+ Wishlist</button>
                        </form>
                    </div>
                </div>
            <%  }
               } %>
        </div>
    </div>
</body>
</html>
