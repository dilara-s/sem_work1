<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/style/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/style/bootstrap.css'/>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

    <style>
        body {
            background-image: url('https://avatars.mds.yandex.net/i?id=43eaf4c2fd08013f09a1f1a2923a6c00_l-5603028-images-thumbs&n=13');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: black;
            font-family: Arial, sans-serif;
        }

        .container.profile-container {
            max-width: 900px;
            margin: 50px auto;
            background: rgba(255, 255, 255, 1);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .card {
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background-color: rgba(102, 0, 153, 1) !important;
            color: white;
        }

        .btn-primary {
            background-color: rgba(102, 0, 153, 1);
            border-color: rgba(102, 0, 153, 1);
        }

        .btn-primary:hover {
            background-color: rgba(128, 0, 128, 1);
            border-color: rgba(128, 0, 128, 1);
        }

        .btn-danger {
            background-color: red;
            border-color: red;
        }

        .btn-danger:hover {
            background-color: darkred;
            border-color: darkred;
        }

        .avatar-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
        }

        .text-link {
            color: #ffffff;
            text-decoration: none;
        }

        .text-link:hover {
            text-decoration: underline;
        }

        .modal-content {
            border-radius: 15px;
        }

        .btn-custom {
            background-color: rgba(102, 0, 153, 1);
            border-color: rgba(102, 0, 153, 1);
        }

        .btn-custom:hover {
            background-color: rgba(128, 0, 128, 1);
            border-color: rgba(128, 0, 128, 1);
        }
    </style>

</head>
<body>

<!-- Навигационная панель -->
<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <a class="navbar-brand" href="<c:url value='/mainPage' />">
            <img src="<c:url value='https://res.cloudinary.com/dsyuw4byo/image/upload/v1734909254/logo_zkiwyg.webp' />" alt="Logo" width="50" height="50">
        </a>
        <a class="navbar-brand" href="<c:url value='/mainPage' />">MusicService</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            </ul>
            <c:if test="${user != null}">
                <ul class="nav nav-tabs">
                    <li class="nav-item dropdown">
                        <ul class="dropdown-menu dropdown-menu-end" >
                            <li><a class="dropdown-item" href="<c:url value='/profile'/>">Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<c:url value='/logout'/>" data-bs-toggle="modal" data-bs-target="#signOutModal">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </c:if>

            <c:if test="${user == null}">
                <nav class="navbar bg-body-tertiary">
                    <form class="container-fluid justify-content-start">
                        <a class="btn btn-outline-success me-2" href="<c:url value='/login'/>">Login</a>
                        <a class="btn btn-outline-success me-2" href="<c:url value='/register'/>">Register</a>
                    </form>
                </nav>
            </c:if>

            <c:if test="${not empty user}">
                <nav class="navbar bg-body-tertiary">
                    <form class="container-fluid justify-content-start">
                        <a class="btn btn-outline-success me-2" href="<c:url value='/profile'/>">Profile</a>
                        <a class="btn btn-outline-success me-2" href="<c:url value='/logout'/>">Выйти</a>
                    </form>
                </nav>
            </c:if>
        </div>
    </div>
</nav>

<!-- Контент страницы профиля -->
<div class="container profile-container">
    <div class="profile-header text-center">
        <h2>Welcome, ${user.username}!</h2>
        <img src="${user.avatarImage}" alt="Avatar" class="avatar-image">
    </div>

    <div class="text-center mb-4">
        <button class="btn btn-custom" onclick="window.location.href='${pageContext.request.contextPath}/profile/playlists'">Playlists</button>
        <button class="btn btn-custom" onclick="window.location.href='${pageContext.request.contextPath}/favourites'">Favourite Songs</button>
        <button class="btn btn-custom" onclick="window.location.href='${pageContext.request.contextPath}/profile/edit'">Edit Profile</button>
    </div>

    <!-- Удаление аккаунта -->
    <div class="text-center mb-4">
        <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">Delete Account</button>
    </div>

    <!-- Модальное окно для удаления аккаунта -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Account Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete your account? This action is irreversible.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="confirm" value="yes">
                        <button type="submit" class="btn btn-danger">Yes, Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="tab-content">
        <div class="tab-pane active" id="personal">
            <h4>Personal Information</h4>
            <p><strong>Email:</strong> ${user.email}</p>
            <p><strong>Username:</strong> ${user.username}</p>
        </div>
        <div class="tab-pane" id="account">
            <h4>Account Settings</h4>
            <p><strong>Password:</strong> ********</p> <!-- Don't show password -->
            <p><strong>Avatar:</strong> <img src="${user.avatarImage}" alt="Avatar" class="avatar-image"></p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
