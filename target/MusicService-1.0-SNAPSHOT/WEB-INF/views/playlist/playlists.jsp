<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/header.jsp" %>

<!-- Main page layout -->
<style>
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

    .text-link {
        color: #ffffff;
        text-decoration: none;
    }

    .text-link:hover {
        text-decoration: underline;
    }

    .alert-warning {
        background-color: rgba(255, 193, 7, 0.9);
        color: white;
    }

    .btn-success {
        background-color: rgba(0, 123, 255, 1);
        border-color: rgba(0, 123, 255, 1);
    }

    .btn-success:hover {
        background-color: rgba(0, 102, 204, 1);
        border-color: rgba(0, 102, 204, 1);
    }

    .playlist-container {
        margin-top: 30px;
    }

    .playlist-card {
        margin-bottom: 20px;
    }

    .playlists-header {
        margin-bottom: 20px;
    }

    .create-playlist-btn {
        margin-top: 20px;
    }
</style>

<body>
    <div class="container mt-5 playlist-container">
        <h2 class="playlists-header">Your Playlists</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-warning">${error}</div>
        </c:if>

        <c:if test="${not empty errorNull}">
            <h2>${errorNull}</h2>
        </c:if>

        <!-- Displaying the playlists -->
        <div class="row">
            <c:forEach var="playlist" items="${playlists}">
                <div class="col-md-4 mb-4">
                    <div class="card playlist-card">
                        <div class="card-header">
                            <h5 class="card-title">${playlist.title}</h5>
                        </div>
                        <div class="card-body">
                            <p class="card-text">This is your playlist. Click below to view or edit it.</p>
                            <a href="/profile/playlists/${playlist.id}" class="btn btn-success">View Playlist</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Button to create new playlist -->
        <div class="create-playlist-btn">
            <a href="${pageContext.request.contextPath}/playlists/create" class="btn btn-primary">Create Playlist</a>
        </div>
    </div>
</body>
