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

    .playlist-container {
        margin-top: 30px;
    }

    .playlist-header {
        margin-bottom: 20px;
    }

    .song-card {
        margin-bottom: 15px;
    }

    .play-btn {
        background-color: rgba(0, 123, 255, 1);
        border-color: rgba(0, 123, 255, 1);
    }

    .play-btn:hover {
        background-color: rgba(0, 102, 204, 1);
        border-color: rgba(0, 102, 204, 1);
    }

    .audio-player {
        margin-top: 30px;
    }
</style>

<body>
    <div class="container mt-5 playlist-container">
        <h2 class="playlist-header">${playlist.title}</h2>

        <!-- Display playlist cover image if exists -->
        <c:if test="${not empty playlist.coverImageUrl}">
            <img src="<c:url value='${playlist.coverImageUrl}'/>" alt="${playlist.title}" class="img-fluid">
        </c:if>

        <!-- Display playlist description if exists -->
        <p class="mt-3">${playlist.description}</p>

        <!-- Display songs in the playlist -->
        <h4 class="mt-4">Songs in this Playlist:</h4>
        <div class="row">
            <c:forEach var="song" items="${songs}">
                <div class="col-md-4 mb-4">
                    <div class="card song-card">
                        <div class="card-body">
                            <h5 class="card-title">${song.title}</h5>
                            <p class="card-text">${song.artist}</p>

                            <!-- Button to play song -->
                            <button class="btn btn-success play-btn" data-song-id="${song.id}" data-audio-url="${song.url}">Play</button>
                            <a href="/songDetails?id=${song.id}" class="btn btn-info mt-2">Song Details</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Audio player -->
        <div class="audio-player">
            <audio id="audio-player" controls>
                <source id="audio-source" type="audio/mp3">
                Ваш браузер не поддерживает элемент audio.
            </audio>

            <div id="player-controls" class="mt-3">
                <button id="prev-song" class="btn btn-secondary">Prev</button>
                <button id="play-pause" class="btn btn-success">Play</button>
                <button id="next-song" class="btn btn-secondary">Next</button>
            </div>

            <p id="current-song-title">Now Playing: </p>
        </div>
    </div>

    <!-- JavaScript for handling audio player functionality -->
    <script src="audioPlayer.js"></script>
</body>
