<%@ page import="com.peerlearn.model.Post" %>
<%@ page import="com.peerlearn.model.Category" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Post post = (Post) request.getAttribute("post");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    boolean isEdit = post != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Edit Post" : "Create Post" %> - PeerLearn</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <a href="PostServlet?action=list" class="brand">PeerLearn</a>
        <nav>
            <a href="PostServlet?action=list">Feed</a>
        </nav>
    </header>

    <div class="container">
        <div class="form-container" style="max-width: 800px;">
            <h2 style="margin-bottom: 2rem; color: var(--primary-color);">
                <%= isEdit ? "Edit Your Post" : "Post a Question/Material" %>
            </h2>
            
            <form action="PostServlet" method="POST">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "create" %>">
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= post.getId() %>">
                <% } %>
                
                <div class="form-group">
                    <label>Title</label>
                    <input type="text" name="title" required value="<%= isEdit ? post.getTitle() : "" %>" placeholder="What's your question?">
                </div>
                
                <div class="form-group">
                    <label>Category</label>
                    <select name="category_id" required>
                        <% if (categories != null) { 
                            for (Category cat : categories) { %>
                                <option value="<%= cat.getId() %>" <%= (isEdit && post.getCategoryId() == cat.getId()) ? "selected" : "" %>>
                                    <%= cat.getName() %>
                                </option>
                        <%  } 
                           } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Content and Description</label>
                    <textarea name="content" required rows="8" placeholder="Provide more details here..."><%= isEdit ? post.getContent() : "" %></textarea>
                </div>
                
                <button type="submit" class="btn-primary"><%= isEdit ? "Save Changes" : "Publish Post" %></button>
            </form>
        </div>
    </div>
</body>
</html>
