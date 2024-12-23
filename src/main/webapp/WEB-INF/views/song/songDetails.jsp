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

    .song-details {
        margin-top: 20px;
    }
</style>

<body>
    <!-- Song Details Page -->
    <div class="container mt-5 song-details">
        <h2>Song Details</h2>
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header">
                        <h4>${song.title} by ${song.artist}</h4>
                    </div>
                    <div class="card-body">
                        <!-- Display song cover image -->
                        <img src="<c:url value='${song.coverImageUrl}'/>" class="card-img-top" alt="${song.title}" style="max-height: 300px; object-fit: cover;">

                        <h5 class="mt-4">Song Lyrics</h5>
                        <p>
                            <c:if test="${not empty song.lyrics}">
                                ${song.lyrics}
                            </c:if>
                            <c:if test="${empty song.lyrics}">
                                No lyrics available.
                            </c:if>
                        </p>

                        <!-- Audio player to play the song -->
                        <audio id="audio-player" controls>
                            <source id="audio-source" src="${song.url}" type="audio/mp3">
                            Your browser does not support the audio element.
                        </audio>

                        <br><br>
                        <!-- Delete song form -->
                        <form method="post" action="/songDetails" onsubmit="return confirm('Are you sure you want to delete this song?');">
                            <input type="hidden" name="id" value="${song.id}">
                            <button type="submit" class="btn btn-danger">Delete Song</button>
                        </form>

                        <br><br>
                        <a href="/songs" class="btn btn-primary">Back to Song List</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Display Errors or Success -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-warning mt-4">${errorMessage}</div>
    </c:if>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success mt-4">${successMessage}</div>
    </c:if>

</body>
