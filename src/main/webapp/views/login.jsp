<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .login-container { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); width: 300px; }
        h2 { text-align: center; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input[type="text"], input[type="password"] { width: 95%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        input[type="submit"] { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .error { color: red; text-align: center; margin-top: 10px; }
        .message { color: green; text-align: center; margin-top: 10px; }
        .register-link { text-align: center; margin-top: 15px; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Đăng nhập</h2>

        <!-- Hiển thị thông báo thành công (ví dụ: sau khi đăng ký) -->
        <c:if test="${not empty sessionScope.message}">
            <p class="message">${sessionScope.message}</p>
            <%-- Xóa message khỏi session để nó không hiển thị lại --%>
            <c:remove var="message" scope="session" />
        </c:if>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="form-group">
                <label for="username">Tên đăng nhập:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <input type="submit" value="Đăng nhập">
        </form>

        <!-- Hiển thị thông báo lỗi đăng nhập -->
        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <div class="register-link">
            <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/RegisterServlet">Đăng ký tại đây</a></p>
        </div>
    </div>
</body>
</html>