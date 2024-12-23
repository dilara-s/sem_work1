<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <script src="<c:url value="/js/bootstrap.min.js"/>"></script>
    <script src="<c:url value="/js/bootstrap.bundle.min.js"/>"></script>


    <link rel="stylesheet" href="<c:url value="/style/bootstrap.css"/>">
    <link rel="stylesheet" href="<c:url value="/style/_nav.scss"/>">
    <link rel="stylesheet" href="<c:url value="/style/main.css"/>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <nav class="navbar bg-body-tertiary">
            <div class="container">
                <a class="navbar-brand" href="<c:url value='/mainPage' />">
                    <img src="<c:url value="https://res.cloudinary.com/dsyuw4byo/image/upload/v1734909254/logo_zkiwyg.webp"/> " alt="Bootstrap" width="50" height="50">
                </a>
            </div>
        </nav>
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

<div class="contents">
