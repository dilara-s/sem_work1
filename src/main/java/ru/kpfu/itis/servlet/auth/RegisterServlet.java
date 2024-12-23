package ru.kpfu.itis.servlet.auth;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import ru.kpfu.itis.dao.impl.UserDaoImpl;
import ru.kpfu.itis.entity.User;
import ru.kpfu.itis.service.UserService;
import ru.kpfu.itis.util.PasswordUtil;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(RegisterServlet.class);
    private UserService userService;
    private UserDaoImpl userDao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        userService = (UserService) getServletContext().getAttribute("userService");
        userDao = (UserDaoImpl) getServletContext().getAttribute("userDao");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        getServletContext().getRequestDispatcher("/WEB-INF/views/login/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");

        if(username == null || password == null || email == null) {
            req.setAttribute("message", "All fields are required");
            getServletContext().getRequestDispatcher("/WEB-INF/views/login/register.jsp").forward(req, resp);
            return;
        }

        try {
            String encryptedPassword = PasswordUtil.encrypt(password);

            boolean check = userDao.getUsernameAndPassword(email, encryptedPassword);
            log.info(Boolean.toString(check));
            if (check) {
                log.info("уже есть в базе данных");
                req.setAttribute("message", "User already exists");
                getServletContext().getRequestDispatcher("/WEB-INF/views/login/register.jsp").forward(req, resp);
            } else {
                log.info("добавляем в базу данных");
                User newUser = new User(username, email, encryptedPassword);
                userDao.addUser(newUser);
                long userId = userDao.getUserId(email);
                User user = userDao.getUserById(userId);
                userService.authUser(user, req, resp);
                req.setAttribute("message", "Registration successful");
                resp.sendRedirect(req.getContextPath() + "/mainPage");
            }
        } catch (SQLException e) {
            req.setAttribute("message", "Error during registration. Try again.");
            getServletContext().getRequestDispatcher("/WEB-INF/views/login/register.jsp").forward(req, resp);
        }
    }

}
