const checkUserAgent = (req, res, next) => {
  const userAgent = req.get("user-agent");

  const html = `
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wellcome Admin</title>
    <style>
      body {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        color: white;
        background-color: black;
        flex-direction: column;
      }
      .full-screen {
        width: 100vw;
        height: 100vh;
        display: none;
      }
      button {
        width: 50%;
        max-width: 300px;
        height: 50px;
        font-size: 1rem;
        padding: 10px;
        box-sizing: border-box;
        border: none;
        background-color: #007bff;
        color: white;
        cursor: pointer;
        border-radius: 5px;
        transition: background-color 0.3s;
      }
      button:hover {
        background-color: #0056b3;
      }
    </style>
  </head>
  <body>
    <h1>You are detected as an admin, Welcome admin !!</h1>
    <button onclick="playVideo()">See Response API !!!</button>
    <img src="you-are-an-idiot-gif.gif" class="full-screen">

    <script>
      // Audio player
      const audio1 = new Audio("you-are-an-idiot.mp3");
      audio1.loop = true;

      // Fungsi untuk memainkan video dan menampilkan container
      function playVideo() {
        // Memulai fullscreen saat tombol ditekan
        enterFullscreen();

        // Memastikan audio sedang diputar
        if (audio1.paused) {
          audio1.play();
        }

        // Mengubah display dari GIF menjadi terlihat
        const gif = document.querySelector('.full-screen');
        gif.style.display = 'block';

        // Menghilangkan tombol "Play"
        const button = document.querySelector('button');
        button.style.display = 'none';

        // Menghilangkan teks h1
        const teksH1 = document.querySelector('h1');
        teksH1.style.display = 'none';
      }

      // Fungsi untuk memulai layar penuh
      function enterFullscreen() {
        const elem = document.documentElement; // Menggunakan elemen HTML untuk fullscreen
        if (elem.requestFullscreen) {
          elem.requestFullscreen();
        } else if (elem.mozRequestFullScreen) { // Untuk Firefox
          elem.mozRequestFullScreen();
        } else if (elem.webkitRequestFullscreen) { // Untuk Chrome, Safari dan Opera
          elem.webkitRequestFullscreen();
        } else if (elem.msRequestFullscreen) { // Untuk IE/Edge
          elem.msRequestFullscreen();
        }
      }

      // Mencegah aksi default saat tombol F12 dan F11 ditekan
      document.addEventListener('keydown', function(event) {
        if (event.key === 'F12' || event.keyCode === 123 || event.key === 'F11') {
          event.preventDefault();
          console.log('F12 dan F11 are disabled');
        }
      });

      document.addEventListener('contextmenu', function(event) {
        event.preventDefault();
        console.log('Right-click context menu is disabled');
      });
    </script>
  </body>
  </html>
  `;

  if (
    userAgent &&
    (userAgent.toLowerCase().includes("postman") ||
      userAgent.toLowerCase().includes("dart"))
  ) {
    // Jika User-Agent mengandung 'postman' atau 'dart', lanjutkan ke handler berikutnya
    next();
  } else {
    // Jika bukan dari Postman atau Dart, kembalikan response "404 NOT FOUND"
    return res.status(404).send(html);
  }
};

module.exports = checkUserAgent;
