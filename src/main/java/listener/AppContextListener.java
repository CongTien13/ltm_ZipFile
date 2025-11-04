package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import worker.ZipWorker;

@WebListener // Annotation này rất quan trọng để Tomcat nhận diện Listener
public class AppContextListener implements ServletContextListener {

    private Thread workerThread = null;

    /**
     * Phương thức này được gọi khi web application được khởi động.
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println("Web Application is starting up...");
        
        // Khởi tạo và bắt đầu luồng xử lý nền
        ZipWorker zipWorker = new ZipWorker();
        workerThread = new Thread(zipWorker);
        workerThread.start();
        
        System.out.println("Zip Worker thread has been started.");
        System.out.println("=========================================");
    }

    /**
     * Phương thức này được gọi khi web application bị tắt đi (shutdown).
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=========================================");
        System.out.println("Web Application is shutting down...");
        
        if (workerThread != null) {
            // Ngắt luồng một cách an toàn
            workerThread.interrupt();
        }
        
        System.out.println("Zip Worker thread has been stopped.");
        System.out.println("=========================================");
    }
}