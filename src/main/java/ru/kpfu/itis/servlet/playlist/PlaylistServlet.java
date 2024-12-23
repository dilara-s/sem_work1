package ru.kpfu.itis.servlet.playlist;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import ru.kpfu.itis.dao.FavouriteDao;
import ru.kpfu.itis.dao.impl.PlaylistDaoImpl;
import ru.kpfu.itis.dao.impl.UserDaoImpl;
import ru.kpfu.itis.entity.Playlist;
import ru.kpfu.itis.entity.User;
import ru.kpfu.itis.service.PlaylistService;
import ru.kpfu.itis.service.UserService;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

@WebServlet("/profile/playlists")
public class PlaylistServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(PlaylistServlet.class);
    private PlaylistService playlistService;
    private UserService userService;
    private UserDaoImpl userDao;
    private PlaylistDaoImpl playlistDao;
    private FavouriteDao favouriteDao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.playlistService = (PlaylistService)getServletContext().getAttribute("playlistService");
        this.userService = (UserService) getServletContext().getAttribute("userService");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        LOG.info(user.getId().toString());

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Playlist> playlists = playlistService.getUserPlaylists(user.getId());
            if (playlists.isEmpty()) {
                String errorNull = "У вас пока нет добавленнных плейлистов";
                req.setAttribute("errorNull", errorNull);
            }
            req.setAttribute("playlists", playlists);
        } catch (SQLException e) {
            LOG.error("Error fetching playlists for user {}", user.getId(), e);
            req.setAttribute("error", "Unable to load playlists. Please try again later.");
        }

        getServletContext().getRequestDispatcher("/WEB-INF/views/playlist/playlists.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String playlistName = req.getParameter("name");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Playlist playlist = new Playlist();
        playlist.setTitle(playlistName);
        playlist.setUserId(user.getId());

        try {
            playlistService.createPlaylist(playlist);
            resp.sendRedirect(req.getContextPath() + "/playlists");
        } catch (SQLException e) {
            LOG.error("Error creating playlist for user {}", user.getId(), e);
            req.setAttribute("error", "Unable to create playlist. Please try again later.");
            getServletContext().getRequestDispatcher("/WEB-INF/views/playlist/createPlaylist.jsp").forward(req, resp);
        }
    }
}

