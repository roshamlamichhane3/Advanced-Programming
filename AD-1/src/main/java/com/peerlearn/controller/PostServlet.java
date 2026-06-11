package com.peerlearn.controller;

import com.peerlearn.dao.AnswerDAO;
import com.peerlearn.dao.CategoryDAO;
import com.peerlearn.dao.PostDAO;
import com.peerlearn.model.Answer;
import com.peerlearn.model.Category;
import com.peerlearn.model.Post;
import com.peerlearn.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PostServlet")
public class PostServlet extends HttpServlet {
    private PostDAO postDAO;
    private CategoryDAO categoryDAO;
    private AnswerDAO answerDAO;

    @Override
    public void init() {
        this.postDAO = new PostDAO();
        this.categoryDAO = new CategoryDAO();
        this.answerDAO = new AnswerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("list".equals(action) || action == null) {
            String search = request.getParameter("search");
            String categoryId = request.getParameter("category_id");

            List<Post> posts = postDAO.getAllPosts(search, categoryId);
            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("posts", posts);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("index.jsp").forward(request, response);

        } else if ("view".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Post post = postDAO.getPostById(id);
            List<Answer> answers = answerDAO.getAnswersForPost(id);

            request.setAttribute("post", post);
            request.setAttribute("answers", answers);
            request.getRequestDispatcher("post.jsp").forward(request, response);

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Post post = postDAO.getPostById(id);

            User user = (User) request.getSession().getAttribute("user");
            if (post.getUserId() != user.getId() && !"ADMIN".equals(user.getRole())) {
                response.sendRedirect("error.jsp?code=403");
                return;
            }

            request.setAttribute("post", post);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("post_form.jsp").forward(request, response);

        } else if ("new".equals(action)) {
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("post_form.jsp").forward(request, response);

        } else if ("wishlist".equals(action)) {
            request.getRequestDispatcher("wishlist.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        if ("create".equals(action)) {
            Post post = new Post();
            post.setTitle(request.getParameter("title"));
            post.setContent(request.getParameter("content"));
            post.setCategoryId(Integer.parseInt(request.getParameter("category_id")));
            post.setUserId(loggedInUser.getId());
            postDAO.createPost(post);
            response.sendRedirect("PostServlet?action=list");

        } else if ("update".equals(action)) {
            Post post = new Post();
            post.setId(Integer.parseInt(request.getParameter("id")));
            post.setTitle(request.getParameter("title"));
            post.setContent(request.getParameter("content"));
            post.setCategoryId(Integer.parseInt(request.getParameter("category_id")));
            post.setUserId(loggedInUser.getId());
            postDAO.updatePost(post);
            response.sendRedirect("PostServlet?action=view&id=" + post.getId());

        } else if ("delete".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("id"));
            postDAO.deletePost(postId, loggedInUser.getId());
            response.sendRedirect("PostServlet?action=list");

        } else if ("addAnswer".equals(action)) {
            Answer ans = new Answer();
            ans.setPostId(Integer.parseInt(request.getParameter("post_id")));
            ans.setUserId(loggedInUser.getId());
            ans.setContent(request.getParameter("content"));
            answerDAO.createAnswer(ans);
            response.sendRedirect("PostServlet?action=view&id=" + ans.getPostId());

        } else if ("likeAnswer".equals(action)) {
            int answerId = Integer.parseInt(request.getParameter("answer_id"));
            int postId = Integer.parseInt(request.getParameter("post_id"));

            boolean liked = answerDAO.likeAnswer(answerId, loggedInUser.getId());
            if (!liked) {
                session.setAttribute("error", "You have already upvoted this answer.");
            }
            response.sendRedirect("PostServlet?action=view&id=" + postId);

        } else if ("addToWishlist".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            String postTitle = request.getParameter("postTitle");
            List<Post> wishlist = (List<Post>) session.getAttribute("wishlist");
            if (wishlist == null)
                wishlist = new ArrayList<>();
            if (!wishlist.stream().anyMatch(p -> p.getId() == postId)) {
                Post wishPost = new Post();
                wishPost.setId(postId);
                wishPost.setTitle(postTitle);
                wishlist.add(wishPost);
                session.setAttribute("wishlist", wishlist);
            }
            response.sendRedirect("PostServlet?action=list");
        }
    }
}
