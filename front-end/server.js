/*
  This is a basic server that delivers the elm app to your
  browser like it was being run on a deployed host.
  Basically it serves static files from `public/` and routes
  all other paths to `public/index.html`

*/

const express = require('express');
const app = express();
const port = process.env.APP_FE_LISTEN_PORT || 5000;
const host = process.env.APP_FE_LISTEN_ADDRESS || '0.0.0.0';

const currentDirectory = process.cwd();

app.use(express.static(currentDirectory + '/public/'));

function wrlog(msg) {
  console.log((new Date()).toISOString() + ": " + msg);
}

app.get('/*', (req, res) => {
  res.sendFile(
    currentDirectory + "/public/index.html",
    {
      headers:
      {
        'Content-Type': 'text/html; charset=UTF-8'

      }
    }
  );
});

wrlog("Running in " + currentDirectory);

app.listen(port, host, () => {
  wrlog(`Listenning on http://${host}:${port}`);
});



