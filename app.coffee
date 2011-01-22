util = require 'util'
mpd = require './lib/mpd'
client = new mpd
client.on 'connect', ->
  console.log 'IM CONNECTED'

  client.on 'listall', (data) ->
    console.log 'listall: ' + util.inspect data

  client.on 'status', (data) ->
    console.log 'status: ' +  util.inspect data

  client.listall()
  client.status()
client.connect 6600, 'localhost'

