document.querySelector("form").addEventListener("submit", function (event) {
    event.preventDefault(); // Предотвращаем стандартное действие формы

    const form = event.target;
    const formData = new FormData();

    // Получаем данные из полей формы
    const title = document.getElementById("title").value;
    const artist = document.getElementById("artist").value;
    const lyrics = document.getElementById("lyrics").value;
    const songFile = document.getElementById("songFile").files[0];

    console.log(songFile)

    // Добавляем данные в FormData
    formData.append("title", title);
    formData.append("artist", artist);
    formData.append("lyrics", lyrics);
    formData.append("songFile", songFile);

    // Отправляем запрос
    fetch('/uploadSong', {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if (!response.ok) {
                throw new Error("Ошибка при загрузке песни");
            }
            return response.json(); // Ожидаем JSON от сервера
        })
        .then(data => {
            if (data.success) {
                alert("Песня успешно загружена!");
            } else {
                alert("Ошибка загрузки: " + data.message);
            }
        })
        .catch(error => {
            console.error("Ошибка:", error);
            alert("Произошла ошибка при загрузке песни.");
        });
});
