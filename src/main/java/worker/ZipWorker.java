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

    private int jobId;
    private String fileName;
    private ZipJobDAO zipJobDAO = new ZipJobDAO();

    public ZipWorker(int jobId, String fileName) {
        this.jobId = jobId;
        this.fileName = fileName;
    }

    @Override
    public void run() {
        try {
            System.out.println(">>> Worker running job " + jobId);

            zipJobDAO.updateJobStatusAndResult(jobId, "PROCESSING", null);
            JobStatusServlet.broadcastJobUpdate(jobId, "PROCESSING");

            List<UploadedFile> filesToZip = zipJobDAO.getFilesForJob(jobId);

            String output = "F:/web_ltm_zips/" + fileName + ".zip";

            try (ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(output))) {
                byte[] buf = new byte[1024];

                for (UploadedFile f : filesToZip) {
                    File file = new File(f.getServerFilepath());
                    if (!file.exists()) continue;

                    zos.putNextEntry(new ZipEntry(f.getOriginalFilename()));
                    try (FileInputStream fis = new FileInputStream(file)) {
                        int len;
                        while ((len = fis.read(buf)) > 0) {
                            zos.write(buf, 0, len);
                        }
                    }
                    zos.closeEntry();
                }
            }

            zipJobDAO.updateJobStatusAndResult(jobId, "COMPLETED", output);
            JobStatusServlet.broadcastJobUpdate(jobId, "COMPLETED");

        } catch (Exception e) {
            zipJobDAO.updateJobStatusAndResult(jobId, "FAILED", null);
            JobStatusServlet.broadcastJobUpdate(jobId, "FAILED");
        }
    }
}
