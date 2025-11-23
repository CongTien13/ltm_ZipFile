<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix = "fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử nén file</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #007bff;
            --primary-hover: #0056b3;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --warning-color: #ffc107;
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
        }
        
        .card h4 {
            font-size: 1.5rem;
            color: var(--dark-color);
            margin-top: 0;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
        }
        
        #jobList {
            transition: opacity 0.4s ease-in-out;
        }
        #jobList.reloading {
            opacity: 0.5;
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
        td:first-child { font-weight: 500; color: var(--primary-color); }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            color: white;
            font-size: 0.85rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .status-badge svg {
            width: 14px;
            height: 14px;
        }
        .status-completed { background-color: var(--success-color); }
        .status-processing { background-color: var(--warning-color); color: #333; }
        .status-pending { background-color: var(--secondary-color); }
        .status-failed { background-color: var(--danger-color); }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .action-btn {
            padding: 8px 15px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .action-btn:hover {
             transform: translateY(-2px);
             box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .btn-download { background-color: var(--primary-color); }
        .btn-download:hover { background-color: var(--primary-hover); }
        .btn-delete { background-color: var(--danger-color); }
        .btn-delete:hover { background-color: #c82333; }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        .empty-state svg {
            width: 80px;
            height: 80px;
            color: #bdc3c7;
            margin-bottom: 20px;
        }
        .empty-state p {
            font-size: 1.2rem;
            color: #777;
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
            <a href="${pageContext.request.contextPath}/HomeServlet">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16"><path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2zm10-1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1M2 5.5a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5"/></svg>
                Quản lý file
            </a>
            <a href="${pageContext.request.contextPath}/LogoutServlet">
                 <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/><path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/></svg>
                Đăng xuất
            </a>
        </nav>
    </header>

    <main class="container">
        <div class="card">
            <h4>Lịch sử các tác vụ nén</h4>
            <div id="jobList">
	            <c:choose>
	                <c:when test="${not empty jobList}">
	                    <table>
	                        <thead>
	                            <tr>
	                                <th style="width:10%;">Job ID</th>
	                                <th style="width:20%;">Ngày tạo</th>
	                                <th>Tên tệp</th>
	                                <th style="width:15%;">Trạng thái</th>
	                                <th style="width:20%; text-align:center;">Hành động</th>
	                            </tr>
	                        </thead>
	                        <tbody>
	                            <c:forEach items="${jobList}" var="job">
	                                <tr>
	                                    <td><strong>#${job.id}</strong></td>
	                                    <td><fmt:formatDate value = "${job.creationDate}" pattern = "HH:mm:ss, dd/MM/yyyy" /></td>
	                                    <td>${job.fileName}</td>
	                                    <td>
	                                        <span class="status-badge status-${fn:toLowerCase(job.status)}">
	                                            <c:if test="${job.status == 'COMPLETED'}"><svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/></svg></c:if>
												<c:if test="${job.status == 'PROCESSING'}"><svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16"><path d="M8 3.5a.5.5 0 0 0-1 0V9a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 0-1h-3.5z"/><path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16m7-8A7 7 0 1 1 1 8a7 7 0 0 1 14 0"/></svg></c:if>
												<c:if test="${job.status == 'PENDING'}"><svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16"><path d="M8 16a.5.5 0 0 1-.5-.5V1a.5.5 0 0 1 1 0v14a.5.5 0 0 1-.5.5M1.707 3.707a.5.5 0 0 1 .707 0L4 5.293V1.5a.5.5 0 0 1 1 0v3.793l1.586-1.586a.5.5 0 1 1 .707.707l-2.5 2.5a.5.5 0 0 1-.707 0l-2.5-2.5a.5.5 0 0 1 0-.707m12.586 8.586a.5.5 0 0 1 .707 0l2.5 2.5a.5.5 0 0 1-.707.707L14 13.707V17.5a.5.5 0 0 1-1 0v-3.793l-1.586 1.586a.5.5 0 1 1-.707-.707l2.5-2.5Z"/></svg></c:if>
												<c:if test="${job.status == 'FAILED'}"><svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16"><path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0M5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293z"/></svg></c:if>
	                                            <c:out value="${job.status}" />
	                                        </span>
	                                    </td>
	                                    <td class="action-buttons" style="justify-content: center;">
	                                        <c:if test="${job.status == 'COMPLETED'}">
	                                            <a href="${pageContext.request.contextPath}/DownloadServlet?jobId=${job.id}" class="action-btn btn-download">
	                                                 <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5"/><path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708z"/></svg>
	                                                 Tải xuống
	                                            </a>
	                                        </c:if>
	                                        <c:if test="${job.status == 'COMPLETED' or job.status == 'FAILED'}">
												<!-- Chức năng xóa này cần được cài đặt ở backend -->
	                                            <a href="#" onclick="alert('Chức năng xóa đang được phát triển!')" class="action-btn btn-delete">
													<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0z"/><path d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4zM2.5 3h11V2h-11z"/></svg>
													Xóa
												</a>
											</c:if>
	                                    </td>
	                                </tr>
	                            </c:forEach>
	                        </tbody>
	                    </table>
	                </c:when>
	                <c:otherwise>
	                    <div class="empty-state">
	                        <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
								<path d="M8.5 2a.5.5 0 0 1 .5.5v2.5a.5.5 0 0 1-1 0V3H6v1.5a.5.5 0 0 1-1 0V3a.5.5 0 0 1 .5-.5z"/>
								<path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5z"/>
							</svg>
	                        <p>Lịch sử tác vụ của bạn đang trống.</p>
	                    </div>
	                </c:otherwise>
	            </c:choose>
            </div>
        </div>
    </main>
	
	<script>
	    const jobListDiv = document.getElementById("jobList");
	
	    // Mở kết nối tới servlet SSE
	    const evtSource = new EventSource("${pageContext.request.contextPath}/JobStatusServlet");
	
	    evtSource.onopen = function() {
	        console.log("SSE Connection established.");
	    };
	
	    evtSource.onmessage = function(e) {
	        console.log("Job update received:", e.data);
	        // Khi nhận được thông báo, làm mới danh sách
	        refreshJobList();
	    };
	
	    evtSource.onerror = function(err) {
	        console.error("EventSource failed:", err);
	    };
	
	    async function refreshJobList() {
	        jobListDiv.classList.add('reloading'); // Thêm class để làm mờ
	        
	        try {
	            // Lấy nội dung HTML mới từ servlet
	            const response = await fetch("${pageContext.request.contextPath}/JobHistoryServlet");
	            const html = await response.text();
	
	            // Dùng DOMParser để trích xuất chỉ phần #jobList từ HTML trả về
	            const parser = new DOMParser();
	            const newDoc = parser.parseFromString(html, "text/html");
	            const newJobList = newDoc.querySelector("#jobList");
	
	            if (newJobList) {
	                // Thay thế nội dung cũ bằng nội dung mới
	                jobListDiv.innerHTML = newJobList.innerHTML;
	            }
	        } catch (err) {
	            console.error("Failed to refresh job list:", err);
	        } finally {
	            // Xóa class làm mờ để hiển thị nội dung mới rõ ràng
	            setTimeout(() => {
	                jobListDiv.classList.remove('reloading');
	            }, 100); // delay một chút để hiệu ứng mượt hơn
	        }
	    }
	    
	    // Tự động làm mới danh sách khi tải trang lần đầu
	    document.addEventListener("DOMContentLoaded", () => {
	        refreshJobList();
	    });
	</script>
</body>
</html>