net = require 'net'
sys = require 'util'
path = require 'path'
events = require('events').EventEmitter

module.exports = class mpd extends events 
  constructor: ->
    @stream = null
    @version = '0.16.1' 
    @commandList = [] 

  send: (message) =>
    @commandList.push  message.split(' ')[0]
    @stream.write "#{message}\n" 

  connected: =>
    @emit 'connected'

  data: (data) =>
    packet = []
    (data) =>
      commands = data.split '\n'
      for cmd in commands
        packet.push cmd
        cmd = cmd.split ' '
        switch cmd[0]
          when 'OK'
            if cmd[1] is 'MPD'
              @version = cmd[2]
            else
              @emit.call(this, @commandList.shift(), @parseResponse packet)
              packet = []

  closed: =>
    @emit 'closed'

  end: =>
    @emit 'end'

  connect: (port, server) =>
    @stream = net.createConnection port, server
    @stream.setEncoding 'utf8'
    @stream.on 'connect', @connected 
    @stream.on 'data', @data() 
    @stream.on 'close', @closed 
    @stream.on 'end', @end 
    @emit 'connect'

  parseResponse: (data) =>
    p = {}
    for item in data
      regx = /^(\w+):\s?(.*)$/i
      result = regx.exec item
      if result?
        if (result[1].indexOf('file') >=0)
          if !p.files?
            p.files = []
          p.files.push result[2]
        else if (result[1].indexOf('directory') >= 0)
          if !p.dirs?
            p.dirs = []
          p.dirs.push result[2]
        else
          p[result[1]] = result[2]
    return p

  status: ->
    @send "status"

  next: ->
    @send "next"

  currentSongDetails: ->
    @send "currentsong"

  pause: ->
    @send "pause"

  stop: ->
    @send "stop"

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

  find: (type, search) ->
    @send "find #{type} \"#{search}\""
  
  search: (type, search) ->
    @send "search #{type} #{search}"
