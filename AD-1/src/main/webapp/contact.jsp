<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact - PeerLearn</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <a href="index.jsp" class="brand">PeerLearn</a>
        <nav>
            <a href="login.jsp">Login</a>
            <a href="about.jsp">About</a>
        </nav>
    </header>

    <div class="container">
        <div class="form-container">
            <h2 style="text-align: center; color: var(--primary-color);">Contact Support</h2>
            <p style="text-align: center; margin-bottom: 2rem; color: var(--text-muted);">Have questions? Shoot us an inquiry.</p>
            
            <form action="contact.jsp" method="GET">
                <div class="form-group">
                    <label for="name">Your Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Your Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="message">Message Inquiry</label>
                    <textarea id="message" name="message" rows="4" required></textarea>
                </div>
                
                <button type="button" class="btn-primary" onclick="alert('Inquiry sent successfully!')">Submit Inquiry</button>
            </form>
        </div>
    </div>
</body>
</html>
