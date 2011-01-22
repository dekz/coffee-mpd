net = require 'net'
sys = require 'util'
path = require 'path'

module.exports = class mpd 
  constructor: ->
    @stream = null
    @version = '0.16.1' 
    @callbacks = new Object 
    @lastParent = '' 

  send: (message) =>
    console.log "sending message: #{message}\n" 
    @stream.write "#{message}\n" 

  connected: =>
    console.log 'connected'

  data: (data) =>
    response = []
    commands = data.split '\n'
  
    for cmd in commands
      if cmd.length >= 2
        responseCode = cmd.split ' '
        switch responseCode[0]
          when 'OK'
            console.log "GOT AN OK BRO"
            if responseCode[1] is 'MPD'
              @version = responseCode[2]
          when 'ACK'
            console.log(data)
            return
          else
            response.push cmd
    if response.length > 0
      @parseResponse response

  closed: =>
    console.log('closing connection')

  end: ->
    console.log('ending')

  connect: (port, server) =>
    @stream = net.createConnection port, server
    @stream.setEncoding 'utf8'
    @stream.on 'connect', @connected 
    @stream.on 'data', @data 
    @stream.on 'close', @closed 
    @stream.on 'end', @end 

  parseResponse: (data) =>
    p = {}
    parent = "" 
    for item in data
      regx = /^(\w+):\s?(.*)$/i
      result = regx.exec item
      #console.log 'item ' +  item
      if result?
        #console.log result
        switch result[1]
          when 'directory'
            if !p.resp?
              p.resp = []
            parent = result[2]
            @lastParent = parent
            p.resp[result[2]] = [] 
          when 'file'
            if !p.resp?
              p.resp = []
            if p.resp[parent]?
              p.resp[parent].push path.basename result[2] 
            else
              parent = @lastParent
              p.resp[parent] = []
              p.resp[parent].push result[2]
          else
            if !p.resp?
              p.resp = {}
            p.resp[result[1]] = result[2]

    console.log p  
    @callbacks.listall p

  status: ->
    @send "status"

  next: ->
    @send "next"

  currentSongDetails: ->
    @send "currentsong"

  pause: ->
    @send "pause"

  stop: ->
    @send("stop")

  play: (songId) ->
    @send "play #{songId}"

  previous: ->
    @send "previous"

  random: (state) ->
    @send "random #{state or not @random_state}" 

  repeat: (state) ->
    @send "repeat #{state or not @repeat_state}" 

  seek: (id, time) ->
    @send "seek #{id} #{time}"

  setvol: (vol) ->
    @send "setvol #{vol}" 

  close: ->
    @send "close"

  password: (password) ->
    @send "password #{password}" 

  ping: ->
    @send "ping"

  listall: ->
    @send "listall"
