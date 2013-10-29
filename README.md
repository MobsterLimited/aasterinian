Aasterinian
===========

We've been using Juggernaut (https://github.com/maccman/juggernaut) for quite some time and it served it purpose very well.

Though since it has been deprecated and not working so on node higher then 8.0 we conceived our own replacement named Aasterinian
.


> Aasterinian is the draconic deity who serves as Io's messenger. Her symbol is a grinning dragon's head. Aasternian appears as a huge brass dragon who is always grinning. 
    
http://en.wikipedia.org/wiki/Dragon_deities#Aasterinian

**Usage**

The usage is quite simple, to run it use :

    coffee server.coffee -n

By default it will use port 8889, if you want to use a custom port simply give the port number as last argument like : 

    coffee server.coffee -n 8080

In your html you just include the following :

    <script type='application/javascript' src='http://127.0.0.1:9090'>

To subscribe immediately to a channel add the param channel=myChannel like 

    <script type='application/javascript' src='http://127.0.0.1:9090/?channel=myChannel'>


Whenever a message (as JSON) is being published via redis to the mychannel prefix, it will be pushed to the browser. If no callbacks are specified , it will call the default callback. You can change the default callback using : 

    Aasterinian.callbacks.default=function(data){...};

**Custom callbacks for channel**

To register on multiple channels with their own callbacks you can use : 

    Aasterinian.Subscribe('secondChannel', function(data){...);});
    
**Dependencies** :

* Node
* Socket.io
* Coffee
* Redis

**Example index.html**

    <html>
      <head>
        <script type="application/javascript" src="http://localhost:8888/?channel=firstChannel"></script>
        <script>
            Aasterinian.callbacks.default=function(data){console.log(data);};
            Aasterinian.Subscribe('secondChannel', function(data){alert(data);});
        </script>
    </head>
</html>
