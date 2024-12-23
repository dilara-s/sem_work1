package ru.kpfu.itis.listener;

import ru.kpfu.itis.dao.UserDao;
import ru.kpfu.itis.dao.SongDao;
import ru.kpfu.itis.dao.PlaylistDao;
import ru.kpfu.itis.dao.FavouriteDao;
import ru.kpfu.itis.dao.impl.FavouriteDaoImpl;
import ru.kpfu.itis.dao.impl.PlaylistDaoImpl;
import ru.kpfu.itis.dao.impl.SongDaoImpl;
import ru.kpfu.itis.dao.impl.UserDaoImpl;
import ru.kpfu.itis.service.UserService;
import ru.kpfu.itis.service.SongService;
import ru.kpfu.itis.service.PlaylistService;
import ru.kpfu.itis.service.FavoriteService;
import ru.kpfu.itis.util.DatabaseCollectionUtil;

import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

///
///не понытно короче тут че ваще ну что то с фейворит дао не то посмотреть 22 таск
///
@WebListener
public class InitListener implements javax.servlet.ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            Connection connection = DatabaseCollectionUtil.getConnection();

            UserDao userDao = new UserDaoImpl(connection);
            SongDao songDao = new SongDaoImpl(connection);

            FavouriteDao favouriteDao = new FavouriteDaoImpl(connection);
            PlaylistDao playlistDao = new PlaylistDaoImpl(connection);

            UserService userService = new UserService(userDao);
            SongService songService = new SongService(songDao);
            FavoriteService favoriteService = new FavoriteService(favouriteDao);
            PlaylistService playlistService = new PlaylistService(playlistDao);


            sce.getServletContext().setAttribute("userDao", userDao);
            sce.getServletContext().setAttribute("songDao", songDao);
            sce.getServletContext().setAttribute("playlistDao", playlistDao);
            sce.getServletContext().setAttribute("favouriteDao", favouriteDao);

            sce.getServletContext().setAttribute("userService", userService);
            sce.getServletContext().setAttribute("songService", songService);
            sce.getServletContext().setAttribute("playlistService", playlistService);
            sce.getServletContext().setAttribute("favouriteService", favoriteService);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error initializing the application", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            Connection connection = DatabaseCollectionUtil.getConnection();
            if (connection != null && !connection.isClosed()) {
                connection.close(); // Закрыть соединение
                System.out.println("Database connection closed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}
