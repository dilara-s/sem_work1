<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/header.jsp" %>

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

    .create-playlist-container {
        margin-top: 30px;
    }

    .playlist-header {
        margin-bottom: 20px;
    }

    .song-checkbox {
        margin-bottom: 10px;
    }

    .play-btn {
        background-color: rgba(0, 123, 255, 1);
        border-color: rgba(0, 123, 255, 1);
    }

    .play-btn:hover {
        background-color: rgba(0, 102, 204, 1);
        border-color: rgba(0, 102, 204, 1);
    }
</style>

<body>
    <div class="container mt-5 create-playlist-container">
        <h2 class="playlist-header">Create New Playlist</h2>

        <!-- Show error if there's any -->
        <c:if test="${not empty error}">
            <div class="alert alert-warning">
                ${error}
            </div>
        </c:if>

        <!-- Playlist Creation Form -->
        <form action="${pageContext.request.contextPath}/playlists/create" method="post">
            <!-- Playlist Name -->
            <div class="form-group">
                <label for="name">Playlist Name</label>
                <input type="text" id="name" name="name" class="form-control" required>
            </div>

            <!-- Playlist Description -->
            <div class="form-group">
                <label for="description">Playlist Description</label>
                <textarea id="description" name="description" class="form-control" rows="3" required></textarea>
            </div>


            <!-- Select Songs for Playlist -->
            <h4>Select Songs</h4>
            <div class="form-group">
                <c:forEach var="song" items="${songs}">
                    <div class="form-check song-checkbox">
                        <input type="checkbox" class="form-check-input" id="song-${song.id}" name="songIds" value="${song.id}">
                        <label class="form-check-label" for="song-${song.id}">${song.title} - ${song.artist}</label>
                    </div>
                </c:forEach>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary">Create Playlist</button>
        </form>
    </div>
</body>
