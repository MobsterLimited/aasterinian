Aasterinian
===========

We've been using Juggernaut (https://github.com/maccman/juggernaut) for quite some time and it served it purpose very well.

Though since it has been deprecated and not working so on node higher then 8.0 we conceived our own replacement named Aasterinian
.


> Aasterinian is the draconic deity who serves as Io's messenger. Her symbol is a grinning dragon's head. Aasternian appears as a huge brass dragon who is always grinning. 
    
http://en.wikipedia.org/wiki/Dragon_deities#Aasterinian

<div style="clear: both">

The usage is quite simple, to run it use :

    coffee server.coffee -n

By default it will use port 8889, if you want to use a custom port simply give the port number as last argument like : 

    coffee server.coffee -n 8080

In your html you just include the following :

    <script type='application/javascript' src='http://127.0.0.1:9090/?channel=mychannel'>

Whenever a message (as JSON) is being published via redis to the mychannel prefix, it will be pushed to the browser. You can create a javascript callback to handle the data (which is in JSON) like :

    Aasterinian.Callback(data)

Dependencies :

* Node
* Socket.io
* Coffee
* Redis