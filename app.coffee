mpd = require './lib/mpd'
client = new mpd
client.connect 6600, 'localhost'
list = null
client.callbacks = 
  listall: (l) ->
    list = l
client.listall()
#client.status()
