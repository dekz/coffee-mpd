mpd = require './lib/mpd'
client = new mpd
client.on 'connect', ->
  console.log 'IM CONNECTED'
  client.on 'file', (data) ->
    console.log 'some file ' + data
  client.listall()
  client.status()
client.connect 6600, 'localhost'

#client.on 'file', (data) ->
#  console.log data
#client.listall()
#client.status()
#client.on 'debug', (data) ->
#  console.log 'DEBUG: ' + data


test2 = ->
  1+2
  ->
    4+2
console.log test2().call()
