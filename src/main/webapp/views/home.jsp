<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix = "fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang quản lý file</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0f8ff;
            margin: 0;
            color: #333;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: white;
            padding: 15px 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header h3 { color: #0056b3; margin: 0; }
        .header nav a {
            margin-left: 20px;
            color: #007bff;
            text-decoration: none;
            transition: 0.3s;
        }
        .header nav a:hover { color: #0056b3; }
        .container { padding: 30px; max-width: 1200px; margin: auto; }
        .card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td {
            padding: 12px 15px;
            border-bottom: 1px solid #dee2e6;
        }
        th { background-color: #e9ecef; color: #495057; }
        tr:hover { background-color: #f8f9fa; }
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
        .button:hover { background-color: #0056b3; transform: translateY(-2px); }
        .message, .error {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .message { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }

        /* ==== MODAL STYLE ==== */
        .modal {
            display: none; /* Ẩn mặc định */
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.4);
            justify-content: center;
            align-items: center;
            z-index: 999;
        }
        .modal-content {
            background: white;
            padding: 25px;
            border-radius: 10px;
            width: 400px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            text-align: center;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        .modal-content h4 { color: #0056b3; margin-top: 0; }
        .modal-content input {
            width: 90%;
            padding: 8px;
            margin-top: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
        }
        .modal-content .button {
            margin-top: 15px;
            width: 45%;
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
    <c:if test="${not empty sessionScope.message}">
        <p class="message">${sessionScope.message}</p>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <p class="error">${sessionScope.error}</p>
        <c:remove var="error" scope="session"/>
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
                <form id="zipForm" action="${pageContext.request.contextPath}/CreateZipServlet" method="post">
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
                                    <td><fmt:formatDate value="${file.uploadDate}" pattern="HH:mm:ss, dd/MM/yyyy" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <br>
                    <button type="button" class="button" onclick="openModal()">Nén các file đã chọn</button>
                </form>
            </c:when>
            <c:otherwise>
                <p>Bạn chưa tải lên file nào. Hãy bắt đầu bằng cách tải lên một file!</p>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- ==== MODAL POPUP ==== -->
<div class="modal" id="zipModal">
    <div class="modal-content">
        <h4>Thông tin file ZIP</h4>
        <input type="text" name="zipName" id="zipName" placeholder="Nhập tên file zip (ví dụ: myfiles)" required>
        <input type="password" name="password" id="password" placeholder="Đặt mật khẩu (bỏ trống để không đặt mật khẩu)">
        <div>
            <button class="button" onclick="submitZip()">Xác nhận</button>
            <button class="button" style="background:#6c757d;" onclick="closeModal()">Hủy</button>
        </div>
    </div>
</div>

<script>
    const modal = document.getElementById('zipModal');

    function openModal() {
        const checkboxes = document.querySelectorAll('input[name="selectedFiles"]:checked');
        if (checkboxes.length === 0) {
            alert("Vui lòng chọn ít nhất một file để nén!");
            return;
        }
        modal.style.display = 'flex';
    }

    function closeModal() {
        modal.style.display = 'none';
    }

    function submitZip() {
        const zipName = document.getElementById('zipName').value.trim();
        if (!zipName) {
            alert("Vui lòng nhập tên file zip!");
            return;
        }

        // Tạo các input ẩn để gửi kèm form gốc
        const form = document.getElementById('zipForm');

        const nameInput = document.createElement('input');
        nameInput.type = 'hidden';
        nameInput.name = 'zipName';
        nameInput.value = zipName;

        const passInput = document.createElement('input');
        passInput.type = 'hidden';
        passInput.name = 'password';
        passInput.value = document.getElementById('password').value;

        form.appendChild(nameInput);
        form.appendChild(passInput);

        form.submit();
        closeModal();
    }

    // Đóng modal khi click ra ngoài
    window.onclick = function(event) {
        if (event.target === modal) {
            closeModal();
        }
    }
</script>

</body>
</html>
