package ru.kpfu.itis.servlet.profile;

import ru.kpfu.itis.dao.impl.FavouriteDaoImpl;
import ru.kpfu.itis.dao.impl.SongDaoImpl;
import ru.kpfu.itis.entity.Song;
import ru.kpfu.itis.entity.User;
import ru.kpfu.itis.service.FavoriteService;
import ru.kpfu.itis.service.SongService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/favourites")
public class FavouriteServlet extends HttpServlet {

    private FavoriteService favoriteService;
    private SongService songService;
    private FavouriteDaoImpl favouriteDao;
    private SongDaoImpl songDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.favoriteService = (FavoriteService) getServletContext().getAttribute("favouriteService");
        this.songService = (SongService) getServletContext().getAttribute("songService");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Получаем список песен, добавленных в избранное
            List<Long> favoriteSongIds = favoriteService.getUserFavoriteSongs(currentUser.getId());
            List<Song> favoriteSongs = songService.getSongsByIds(favoriteSongIds);

            req.setAttribute("favoriteSongs", favoriteSongs);
            req.setAttribute("pageTitle", "Your Favorite Songs");

            // Перенаправляем на страницу отображения избранных песен
            req.getRequestDispatcher("/WEB-INF/views/profile/favourites.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while fetching favorite songs.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        Long songId = Long.parseLong(req.getParameter("songId"));

        try {
            if ("add".equals(action)) {
                favoriteService.toggleFavorite(currentUser.getId(), songId);
            } else if ("remove".equals(action)) {
                favoriteService.toggleFavorite(currentUser.getId(), songId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while toggling favorite status.");
            return;
        }

        // После изменения фаворита, перенаправляем на список избранных песен
        resp.sendRedirect(req.getContextPath() + "/favourites");
    }
}
