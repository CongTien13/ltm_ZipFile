<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập hệ thống</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #007bff;
            --primary-hover: #0056b3;
            --success-bg: #d1f7e0;
            --success-color: #0f5132;
            --error-bg: #f8d7da;
            --error-color: #721c24;
            --background-color: #f4f7f9;
            --text-color: #333;
            --border-color: #dee2e6;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --border-radius: 12px;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--background-color);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background: #fff;
            padding: 40px;
            border-radius: var(--border-radius);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
            animation: fadeIn 0.5s ease-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .logo {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
        }

        h2 {
            margin-top: 0;
            margin-bottom: 30px;
            color: var(--text-color);
            font-weight: 500;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            transition: color 0.3s;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px 15px 12px 45px; /* Thêm padding trái cho icon */
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-sizing: border-box; /* Quan trọng để padding không làm tăng width */
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.15);
        }
        
        input[type="text"]:focus + .input-icon,
        input[type="password"]:focus + .input-icon {
            color: var(--primary-color);
        }

        input[type="submit"] {
            width: 100%;
            padding: 14px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s;
        }

        input[type="submit"]:hover {
            background-color: var(--primary-hover);
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0, 123, 255, 0.25);
        }
        
        .message, .error {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px; /* Hiển thị phía trên form */
            font-size: 0.9rem;
            text-align: left;
        }

        .message {
            background-color: var(--success-bg);
            color: var(--success-color);
        }

        .error {
            background-color: var(--error-bg);
            color: var(--error-color);
        }

        .register-link {
            text-align: center;
            margin-top: 25px;
            font-size: 0.9rem;
        }
        .register-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">FileZipper</div>
        <h2>Đăng nhập vào tài khoản</h2>

        <!-- Hiển thị thông báo thành công hoặc lỗi -->
        <c:if test="${not empty sessionScope.message}">
            <p class="message">${sessionScope.message}</p>
            <c:remove var="message" scope="session" />
        </c:if>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="form-group">
                <input type="text" id="username" name="username" placeholder="Tên đăng nhập" required>
                <div class="input-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6m2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0m4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4m-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10s-3.516.68-4.168 1.332c-.678.678-.83 1.418-.832 1.664z"/>
                    </svg>
                </div>
            </div>
            <div class="form-group">
                <input type="password" id="password" name="password" placeholder="Mật khẩu" required>
                <div class="input-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2m3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2m-5 3a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/>
                    </svg>
                </div>
            </div>
            <input type="submit" value="Đăng nhập">
        </form>

        <div class="register-link">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/RegisterServlet">Đăng ký tại đây</a>
        </div>
    </div>
</body>
</html>