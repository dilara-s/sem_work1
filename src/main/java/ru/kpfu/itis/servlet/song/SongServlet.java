package ru.kpfu.itis.servlet.song;

import ru.kpfu.itis.dao.impl.SongDaoImpl;
import ru.kpfu.itis.entity.Song;
import ru.kpfu.itis.service.SongService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Logger;

@WebServlet("/songDetails")
public class SongServlet extends HttpServlet {

    private SongService songService;
    private final static Logger LOG = Logger.getLogger(SongServlet.class.getName());

    @Override
    public void init() throws ServletException {
        songService = (SongService) getServletContext().getAttribute("songService");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Получаем ID песни из параметра запроса

            String id = req.getParameter("id");
            LOG.info("id" + id);


            Long songId = Long.parseLong(req.getParameter("id"));

            LOG.info("songId: " + songId);

            // Получаем песню по ID
            Song song = songService.getSongById(songId);

            if (song == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Song not found");
                return;
            }

            // Передаём песню на JSP
            req.setAttribute("song", song);

            // Перенаправление на JSP
            RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/songDetails.jsp");
            dispatcher.forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid song ID");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Получаем ID песни из параметра запроса
            Long songId = Long.parseLong(req.getParameter("id"));

            // Удаляем песню по ID
            songService.deleteSong(songId);

            // Перенаправляем на главную страницу
            resp.sendRedirect(req.getContextPath() + "/mainPage");
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid song ID");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}