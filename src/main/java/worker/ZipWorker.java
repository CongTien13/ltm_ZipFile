package worker;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import controller.JobStatusServlet;
import model.bean.UploadedFile;
import model.dao.ZipJobDAO;
import util.JobQueue;

public class ZipWorker implements Runnable {

    private ZipJobDAO zipJobDAO = new ZipJobDAO();
    private volatile boolean running = true;
    
    // Tạo một thư mục riêng để lưu các file ZIP kết quả
    private static final String ZIP_OUTPUT_DIRECTORY = "D:/web_ltm_zips";

    public ZipWorker() {
        // Đảm bảo thư mục output tồn tại khi Worker được tạo
        File outputDir = new File(ZIP_OUTPUT_DIRECTORY);
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }
    }
    
    @Override
    public void run() {
        System.out.println(">>> Zip Worker thread has started!");
        while (running) {
            int jobId = -1;
            String fileName = "result_" + jobId;
            try {
                // 1. Chờ và lấy một job ID từ hàng đợi
                jobId = JobQueue.getInstance().takeJob();
                fileName = JobQueue.getInstance().takeName();
                System.out.println(">>> Worker processing Job ID: " + jobId);

                // 2. Cập nhật trạng thái job thành "PROCESSING"
                zipJobDAO.updateJobStatusAndResult(jobId, "PROCESSING", null);
                JobStatusServlet.broadcastJobUpdate(jobId, "PROCESSING");
                
                // 3. Lấy danh sách các file cần nén từ CSDL
                List<UploadedFile> filesToZip = zipJobDAO.getFilesForJob(jobId);
                
                if (filesToZip.isEmpty()) {
                    throw new Exception("No files found for job ID: " + jobId);
                }
                
                // 4. THỰC HIỆN LOGIC NÉN FILE
                String resultZipPath = ZIP_OUTPUT_DIRECTORY + File.separator + fileName + ".zip";
                
                // Sử dụng try-with-resources để đảm bảo các stream được đóng tự động
                try (FileOutputStream fos = new FileOutputStream(resultZipPath);
                     ZipOutputStream zos = new ZipOutputStream(fos)) {
                    
                    byte[] buffer = new byte[1024];
                    
                    for (UploadedFile file : filesToZip) {
                        File sourceFile = new File(file.getServerFilepath());
                        // Đảm bảo file vật lý tồn tại trước khi nén
                        if (sourceFile.exists()) {
                            try (FileInputStream fis = new FileInputStream(sourceFile)) {
                                // Tạo một entry mới trong file ZIP với tên file gốc
                                zos.putNextEntry(new ZipEntry(file.getOriginalFilename()));
                                
                                int length;
                                while ((length = fis.read(buffer)) > 0) {
                                    zos.write(buffer, 0, length);
                                }
                                
                                zos.closeEntry();
                            }
                        } else {
                            System.out.println("File not found, skipping: " + file.getServerFilepath());
                        }
                    }
                }

                // 5. Cập nhật trạng thái job thành "COMPLETED"
                zipJobDAO.updateJobStatusAndResult(jobId, "COMPLETED", resultZipPath);
                JobStatusServlet.broadcastJobUpdate(jobId, "COMPLETED");
                System.out.println(">>> Worker finished Job ID: " + jobId + ". ZIP file created at: " + resultZipPath);

            } catch (InterruptedException e) {
                running = false;
                System.out.println(">>> Zip Worker thread has been interrupted and will stop.");
            } catch (Exception e) {
                System.err.println("!!! Error processing Job ID: " + jobId);
                e.printStackTrace();
                // Nếu có lỗi, cập nhật trạng thái job thành "FAILED"
                if (jobId != -1) {
                    zipJobDAO.updateJobStatusAndResult(jobId, "FAILED", null);
                    JobStatusServlet.broadcastJobUpdate(jobId, "FAILED");
                }
            }
        }
    }
    
    public void stop() {
        running = false;
    }
}