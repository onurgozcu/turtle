const http = require('http');
const server = require('./server');
var mosca = require('mosca');

const app = http.createServer(server);
app.listen(3000);


var settings = {
  port: 1883
};

var moscaServer = new mosca.Server(settings);

moscaServer.on('clientConnected', function(client) {
    console.log('client connected', client.id);
});

// fired when a message is received
moscaServer.on('published', function(packet, client) {
  console.log('Published', packet.payload);
});

moscaServer.on('ready', setup);

// fired when the mqtt server is ready
function setup() {
  console.log('Mosca server is up and running');
}
