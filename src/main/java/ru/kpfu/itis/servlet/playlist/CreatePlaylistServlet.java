package ru.kpfu.itis.servlet.playlist;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import ru.kpfu.itis.dao.FavouriteDao;
import ru.kpfu.itis.dao.impl.PlaylistDaoImpl;
import ru.kpfu.itis.dao.impl.SongDaoImpl;
import ru.kpfu.itis.entity.Playlist;
import ru.kpfu.itis.entity.Song;
import ru.kpfu.itis.entity.User;
import ru.kpfu.itis.service.PlaylistService;
import ru.kpfu.itis.service.SongService;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/playlists/create")
public class CreatePlaylistServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(CreatePlaylistServlet.class);
    private PlaylistService playlistService;
    private SongService songService;
    private SongDaoImpl songDao;
    private PlaylistDaoImpl playlistDao;
    private FavouriteDao favouriteDao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.playlistService = (PlaylistService) getServletContext().getAttribute("playlistService");
        this.songService = (SongService) getServletContext().getAttribute("songService");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Song> songs = songService.getAllSongs();
            req.setAttribute("songs", songs);
            getServletContext().getRequestDispatcher("/WEB-INF/views/playlist/createPlaylist.jsp").forward(req, resp);
        } catch (SQLException e) {
            LOG.error("Error fetching songs for playlist creation", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to fetch songs from the database.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String playlistName = req.getParameter("name");
        String description = req.getParameter("description");
        List<String> songIdsFromForm = Arrays.asList(req.getParameterValues("songIds"));

        if (songIdsFromForm == null || songIdsFromForm.isEmpty()) {
            req.setAttribute("error", "You must add at least one song to the playlist.");
            try {
                req.setAttribute("songs", songService.getAllSongs());
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            getServletContext().getRequestDispatcher("/WEB-INF/views/playlist/createPlaylist.jsp").forward(req, resp);
            return;
        }

        Playlist playlist = new Playlist();
        playlist.setTitle(playlistName);
        playlist.setDescription(description);
        playlist.setUserId(user.getId());

        try {
            Playlist playlistNew = playlistService.createPlaylist(playlist);

            Long playlistId = playlistNew.getId();

            for (String songIdStr : songIdsFromForm) {
                Long songId = Long.parseLong(songIdStr);

                Song song = songService.getSongById(songId);
                if (song != null) {
                    songService.addSongToPlaylist(playlistId, songId);
                } else {
                    LOG.warn("Song with ID {} does not exist in the database and will not be added to the playlist.", songId);
                }
            }

            resp.sendRedirect(req.getContextPath() + "/playlists");
        } catch (SQLException | IOException e) {
            LOG.error("Error creating playlist", e);
            req.setAttribute("error", "Unable to create playlist. Please try again later.");
            try {
                req.setAttribute("songs", songService.getAllSongs());
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
            getServletContext().getRequestDispatcher("/WEB-INF/views/playlist/createPlaylist.jsp").forward(req, resp);
        }
    }
}
