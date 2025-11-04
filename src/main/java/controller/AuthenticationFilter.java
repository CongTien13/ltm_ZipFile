package controller;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*") // Áp dụng filter cho tất cả các URL
public class AuthenticationFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        
        // Các URL công khai không cần đăng nhập
        boolean isPublicResource = requestURI.endsWith("LoginServlet") || 
                                   requestURI.endsWith("RegisterServlet") ||
                                   requestURI.contains("/views/login.jsp") ||
                                   requestURI.contains("/views/register.jsp") ||
                                   requestURI.contains("/assets/"); // Cho phép truy cập CSS, JS

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isPublicResource || isLoggedIn) {
            // Nếu là trang công khai hoặc đã đăng nhập -> cho phép đi tiếp
            chain.doFilter(request, response);
        } else {
            // Nếu truy cập trang riêng tư mà chưa đăng nhập -> đá về trang login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/LoginServlet");
        }
    }

    public void init(FilterConfig fConfig) throws ServletException {}
    public void destroy() {}
}