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
        console.log "To use a custom callback define a function like : @Callback=function(data){...};, data is :"
        console.log data
    }

    Activate: ->
      do @LoadSocketIo
      do @TryToConnect

    LoadSocketIo: ->
      js = document.createElement("script")
      js.type = "text/javascript"
      js.src = "http://#{@host}:#{@port}/socket.io/socket.io.js"
      document.head.appendChild js

    Connect: ->
      @socket=io.connect("http://#{@host}:#{@port}")
      @socket.on "message", (data) ->
        if @callbacks[data.channel]?
          @callbacks[data.channel] JSON.parse(data.text)
        else
          @callbacks.default JSON.parse(data.text)

      @Subscribe @channel, @Callback unless @channel=='undefined'
      @connected = true

    Subscribe: (channel, callback=null)->
      @callbacks[channel]=callback if callback?
      if @socket?.emit
        @socket.emit "subscribe", channel: channel
      else
        setTimeout ->
          console.log "retrying subscribe"
          @Subscribe channel
        ,100



      null

    TryToConnect: ->
      setTimeout ->
        if io?
          do @Connect
        else
          do @TryToConnect
      , 100

if (Aasterinian?)
  console.log "Activating Aasterinian"
  do @Activate

