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
        color: #000000;
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

    <!-- Search form to search for songs -->
    <div class="container mt-5">

       <form method="get" action="<c:url value='/mainPage'/>" class="d-flex mb-4">
           <input class="form-control" type="text" name="search" placeholder="Search songs..."
            aria-label="Search" value="${searchQuery != null ? searchQuery : ''}">
           <button class="btn btn-primary ml-2" type="submit">Search</button>
            <button class="btn btn-secondary ml-2" type="button"
            onclick="window.location.href='<c:url value='/mainPage'/>';">Reset</button>
        </form>




        <c:if test="${not empty user}">
          <a href="<c:url value="/uploadSong"/>" class="btn btn-primary">Upload Song</a>
        </c:if>

        <div class="row">
            <c:forEach var="song" items="${songs}">
                <div class="col-md-4 mb-4">
                    <div class="card song-card">


                        <img src="<c:url value='${song.coverImage}'/>" class="card-img-top" alt="${song.title}">

                        <div class="card-body">
                            <!-- Song title and artist -->
                            <h5 class="card-title">${song.title}</h5>
                            <p class="card-text">${song.artist}</p>

                            <!-- If user is not logged in, disable certain actions -->
                            <c:if test="${empty user}">
                                <a href="#" class="btn btn-secondary disabled" data-toggle="tooltip" title="You need to log in to add to favorites">Add to Favorites</a>
                            </c:if>

                            <!-- If user is logged in, show options to add to favorites and go to profile -->
                            <c:if test="${not empty user}">
                                <c:if test="${!favouriteDao.isFavorite(user.getId(), song.id)}">
                                    <form action="<c:url value="/favourites"/>" method="post">
                                        <input type="hidden" name="songId" value="${song.id}">
                                        <button type="submit" name="action" value="add" class="btn btn-warning">Add to Favorites</button>
                                    </form>
                                </c:if>

                                <c:if test="${favouriteDao.isFavorite(user.getId(), song.id)}">
                                    <form action="<c:url value="/favourites"/>" method="post">
                                        <input type="hidden" name="songId" value="${song.id}">
                                        <button type="submit" name="action" value="add" class="btn btn-primary">Remove to Favorites</button>
                                    </form>
                                </c:if>


                            </c:if>


                            <button class="btn btn-success mt-2 play-btn"
                                    data-audio-url="${song.url}"
                                    data-song-id="${song.id}">Play</button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
<!-- Hidden Audio Player -->
<audio id="audio-player" controls style="display:none">
    <source id="audio-source" type="audio/mp3">
    Your browser does not support the audio element.
</audio>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const playButtons = document.querySelectorAll('.play-btn');
        const audioPlayer = document.getElementById('audio-player');
        const audioSource = document.getElementById('audio-source');
        let currentlyPlayingButton = null;

        // Add event listener to each play button
        playButtons.forEach(function (button) {
            button.addEventListener('click', function () {
                const songUrl = this.getAttribute('data-audio-url');
                const songId = this.getAttribute('data-song-id');

                if (currentlyPlayingButton === this) {
                    // If the same button is clicked, toggle play/pause
                    if (!audioPlayer.paused) {
                        audioPlayer.pause();
                        this.classList.remove('btn-danger');
                        this.classList.add('btn-success');
                        this.innerText = 'Play';
                    } else {
                        audioPlayer.play();
                        this.classList.remove('btn-success');
                        this.classList.add('btn-danger');
                        this.innerText = 'Pause';
                    }
                    return;
                }

                // If a different button is clicked, stop current playback
                if (currentlyPlayingButton) {
                    currentlyPlayingButton.classList.remove('btn-danger');
                    currentlyPlayingButton.classList.add('btn-success');
                    currentlyPlayingButton.innerText = 'Play';
                }

                // Set the audio source to the song's URL
                audioSource.src = songUrl;

                // Load and play the audio
                audioPlayer.load();
                audioPlayer.play();

                // Update UI for the current button
                this.classList.remove('btn-success');
                this.classList.add('btn-danger');
                this.innerText = 'Pause';

                // Set the current button as the active one
                currentlyPlayingButton = this;

                // When the audio ends, reset the button to Play
                audioPlayer.onended = () => {
                    this.classList.remove('btn-danger');
                    this.classList.add('btn-success');
                    this.innerText = 'Play';
                    currentlyPlayingButton = null;
                };
            });
        });
    });

</script>

<%--    <!-- Audio player and controls -->--%>
<%--    <div class="container mt-4">--%>
<%--        <!-- Audio player -->--%>
<%--        <audio id="audio-player" controls>--%>
<%--            <source id="audio-source" type="audio/mp3">--%>
<%--            Ваш браузер не поддерживает элемент audio.--%>
<%--        </audio>--%>

<%--        <!-- Player controls -->--%>
<%--        <div id="player-controls" class="mt-3">--%>
<%--            <button id="prev-song" class="btn btn-secondary" onclick="prevSong()">Prev</button>--%>
<%--            <button id="play-pause" class="btn btn-success">Play</button>--%>
<%--            <button id="next-song" class="btn btn-secondary" onclick="nextSong()">Next</button>--%>
<%--        </div>--%>

<%--        <p id="current-song-title">Now Playing: </p>--%>
<%--    </div>--%>
    <!-- Include JavaScript file -->
<%--    <script src="audioPlayer.js"></script>--%>
</body>