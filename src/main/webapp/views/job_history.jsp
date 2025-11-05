<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/fmt" prefix = "fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử nén file</title>
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
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            color: white;
            font-size: 0.9em;
            font-weight: bold;
        }
        .status-completed { background-color: #28a745; } /* Green */
        .status-processing { background-color: #ffc107; color: #333; } /* Yellow */
        .status-pending { background-color: #6c757d; } /* Grey */
        .status-failed { background-color: #dc3545; } /* Red */
        .action-link {
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            background-color: #007bff;
            display: inline-block;
            transition: background-color 0.3s, transform 0.2s;
        }
        .action-link:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
    </style>
</head>

<body>

    <header class="header">
        <h3>Xin chào, <strong>${sessionScope.user.username}</strong>!</h3>
        <nav>
            <a href="${pageContext.request.contextPath}/HomeServlet">Quản lý file</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet">Đăng xuất</a>
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
	                                <th style="width:20%;">Ngày yêu cầu</th>
	                                <th>Tên file</th>
	                                <th style="width:15%;">Trạng thái</th>
	                                <th style="width:20%;">Hành động</th>
	                            </tr>
	                        </thead>
	                        <tbody>
	                            <c:forEach items="${jobList}" var="job">
	                                <tr>
	                                    <td><strong>#${job.id}</strong></td>
	                                    <td><fmt:formatDate value = "${job.creationDate}" pattern = "HH:mm:ss, dd/MM/yyyy" /></td>
	                                    <td>${job.fileName}</td>
	                                    <td>
	                                        <span class="status-badge status-${job.status.toLowerCase()}">
	                                            <c:out value="${job.status}" />
	                                        </span>
	                                    </td>
	                                    <td>
	                                        <c:if test="${job.status == 'COMPLETED'}">
	                                            <a href="${pageContext.request.contextPath}/DownloadServlet?jobId=${job.id}" class="action-link">Tải xuống</a>
	                                        </c:if>
	                                        <c:if test="${job.status != 'COMPLETED'}">
	                                            -
	                                        </c:if>
	                                    </td>
	                                </tr>
	                            </c:forEach>
	                        </tbody>
	                    </table>
	                </c:when>
	                <c:otherwise>
	                    <p>Chưa có tác vụ nén nào được thực hiện.</p>
	                </c:otherwise>
	            </c:choose>
            </div>
        </div>
    </main>
	
	<script>
	    // Mở kết nối tới servlet SSE
	    const evtSource = new EventSource("${pageContext.request.contextPath}/JobStatusServlet");
	
	    evtSource.onmessage = function(e) {
	        console.log(" Job update:", e.data);
	
	        // Khi nhận được thông báo — có thể reload phần danh sách
	        refreshJobList();
	    };
	
	    async function refreshJobList() {
	        try {
	            const response = await fetch("${pageContext.request.contextPath}/JobHistoryServlet");
	            const html = await response.text();
	
	            // Giả sử danh sách job nằm trong <div id="jobList">
	            const parser = new DOMParser();
	            const newList = parser.parseFromString(html, "text/html").querySelector("#jobList");
	
	            if (newList) {
	                document.getElementById("jobList").innerHTML = newList.innerHTML;
	            }
	        } catch (err) {
	            console.error("Không thể làm mới danh sách job:", err);
	        }
	    }
	    
	    document.addEventListener("DOMContentLoaded", () => {
	        refreshJobList();
	    });
	</script>
</body>
</html>