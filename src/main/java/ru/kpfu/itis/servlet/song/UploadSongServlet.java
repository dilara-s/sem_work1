package ru.kpfu.itis.servlet.song;

import com.cloudinary.utils.ObjectUtils;
import ru.kpfu.itis.dao.impl.SongDaoImpl;
import ru.kpfu.itis.entity.Song;
import ru.kpfu.itis.service.SongService;
import ru.kpfu.itis.util.CloudinaryUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/uploadSong")
public class UploadSongServlet extends HttpServlet {

    private SongService songService;
    private SongDaoImpl songDao;
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

        LOG.info(title + " " + artist + " " + lyrics);

        Part songFilePart = req.getPart("songFile"); // Получаем файл с формы

        if (songFilePart == null || songFilePart.getSize() == 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "No song file uploaded.");
            return;
        }

        try {
            Map uploadResult = CloudinaryUtil.getInstance().uploader()
                    .upload(songFilePart.getInputStream(), ObjectUtils.asMap("resource_type", "auto"));

            String songUrl = (String) uploadResult.get("url");

            Song song = new Song();
            song.setTitle(title);
            song.setArtist(artist);
            song.setUrl(songUrl);
            song.setLyrics(lyrics != null ? lyrics : "No lyrics for this song");

            songService.addSong(song);

            resp.sendRedirect(req.getContextPath() + "/mainPage");

        } catch (IOException | SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error uploading song");
        }
    }
}

