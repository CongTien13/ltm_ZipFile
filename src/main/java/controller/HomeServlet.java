package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.bean.UploadedFile;
import model.bean.User;
import model.bo.FileBO;

@WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FileBO fileBO = new FileBO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Lấy danh sách file của người dùng
        List<UploadedFile> fileList = fileBO.getFilesByUserId(user.getId());
        request.setAttribute("fileList", fileList);

        // Forward đến trang home để hiển thị
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}