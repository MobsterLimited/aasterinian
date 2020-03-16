((root, factory) ->
  if typeof define is "function" and define.amd
    define [], factory
  else
    root.Aasterinian = factory()
  return
) this, () ->

    connected: false
    host: '$HOST'
    port: '$PORT'
    channel: '$CHANNEL'
    socket: null
    callbacks: {
      default: (data)->
        console.log "To use a custom callback define a function like : Aasterinian.Callback=function(data){...};, data is :"
        console.log data
    }

    Activate: ->
      do Aasterinian.LoadSocketIo unless typeof define is "function" and define.amd
      do Aasterinian.TryToConnect

    LoadSocketIo: ->
      js = document.createElement("script")
      js.type = "text/javascript"
      js.src = "/socket.io/socket.io.js"
      document.head.appendChild js

    Connect: ->
      Aasterinian.socket=io.connect("#{window.location.protocol}//#{window.location.host}")
      Aasterinian.socket.on "message", (data) ->
        if Aasterinian.callbacks[data.channel]?
          Aasterinian.callbacks[data.channel] JSON.parse(data.text)
        else
          Aasterinian.callbacks.default JSON.parse(data.text)

      Aasterinian.Subscribe @channel, @Callback unless @channel=='undefined'
      Aasterinian.connected = true

    Subscribe: (channel, callback=null)->
      Aasterinian.callbacks[channel]=callback if callback?
      if Aasterinian.socket?.emit
        Aasterinian.socket.emit "subscribe", channel: channel
      else
        setTimeout ->
          Aasterinian.TryToConnect unless Aasterinian.socket?
          console.log "retrying subscribe"
          Aasterinian.Subscribe channel
        ,100

      null

    TryToConnect: ->
      setTimeout ->
        if io?
          do Aasterinian.Connect
        else
          do Aasterinian.TryToConnect
      , 100

if (Aasterinian?)
  do Aasterinian.Activate
