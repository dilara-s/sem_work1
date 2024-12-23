package ru.kpfu.itis.servlet.song;

import com.cloudinary.utils.ObjectUtils;
import ru.kpfu.itis.dao.impl.SongDaoImpl;
import ru.kpfu.itis.entity.Song;
import ru.kpfu.itis.service.SongService;
import ru.kpfu.itis.util.CloudinaryUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 250 // 250MB
)
@WebServlet("/uploadSong")
public class UploadSongServlet extends HttpServlet {

    private SongService songService;
    private final static Logger LOG = Logger.getLogger(UploadSongServlet.class.getName());

    @Override
    public void init() throws ServletException {
        songService = (SongService) getServletContext().getAttribute("songService");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/song/uploadSong.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String title = req.getParameter("title");
        String artist = req.getParameter("artist");
        String lyrics = req.getParameter("lyrics");

        LOG.info("Title: " + title + ", Artist: " + artist + ", Lyrics: " + lyrics);

        Part songFilePart = req.getPart("songFile"); // Получаем аудиофайл
        Part songImagePart = req.getPart("songImage"); // Получаем изображение

        if (songFilePart == null || songFilePart.getSize() == 0 || songImagePart == null || songImagePart.getSize() == 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Both song file and image are required.");
            return;
        }

        try {
            // Загрузка аудиофайла на Cloudinary
            File songFile = getFile(songFilePart);
            Map<String, Object> songUploadParams = new HashMap<>();
            songUploadParams.put("resource_type", "video");

            Map<?, ?> songUploadResult = CloudinaryUtil.getInstance().uploader()
                    .upload(songFile, songUploadParams);
            String songUrl = (String) songUploadResult.get("url");

            LOG.info("Song uploaded to: " + songUrl);

            // Загрузка изображения на Cloudinary
            File songImageFile = getFile(songImagePart);
            Map<String, Object> imageUploadParams = new HashMap<>();
            imageUploadParams.put("resource_type", "image");

            Map<?, ?> imageUploadResult = CloudinaryUtil.getInstance().uploader()
                    .upload(songImageFile, imageUploadParams);
            String imageUrl = (String) imageUploadResult.get("url");

            LOG.info("Image uploaded to: " + imageUrl);

            // Создаем объект песни
            Song song = new Song();
            song.setTitle(title);
            song.setArtist(artist);
            song.setUrl(songUrl);
            song.setCoverImage(imageUrl);
            song.setLyrics(lyrics != null ? lyrics : "No lyrics for this song");

            songService.addSong(song);

            resp.sendRedirect(req.getContextPath() + "/mainPage");

        } catch (IOException | SQLException e) {
            LOG.severe("Error uploading song or image: " + e.getMessage());
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error uploading song or image");
        }
    }

    private static File getFile(Part part) throws IOException {
        String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        File file = new File(System.getProperty("java.io.tmpdir"), filename);

        try (InputStream content = part.getInputStream();
             FileOutputStream outputStream = new FileOutputStream(file)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = content.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        }

        return file;
    }
}
