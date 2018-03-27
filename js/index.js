"use strict"

const IpfsApi = require("ipfs-api");
const ipfs = IpfsApi();

document.addEventListener("DOMContentLoaded", () => {
  const home = document.getElementById("page_home");
  const view = document.getElementById("page_view");

  const node = document.getElementById("elm");

  if (home)
    home_page(node);

  if (view)
    view_page(node);
});

function home_page(node) {
  const app = Elm.Publish.embed(node);

  app.ports.pub.subscribe(function(obj) {
    const string = JSON.stringify(obj);

    const stored_hash = ipfs.add(Buffer.from(string))
      .catch(error => alert(error))
      .then(file => app.ports.new_hash.send(file[0].hash));
  });
}

function view_page(node) {
  const app = Elm.Retrieve.embed(node);
  const hash = window.location.hash.slice(1);

  ipfs.cat(hash, { buffer: true })
    .catch((error) => window.location.href = "../index.html")
    .then((bio) => {
      const as_string = new TextDecoder("utf-8").decode(bio)
      app.ports.receive_bio.send(as_string)
    });
}
