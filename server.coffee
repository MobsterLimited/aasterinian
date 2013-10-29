
handler = (request, res) ->
  url = require 'url'
  url_parts = url.parse request.url, true
  [host, port] = request.headers.host.split(':')
  res.writeHead 200
  cs=fs.readFileSync(__dirname + "/client.coffee", 'utf8')
  cs=cs.replace('$CHANNEL', url_parts.query['channel'])
  cs=cs.replace('$HOST', host)
  cs=cs.replace('$PORT', port)
  res.end coffeeScript.compile(cs)

port = 9090
app = require("http").createServer(handler)
io = require("socket.io").listen(app)
fs = require("fs")
redis = require("redis")
coffeeScript = require 'coffee-script'

app.listen port
redisClient = redis.createClient()
redisClient.on "error", (err) ->
  console.log "error event - " + redisClient.host + ":" + redisClient.port + " - " + err

io.sockets.on "connection", (socket) ->
  socket.on "subscribe", (data) ->
    socket.join data.channel
    redisClient.subscribe data.channel

redisClient.on "message", (channel, message) ->
  resp =
    text: message
    channel: channel

  io.sockets.in(channel).emit 'message', resp

