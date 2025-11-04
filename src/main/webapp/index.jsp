<%--
  File này đóng vai trò là cổng vào của ứng dụng.
  Nhiệm vụ duy nhất của nó là chuyển hướng (redirect) tất cả các request
  từ trang gốc đến LoginServlet để bắt đầu luồng xử lý chính.
--%>
<% response.sendRedirect(request.getContextPath() + "/LoginServlet"); %>