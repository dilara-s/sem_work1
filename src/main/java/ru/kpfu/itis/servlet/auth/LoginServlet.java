package ru.kpfu.itis.servlet.auth;

import ru.kpfu.itis.dao.impl.UserDaoImpl;
import ru.kpfu.itis.entity.User;
import ru.kpfu.itis.service.UserService;
import ru.kpfu.itis.util.PasswordUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = LoggerFactory.getLogger(LoginServlet.class);  // Логгер
    private UserService userService;
    private UserDaoImpl userDao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        userService = (UserService) getServletContext().getAttribute("userService");
        userDao = (UserDaoImpl) getServletContext().getAttribute("userDao"); // Инициализация userDao
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        LOGGER.info("Displaying login page.");
        getServletContext().getRequestDispatcher("/WEB-INF/views/login/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email != null && password != null) {
            try {
                LOGGER.info("Attempting login for user: {}", email);

                String hashedPassword = PasswordUtil.encrypt(password);
                boolean chek = userDao.getUsernameAndPassword(email, hashedPassword);

                if (chek) {
                    long userId = userDao.getUserId(email);
                    User user = userDao.getUserById(userId);
                    userService.authUser(user, req, resp);
                    LOGGER.info("User {} successfully logged in.", email);
                    resp.sendRedirect(getServletContext().getContextPath() + "/mainPage");
                } else {
                    LOGGER.warn("Invalid login attempt for user: {}", email);
                    req.setAttribute("error", "Invalid email or password.");
                    getServletContext().getRequestDispatcher("/WEB-INF/views/login/login.jsp").forward(req, resp);
                }
            } catch (SQLException e) {
                LOGGER.error("Database error occurred while authenticating user: {}", email, e);
                throw new ServletException("Database error", e);
            }
        } else {
            LOGGER.warn("Login attempt with empty username or password.");
            req.setAttribute("error", "Please enter both email and password.");
            getServletContext().getRequestDispatcher("/WEB-INF/views/login/login.jsp").forward(req, resp);
        }
    }
}
