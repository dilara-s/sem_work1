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
    <div class="container mt-5">
        <h2>Your Favourite Songs</h2>
        <div class="row">
            <c:forEach var="song" items="${favoriteSongs}">
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <!-- Display song cover image -->
                        <img src="<c:url value='${song.coverImageUrl}'/>" class="card-img-top" alt="${song.title}">
                        <div class="card-body">
                            <!-- Song title and artist -->
                            <h5 class="card-title">${song.title}</h5>
                            <p class="card-text">${song.artist}</p>

                            <!-- Play button to play the song -->
                            <button class="btn btn-success mt-2 play-btn" data-audio-url="${song.audioUrl}" data-song-id="${song.id}">Play</button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Audio player and controls -->
    <div class="container mt-4">
        <audio id="audio-player" controls>
            <source id="audio-source" type="audio/mp3">
            Ваш браузер не поддерживает элемент audio.
        </audio>

        <!-- Player controls -->
        <div id="player-controls" class="mt-3">
            <button id="prev-song" class="btn btn-secondary">Prev</button>
            <button id="play-pause" class="btn btn-success">Play</button>
            <button id="next-song" class="btn btn-secondary">Next</button>
        </div>

        <p id="current-song-title">Now Playing: </p>
    </div>

    <!-- Include JavaScript file -->
    <script src="audioPlayer.js"></script>

</body>
