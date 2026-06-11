<%@ page import="com.peerlearn.model.Post" %>
<%@ page import="com.peerlearn.model.Answer" %>
<%@ page import="com.peerlearn.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Post post = (Post) request.getAttribute("post");
    List<Answer> answers = (List<Answer>) request.getAttribute("answers");
    User user = (User) session.getAttribute("user");
    if (post == null) { response.sendRedirect("PostServlet?action=list"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= post.getTitle() %> - PeerLearn</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .post-header { margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid #e5e7eb; }
        .answer-card { background: white; padding: 1.5rem; border-radius: 8px; margin-bottom: 1rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex; gap: 1rem; }
        .vote-col { display: flex; flex-direction: column; align-items: center; justify-content: start; min-width: 50px;}
        .upvote-btn { background: none; border: none; font-size: 1.5rem; color: var(--primary-color); cursor: pointer; }
        .action-links a { margin-right: 1rem; font-size: 0.875rem; color: var(--primary-color); text-decoration: none; font-weight: 500; }
        .action-links button { background: none; border: none; color: var(--error); cursor: pointer; font-size: 0.875rem; font-weight: 500;}
    </style>
</head>
<body>
    <header>
        <a href="PostServlet?action=list" class="brand">PeerLearn</a>
        <nav><a href="PostServlet?action=list">Back to Feed</a></nav>
    </header>

    <div class="container" style="max-width: 900px;">
        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= session.getAttribute("error") %></div>
            <% session.removeAttribute("error"); %>
        <% } %>

        <div class="post-header">
            <span style="color: var(--primary-color); font-weight: 600;"><%= post.getCategoryName() %></span>
            <h1 style="margin: 0.5rem 0 1rem 0;"><%= post.getTitle() %></h1>
            <p style="white-space: pre-wrap; font-size: 1.1rem; line-height: 1.6;"><%= post.getContent() %></p>
            
            <div style="margin-top: 1.5rem; display: flex; justify-content: space-between; align-items: center;">
                <span class="text-muted">Posted by <strong><%= post.getAuthorName() %></strong> on <%= post.getCreatedAt() %></span>
                
                <!-- Explicit Post Modification logic -->
                <% if(user.getId() == post.getUserId() || "ADMIN".equals(user.getRole())) { %>
                    <div class="action-links" style="display: flex; gap: 1rem;">
                        <a href="PostServlet?action=edit&id=<%= post.getId() %>">Edit Post</a>
                        <form action="PostServlet" method="POST" onsubmit="return confirm('Delete this post?');" style="margin:0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= post.getId() %>">
                            <button type="submit">Delete Post</button>
                        </form>
                    </div>
                <% } %>
            </div>
        </div>

        <h3><%= answers != null ? answers.size() : 0 %> Answers</h3>
        
        <div style="margin-top: 2rem;">
            <% if (answers != null) { for (Answer ans : answers) { %>
                <div class="answer-card">
                    <div class="vote-col">
                        <form action="PostServlet" method="POST">
                            <input type="hidden" name="action" value="likeAnswer">
                            <input type="hidden" name="answer_id" value="<%= ans.getId() %>">
                            <input type="hidden" name="post_id" value="<%= post.getId() %>">
                            <button type="submit" class="upvote-btn" title="Upvote">▲</button>
                        </form>
                        <span style="font-size: 1.25rem; font-weight: 600; color: var(--text-main);"><%= ans.getLikesCount() %></span>
                    </div>
                    <div style="flex-grow: 1;">
                        <p style="white-space: pre-wrap; margin-bottom: 0.5rem;"><%= ans.getContent() %></p>
                        <small style="color: var(--text-muted);">Answered by <strong><%= ans.getAuthorName() %></strong> at <%= ans.getCreatedAt() %></small>
                    </div>
                </div>
            <% } } %>
        </div>

        <div class="card" style="margin-top: 3rem;">
            <h4>Your Answer</h4>
            <form action="PostServlet" method="POST" style="margin-top: 1rem;">
                <input type="hidden" name="action" value="addAnswer">
                <input type="hidden" name="post_id" value="<%= post.getId() %>">
                <textarea name="content" required rows="5" style="width: 100%;" placeholder="Write your response..."></textarea>
                <button type="submit" class="btn-primary" style="margin-top: 1rem; width: auto;">Post Answer</button>
            </form>
        </div>
    </div>
</body>
</html>
