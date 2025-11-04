package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.bo.UserBO;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserBO userBO = new UserBO();
    
    // Hiển thị trang đăng ký
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }
    
    // Xử lý form đăng ký
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String result = userBO.createUser(username, password, confirmPassword);
        
        switch (result) {
            case "SUCCESS":
                // Đăng ký thành công, chuyển hướng đến trang đăng nhập với thông báo
                request.getSession().setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                break;
            case "USERNAME_EXISTS":
                request.setAttribute("error", "Tên đăng nhập đã tồn tại.");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                break;
            case "PASSWORD_MISMATCH":
                request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                break;
            default:
                request.setAttribute("error", "Đã có lỗi xảy ra. Vui lòng thử lại.");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                break;
        }
    }
}