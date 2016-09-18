'use strict'

var container = document.getElementById('container');

var app = Elm.Main.embed(container);

var userName = "userName";

app.ports.storage.subscribe(function(data) {
    localStorage.setItem(userName, data);
});

var currentUserName = localStorage.getItem(userName);
app.ports.storageInput.send(currentUserName);
