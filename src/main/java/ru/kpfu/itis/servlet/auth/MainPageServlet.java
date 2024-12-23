package ru.kpfu.itis.servlet.auth;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import ru.kpfu.itis.entity.Song;
import ru.kpfu.itis.service.SongService;
import ru.kpfu.itis.service.UserService;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/mainPage")
public class MainPageServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(MainPageServlet.class);

    private SongService songService;
    private UserService userService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        songService = (SongService) getServletContext().getAttribute("songService");
        userService = (UserService) getServletContext().getAttribute("userService");
        LOGGER.info("MainPageServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Long userId = (Long) req.getSession().getAttribute("user_id");

            // Получаем параметр `search` из запроса
            String searchQuery = req.getParameter("search");

            LOGGER.info("Search query: " + searchQuery);

            List<Song> songs;

            if (searchQuery != null && !searchQuery.isEmpty()) {
                // Если запрос на поиск задан, ищем по нему
                LOGGER.info("Search query received: {}", searchQuery);
                songs = songService.searchSongs(searchQuery);
                req.setAttribute("searchQuery", searchQuery);
                LOGGER.info("Found {} songs for search query: {}", songs.size(), searchQuery);
            } else {
                // Если запрос на поиск отсутствует, показываем все песни
                songs = songService.getAllSongs();
                req.removeAttribute("searchQuery"); // Убираем старый запрос поиска
                LOGGER.info("Displaying all {} songs.", songs.size());
            }

            req.setAttribute("songs", songs);

            if (userId == null) {
                req.setAttribute("authError", "Вы не вошли в аккаунт.");
                LOGGER.warn("User is not logged in. Redirecting to login page.");
                req.setAttribute("canUpload", false);
                req.setAttribute("canAddToFavorites", false);
            } else {
                req.setAttribute("canUpload", true);
                req.setAttribute("canAddToFavorites", true);
            }

            req.setAttribute("userId", userId);

            getServletContext().getRequestDispatcher("/WEB-INF/views/login/mainPage.jsp").forward(req, resp);
        } catch (SQLException e) {
            LOGGER.error("Error while fetching songs.", e);
            throw new ServletException("Error while fetching songs", e);
        }
    }
}