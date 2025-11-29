<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix = "fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Quản Lý File</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #007bff;
            --primary-hover: #0056b3;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --background-color: #f4f7f9;
            --text-color: #333;
            --border-color: #dee2e6;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --border-radius: 12px;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--background-color);
            margin: 0;
            color: var(--text-color);
            line-height: 1.6;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #fff;
            padding: 15px 40px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .header .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .header .user-info {
            font-weight: 500;
        }

        .header nav a {
            margin-left: 25px;
            color: var(--secondary-color);
            text-decoration: none;
            transition: color 0.3s;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
        }
        .header nav a:hover { color: var(--primary-color); }
        .header nav a svg { margin-right: 8px; }

        .container {
            padding: 40px;
            max-width: 1200px;
            margin: auto;
        }

        .card {
            background: #fff;
            padding: 30px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 30px;
        }
        
        .card h4 {
            font-size: 1.5rem;
            color: var(--dark-color);
            margin-top: 0;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        th {
            background-color: var(--light-color);
            color: var(--dark-color);
            font-weight: 500;
            font-size: 0.9rem;
            text-transform: uppercase;
        }
        tr {
            transition: background-color 0.2s ease-in-out;
        }
        tr:hover {
            background-color: #f1faff;
        }
        td:first-child, th:first-child { padding-left: 20px; }
        td:last-child, th:last-child { padding-right: 20px; }

        .button {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            color: white;
            background-color: var(--primary-color);
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .button:hover {
            background-color: var(--primary-hover);
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.2);
        }
        
        .button.secondary {
            background-color: var(--secondary-color);
        }
        .button.secondary:hover {
            background-color: #5a6268;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .message, .error {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            font-weight: 500;
        }
        .message {
            background-color: #d1f7e0;
            color: #0f5132;
            border-color: #a3cfbb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }
        
        /* Custom Checkbox */
        .custom-checkbox {
            cursor: pointer;
            width: 20px;
            height: 20px;
        }

        /* Upload Form */
        .upload-form {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .upload-form input[type="file"] {
            flex-grow: 1;
        }
        
        /* ==== MODAL STYLE ==== */
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
            backdrop-filter: blur(5px);
        }
        .modal-content {
            background: white;
            padding: 30px;
            border-radius: var(--border-radius);
            width: 90%;
            max-width: 450px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            text-align: center;
            animation: fadeIn 0.4s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .modal-content h4 {
            color: var(--primary-color);
            margin-top: 0;
            font-size: 1.6rem;
            margin-bottom: 25px;
        }
        .modal-content .input-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .modal-content label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }
        .modal-content input[type="text"],
        .modal-content input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-sizing: border-box;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .modal-content input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.15);
        }
        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        .modal-buttons .button {
            flex: 1;
        }

    </style>
</head>
<body>

<header class="header">
    <div class="logo">FileZipper</div>
    <div class="user-info">
        Xin chào, <strong>${sessionScope.user.username}</strong>!
    </div>
    <nav>
        <a href="${pageContext.request.contextPath}/JobHistoryServlet">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16"><path d="M8.515 1.019A7 7 0 0 0 8 1V0a8 8 0 0 1 .589.022zm2.004.45a7 7 0 0 0-.985-.299l.219-1.974A8 8 0 0 1 10.5 0zM10 4.5a.5.5 0 0 0-1 0V7a.5.5 0 0 0 .5.5h2.5a.5.5 0 0 0 0-1H10z"/><path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 0-1h-3.5z"/><path d="M14.5 3a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v1A1.5 1.5 0 0 0 1.5 6h13A1.5 1.5 0 0 0 16 4.5v-1A1.5 1.5 0 0 0 14.5 2zM12.5 7a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5z"/></svg>
            Lịch sử nén
        </a>
        <a href="${pageContext.request.contextPath}/LogoutServlet">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/><path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/></svg>
            Đăng xuất
        </a>
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
        <h4>Tải tệp tin mới lên</h4>
        <form action="${pageContext.request.contextPath}/UploadServlet" method="post" enctype="multipart/form-data" class="upload-form">
            <input type="file" name="file" required class="file-input"/>
            <button type="submit" class="button">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M8 6.5a.5.5 0 0 1 .5.5v3.793l1.146-1.147a.5.5 0 0 1 .708.708l-2 2a.5.5 0 0 1-.708 0l-2-2a.5.5 0 1 1 .708-.708L7.5 10.793V7a.5.5 0 0 1 .5-.5"/><path d="M4 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zm0 1h8a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1"/></svg>
                Tải lên
            </button>
        </form>
    </div>

    <div class="card">
        <h4>Danh sách tệp tin của bạn</h4>
        <c:choose>
            <c:when test="${not empty fileList}">
                <form id="zipForm" action="${pageContext.request.contextPath}/CreateZipServlet" method="post">
                    <table>
                        <thead>
                            <tr>
                                <th style="width:5%; text-align:center;">Chọn</th>
                                <th>Tên tệp</th>
                                <th style="width:25%;">Ngày tải lên</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${fileList}" var="file">
                                <tr>
                                    <td style="text-align:center;"><input type="checkbox" name="selectedFiles" value="${file.id}" class="custom-checkbox"></td>
                                    <td><c:out value="${file.originalFilename}" /></td>
                                    <td><fmt:formatDate value="${file.uploadDate}" pattern="HH:mm:ss, dd/MM/yyyy" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <br>
                    <button type="button" class="button" onclick="openModal()">
                         <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/><path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708z"/></svg>
                         Nén các tệp đã chọn
                    </button>
                </form>
            </c:when>
            <c:otherwise>
                <p>Bạn chưa có tệp tin nào. Hãy bắt đầu bằng cách tải lên một tệp!</p>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- ==== MODAL POPUP ==== -->
<div class="modal" id="zipModal">
    <div class="modal-content">
        <h4>Thiết lập file nén</h4>
        <div class="input-group">
            <label for="zipName">Tên file ZIP (không bao gồm .zip)</label>
            <input type="text" name="zipName" id="zipName" placeholder="Ví dụ: tailieu_quan_trong" required>
        </div>
        <div class="modal-buttons">
            <button class="button secondary" onclick="closeModal()">Hủy</button>
            <button class="button" onclick="submitZip()">Xác nhận nén</button>
        </div>
    </div>
</div>

<script>
    const modal = document.getElementById('zipModal');
    const zipNameInput = document.getElementById('zipName');

    function openModal() {
        const checkboxes = document.querySelectorAll('input[name="selectedFiles"]:checked');
        if (checkboxes.length === 0) {
            alert("Vui lòng chọn ít nhất một tệp để nén!");
            return;
        }
        modal.style.display = 'flex';
        zipNameInput.focus(); // Tự động focus vào ô nhập tên
    }

    function closeModal() {
        modal.style.display = 'none';
    }

    function submitZip() {
        const zipName = zipNameInput.value.trim();
        if (!zipName) {
            alert("Vui lòng nhập tên cho file ZIP!");
            zipNameInput.focus();
            return;
        }

        // Kiểm tra tên file hợp lệ (không chứa ký tự đặc biệt)
        if (!/^[a-zA-Z0-9_.-]+$/.test(zipName)) {
            alert("Tên file chỉ nên chứa chữ cái, số, dấu gạch dưới, dấu gạch ngang và dấu chấm.");
            zipNameInput.focus();
            return;
        }


        // Tạo các input ẩn để gửi kèm form gốc
        const form = document.getElementById('zipForm');

        // Xóa input cũ nếu có để tránh trùng lặp
        form.querySelector('input[name="zipName"]')?.remove();
        //form.querySelector('input[name="password"]')?.remove();

        const nameInput = document.createElement('input');
        nameInput.type = 'hidden';
        nameInput.name = 'zipName';
        nameInput.value = zipName;

        //const passInput = document.createElement('input');
        //passInput.type = 'hidden';
        //passInput.name = 'password';
        //passInput.value = document.getElementById('password').value;

        form.appendChild(nameInput);
        //form.appendChild(passInput);

        form.submit();
        closeModal();
    }

    // Đóng modal khi click ra ngoài vùng nội dung
    window.onclick = function(event) {
        if (event.target === modal) {
            closeModal();
        }
    }
    
    // Đóng modal khi nhấn phím Escape
    window.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeModal();
        }
    });

</script>

</body>
</html>