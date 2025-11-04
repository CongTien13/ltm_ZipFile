//package controller;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.util.List;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//import com.google.gson.Gson; // Import thư viện Gson
//
//import model.bean.User;
//import model.bean.ZipJob;
//import model.bo.ZipJobBO;
//
//@WebServlet("/JobStatusServlet")
//public class JobStatusServlet extends HttpServlet {
//    private static final long serialVersionUID = 1L;
//    private ZipJobBO zipJobBO = new ZipJobBO();
//    private Gson gson = new Gson();
//
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession(false);
//        User user = (session != null) ? (User) session.getAttribute("user") : null;
//
//        if (user == null) {
//            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//            return;
//        }
//
//        // 1. Lấy danh sách job mới nhất từ CSDL
//        List<ZipJob> jobList = zipJobBO.getJobsByUserId(user.getId());
//
//        // 2. Dùng Gson để chuyển List<ZipJob> thành chuỗi JSON
//        String jobsJsonString = this.gson.toJson(jobList);
//
//        // 3. Thiết lập response header và gửi chuỗi JSON về cho client
//        response.setContentType("application/json");
//        response.setCharacterEncoding("UTF-8");
//        PrintWriter out = response.getWriter();
//        out.print(jobsJsonString);
//        out.flush();
//    }
//}