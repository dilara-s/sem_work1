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
                        <img src="<c:url value='${song.coverImage}'/>" class="card-img-top" alt="${song.title}">
                        <div class="card-body">
                            <!-- Song title and artist -->
                            <h5 class="card-title">${song.title}</h5>
                            <p class="card-text">${song.artist}</p>

                            <!-- Play button to play the song -->
                            <button class="btn btn-success mt-2 play-btn"
                                    data-audio-url="${song.url}"
                                    data-song-id="${song.id}">Play</button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>



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

</body>
