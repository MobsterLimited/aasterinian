
window.Aasterinian=
  connected: false
  host: '$HOST'
  port: '$PORT'
  channel: '$CHANNEL'

  Callback: (data)->
    console.log "To use a custom callback define a function like : Aasterinian.Callback=function(data){...};, data is :"
    console.log data

  LoadSocketIo: ->
    js = document.createElement("script")
    js.type = "text/javascript"
    js.src = "http://#{Aasterinian.host}:#{Aasterinian.port}/socket.io/socket.io.js"
    document.head.appendChild js

  Connect: ->
    socket = io.connect("http://#{Aasterinian.host}:#{Aasterinian.port}")
    socket.on "connect", =>
      socket.emit "subscribe",
        channel: Aasterinian.channel
    socket.on "message", (data) ->
      Aasterinian.Callback(JSON.parse(data.text))
    Aasterinian.connected = true

  TryToConnect: ->
    setTimeout ->
      if io?
        do Aasterinian.Connect
      else
        do Aasterinian.TryToConnect
    , 100

do Aasterinian.LoadSocketIo
do Aasterinian.TryToConnect
