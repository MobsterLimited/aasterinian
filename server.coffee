class Aasterinian
  settings: {
    port: 8889
    host: '0.0.0.0'
    redisPort: 6379
    redisHost: '127.0.0.1'
  }

  Help: ->
    console.log "
Aasterinian\n
-----------\n
    \n
   -p | --listen-port   The port where we will listen for incoming requests (default 8889)\n
   -b | --bind          The ip to bind on (default 0.0.0.0)\n
   -r | --redis-port    The port where redis listens on (default 6379)\n
   -s | --redis-server  The ip where we can reach redis (default 127.0.0.1)\n
    \n
Example:\n
coffee server.coffee -n -b 192.168.0.1 -p 8080 -s 192.168.0.2 -r 6380\n
        "
    process.exit(1)
  ParseOptions: ->
    i=0
    for arg in process.argv
      do @Help if (arg=="-h" || arg=="--help")
      @settings.port=parseInt(process.argv[i+1]) if (arg=="-p" || arg=="--listen-port")
      @settings.host=process.argv[i+1] if (arg=="-b" || arg=="--bind")
      @settings.redisPort=parseInt(process.argv[i+1]) if (arg=="-r" || arg=="--redis-port")
      @settings.redisHost=process.argv[i+1] if (arg=="-s" || arg=="--redis-server")
      i++

  RequestHandler = (request, res) ->
    url = require 'url'
    url_parts = url.parse request.url, true
    [host, port] = request.headers.host.split(':')
    res.writeHead 200
    cs=fs.readFileSync(__dirname + "/client.coffee", 'utf8')
    cs=cs.replace('$CHANNEL', url_parts.query['channel'])
    cs=cs.replace('$HOST', host)
    cs=cs.replace('$PORT', port)
    res.end coffeeScript.compile(cs)

  Run: ->
    app.listen(@settings.port, @settings.host)
    redisClient = redis.createClient(@settings.redisPort, @settings.redisHost)
    redisClient.on "error", (err) ->
      console.log "error event - " + redisClient.host + ":" + redisClient.port + " - " + err

    console.log "   Aasterinian started."
    console.log "   Connected to redis on: #{@settings.redisHost}:#{@settings.redisPort}"
    console.log "   Listening for requests on port #{@settings.port}"

    io.sockets.on "connection", (socket) ->
      socket.on "subscribe", (data) ->
        socket.join data.channel
        redisClient.subscribe data.channel

    redisClient.on "message", (channel, message) ->
      resp =
        text: message
        channel: channel

      io.sockets.in(channel).emit 'message', resp


  constructor: ->
    do @ParseOptions
    do @Run

  app=require("http").createServer(RequestHandler)
  io=require("socket.io").listen(app)
  fs=require("fs")
  redis=require("redis")
  coffeeScript=require 'coffee-script'

aasterian=new Aasterinian


