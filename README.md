Aasterinian
===========

We've been using Juggernaut (https://github.com/maccman/juggernaut) for quite some while and it served it purpose very well for us.

Though since it has been deprecated and not working so on node higher then 8.0 we conceived our own replacement named Aasterinian
.

> <div style="float: left"><img src="https://github.com/Govannon/aasterinian/logo.png" /></div> Aasterinian is the draconic deity who serves as Io's messenger. Her symbol is a grinning dragon's head. Aasternian appears as a huge brass dragon who is always grinning.
>> http://en.wikipedia.org/wiki/Dragon_deities#Aasterinian


The usage is quite simple, to run it use :

> coffee server.coffee -n

And then in your html you just include the following :


> &lt;script type='application/javascript' src='http://127.0.0.1:9090/?channel=mychannel' /&gt;

Whenever a message (as JSON) is being published via redis to the mychannel prefix, it will be pushed to the browser. You can create a javascript callback to handle the data (which is in JSON) like :

> Aasterinian.Callback(data)

Dependencies :

* Node
* Socket.io
* Coffee
* Redis