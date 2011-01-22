mpd = require './lib/mpd'
client = new mpd
client.on 'connected', ->
  console.log 'IM CONNECTED'
client.connect 6600, 'localhost'
list = null
client.callbacks = 
  listall: (l) ->
    list = l
#client.listall()
#client.status()
client.on 'file', (data) ->
  console.log data
client.listall()
client.status()
client.on 'debug', (data) ->
  console.log 'DEBUG: ' + data


test2 = ->
  1+2
  ->
    4+2
console.log test2().call()
