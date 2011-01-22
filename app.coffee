mpd = require './lib/mpd'
client = new mpd
client.on 'connect', ->
  console.log 'IM CONNECTED'
  client.on 'file', (data) ->
    console.log 'some file ' + data
  client.listall()
  client.status()
client.connect 6600, 'localhost'

