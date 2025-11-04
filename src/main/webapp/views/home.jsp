<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix = "fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang quản lý file</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background-color: #f0f8ff; /* AliceBlue */
            color: #333;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #ffffff;
            padding: 15px 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header h3 {
            margin: 0;
            color: #0056b3;
        }
        .header nav a {
            margin-left: 20px;
            text-decoration: none;
            color: #007bff;
            font-weight: 500;
            transition: color 0.3s;
        }
        .header nav a:hover {
            color: #0056b3;
        }
        .container {
            padding: 30px;
            max-width: 1200px;
            margin: auto;
        }
        .card {
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        h4 {
            color: #0056b3;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 10px;
            margin-top: 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        th {
            background-color: #e9ecef;
            color: #495057;
            font-weight: 600;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .message, .error {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
        }
        .message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        input[type="file"] {
            border: 1px solid #ced4da;
            padding: 8px;
            border-radius: 4px;
        }
        .button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            color: white;
            background-color: #007bff;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s, transform 0.2s;
        }
        .button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

    <header class="header">
        <h3>Xin chào, <strong>${sessionScope.user.username}</strong>!</h3>
        <nav>
            <a href="${pageContext.request.contextPath}/JobHistoryServlet">Lịch sử nén file</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet">Đăng xuất</a>
        </nav>
    </header>

    <main class="container">
        <!-- Hiển thị thông báo (từ session) -->
        <c:if test="${not empty sessionScope.message}">
            <p class="message">${sessionScope.message}</p>
            <c:remove var="message" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <p class="error">${sessionScope.error}</p>
            <c:remove var="error" scope="session" />
        </c:if>
        
        <div class="card">
            <h4>Tải file mới lên</h4>
            <form action="${pageContext.request.contextPath}/UploadServlet" method="post" enctype="multipart/form-data">
                <input type="file" name="file" required />
                <input type="submit" value="Tải lên" class="button"/>
            </form>
        </div>

        <div class="card">
            <h4>Các file của bạn</h4>
            <c:choose>
                <c:when test="${not empty fileList}">
                    <form action="${pageContext.request.contextPath}/CreateZipServlet" method="post">
                        <table>
                            <thead>
                                <tr>
                                    <th style="width:5%;">Chọn</th>
                                    <th>Tên file</th>
                                    <th style="width:25%;">Ngày tải lên</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${fileList}" var="file">
                                    <tr>
                                        <td><input type="checkbox" name="selectedFiles" value="${file.id}" style="transform: scale(1.2);"></td>
                                        <td><c:out value="${file.originalFilename}" /></td>
                                        <td><fmt:formatDate value = "${file.uploadDate}" pattern = "HH:mm:ss, dd/MM/yyyy" /></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <br>
                        <input type="submit" value="Nén các file đã chọn thành .ZIP" class="button">
                    </form>
                </c:when>
                <c:otherwise>
                    <p>Bạn chưa tải lên file nào. Hãy bắt đầu bằng cách tải lên một file!</p>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

</body>
</html>