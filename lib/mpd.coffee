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
    @stream.write "#{message}\n" 

  connected: =>
    @callback 'connected'

  data: (data) =>
    self = this
    packet = []
    console.log 'data1'
    (data) =>
      console.log 'data2'
      commands = data.split '\n'
      for cmd in commands
        packet.push cmd
        cmd = cmd.split ' '
        switch cmd[0]
          when 'OK'
            if cmd[1] is 'MPD'
              console.log 'dont do much'
            else
              console.log 'cb: ' + data
              @callback.call(self, @parseResponse packet)
              packet = []

  closed: =>
    @callback 'closed'

  end: =>
    console.log('ending')
    @callback 'end'

  connect: (port, server) =>
    @stream = net.createConnection port, server
    @stream.setEncoding 'utf8'
    @stream.on 'connect', @connected 
    @stream.on 'data', @data() 
    @stream.on 'close', @closed 
    @stream.on 'end', @end 
    @callback 'connected'

  parseResponse: (data) =>
    p = {}
    for item in data
      console.log item
      regx = /^(\w+):\s?(.*)$/i
      result = regx.exec item
      if result?
        p[result[1]] = result[2]
    console.log 'returning ' + sys.inspect p
    return p

  parseResponseOld: (data) =>
    if (data.indexOf('OK') >= 0)
      console.log data
    p = {}
    parent = "" 
    for item in data
      regx = /^(\w+):\s?(.*)$/i
      result = regx.exec item
      if result?
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
    @callbacks.listall p

  callback: (type, data) =>
    if @callbacks['debug']?
      for cb in @callbacks['debug']
        cb.call this, data

    if @callbacks[type]?
      for cb in @callbacks[type]
        cb.call this, data
      
  on: (type, cb) =>
    console.log 'adding on for ' + type
    if !@callbacks[type]?
      @callbacks[type] = []
    @callbacks[type].push cb

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
