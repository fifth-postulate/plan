(function(){
    var app = Elm.Main.init({
        node: document.getElementById('plan')
    });

    // Until elm/websocket is released.
    var socket = new WebSocket('ws://localhost:8326');
    socket.addEventListener('message', function(event){
        app.ports.candidate.send(event.data);
    });
})();
