var fs = require('fs');
var net = require("net");
var express = require('express');
var app = express()
var http = require('http').createServer(app);
var io = require('socket.io')(http);

let rawdata = fs.readFileSync('variables.json');

let jsondata = JSON.parse(rawdata);
participantId = jsondata["participant_id"];
modeId = jsondata["mode_id"];
var nodeClient;
// app.use(express.static('static'))

function getConn(connName){

    var option = {
        host:'127.0.0.1',
        port: 3000,
    }

    // Create TCP client.
    var client = net.connect(option, function () {
        console.log('Connection name : ' + connName);
        console.log('Connection local address : ' + client.localAddress + ":" + client.localPort);
        console.log('Connection remote address : ' + client.remoteAddress + ":" + client.remotePort);
    });

    // client.setEncoding('utf8');

    // When receive server send back data.
   // client.on('data', function (data) {
   //     console.log('Server return data : ' + data);
   //  });

    // When connection disconnected.
    client.on('end',function () {
        console.log('Client socket disconnect. ');
    });

    client.on('timeout', function () {
        console.log('Client connection timeout. ');
    });

    client.on('error', function (err) {
        console.error(JSON.stringify(err));
    });

    return client;
}


io.on('connection', function(socket){
  socket.on('typing', function(msg){
    if(msg=="stop"){
        nodeClient.write("complete");
        process.exit()
    }
    else
        nodeClient.write("start");
  });
});


app.get('/', function(req, res){
    nodeClient = getConn('Node');
    startTime = new Date();
    t = startTime.getFullYear()+"-"+startTime.getMonth()+"-"+startTime.getDate()+"-"+startTime.getHours()+"-"+startTime.getMinutes()+"-"+startTime.getSeconds();
    nodeClient.write(participantId+"_"+modeId+"_"+t);
    res.sendFile(__dirname+'/index.html');
});
app.use('/static', express.static('static'))


http.listen(8000, function(){
  console.log('listening on *:8000');
});
