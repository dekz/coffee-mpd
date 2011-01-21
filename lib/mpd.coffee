net = require 'net'
sys = require 'sys'

class MPD
  constructor: ->
    @stream = null
    @version = -1

    @connected = ->
      console.log('connected')

    @send = (message) ->
      console.log('sending message: ' + message)
      @stream.write(message + '\n')

    @data = (data) ->
      response = []
      commands = data.split '\n'
    
      for cmd in commands
        if cmd.length >= 2
          responseCode = cmd.split(' ')
          switch responseCode[0]
            when 'OK'
              if responseCode[1] is 'MPD'
                @version = responseCode[2]
            when 'ACK'
              return
            else
              response.push cmd
      if response.length > 0
        parseResponse response

    @closed = ->
      console.log('closing connection')

    @end = ->
      console.log('ending')

  connect: (port, server) ->
    @stream = net.createConnection(port, server)
    @stream.setEncoding('utf8')
    @stream.on('connect', @connected)
    @stream.on('data', @data)
    @stream.on('close', @closed)
    @stream.on('end', @end)

  parseResponse = (data) ->
    console.log('parsing data')
    p = {}
    for item in data
      regx = /^(\w+):\s?(.*)$/i
      result = regx.exec(item)
      if result?
        p[result[1]] = result[2]

    console.log(p)

  next: ->
    @send('next')

  currentSongDetails: ->
    @send('currentsong')

  pause: ->
    @send('pause')

  stop: ->
    @send('stop')

  play: (songId) ->
    songId = songId | -1
    @send('play ' + songId)

  previous: ->
    @send('previous')

  random: (state) ->
    state = state | !@randomState
    @send('random ' + state)

  repeat: (state) ->
    state = state | !@repeatState
    @send('repeat ' + state)

  seek: (songId, time) ->
    cmd = ['seek', songId, time]
    @send(cmd.join(' '))

  setvol: (vol) ->
    @send('setvol ' + vol)

  close: ->
    @send('close')

  password: (password) ->
    @send('password ' + password)

  ping: ->
    @send('ping')

