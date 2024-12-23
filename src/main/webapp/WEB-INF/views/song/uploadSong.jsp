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
    <!-- Upload Song Form -->
    <div class="container mt-5">
        <h2>Upload a New Song</h2>
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header">
                        <h4>Song Details</h4>
                    </div>
                    <div class="card-body">
                        <!-- Form to upload song -->
                        <form method="POST" action="<c:url value="/uploadSong"/>" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="title">Song Title</label>
                                <input type="text" class="form-control" id="title" name="title" required>
                            </div>
                            <div class="form-group">
                                <label for="artist">Artist Name</label>
                                <input type="text" class="form-control" id="artist" name="artist" required>
                            </div>
                            <div class="form-group">
                                <label for="lyrics">Lyrics (Optional)</label>
                                <textarea class="form-control" id="lyrics" name="lyrics" rows="4"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="songFile">Upload Song File</label>
                                <input type="file" class="form-control-file" id="songFile" name="songFile" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Upload Song</button>
                        </form>
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
