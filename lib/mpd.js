(function() {
  var events, mpd, net, path, sys;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  net = require('net');
  sys = require('util');
  path = require('path');
  events = require('events').EventEmitter;
  module.exports = mpd = function() {
    __extends(mpd, events);
    function mpd() {
      this.parseResponse = __bind(this.parseResponse, this);;
      this.connect = __bind(this.connect, this);;
      this.end = __bind(this.end, this);;
      this.closed = __bind(this.closed, this);;
      this.data = __bind(this.data, this);;
      this.connected = __bind(this.connected, this);;
      this.send = __bind(this.send, this);;      this.stream = null;
      this.version = '0.16.1';
      this.commandList = [];
    }
    mpd.prototype.send = function(message) {
      this.commandList.push(message.split(' ')[0]);
      return this.stream.write("" + message + "\n");
    };
    mpd.prototype.connected = function() {
      return this.emit('connected');
    };
    mpd.prototype.data = function(data) {
      var packet;
      packet = [];
      return __bind(function(data) {
        var cmd, commands, _i, _len, _results;
        commands = data.split('\n');
        _results = [];
        for (_i = 0, _len = commands.length; _i < _len; _i++) {
          cmd = commands[_i];
          packet.push(cmd);
          cmd = cmd.split(' ');
          _results.push(function() {
            switch (cmd[0]) {
              case 'OK':
                if (cmd[1] === 'MPD') {
                  return this.version = cmd[2];
                } else {
                  this.emit.call(this, this.commandList.shift(), this.parseResponse(packet));
                  return packet = [];
                }
            }
          }.call(this));
        }
        return _results;
      }, this);
    };
    mpd.prototype.closed = function() {
      return this.emit('closed');
    };
    mpd.prototype.end = function() {
      return this.emit('end');
    };
    mpd.prototype.connect = function(port, server) {
      this.stream = net.createConnection(port, server);
      this.stream.setEncoding('utf8');
      this.stream.on('connect', this.connected);
      this.stream.on('data', this.data());
      this.stream.on('close', this.closed);
      this.stream.on('end', this.end);
      return this.emit('connect');
    };
    mpd.prototype.parseResponse = function(data) {
      var item, p, regx, result, _i, _len;
      p = {};
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        item = data[_i];
        regx = /^(\w+):\s?(.*)$/i;
        result = regx.exec(item);
        if (result != null) {
          if (result[1].indexOf('file') >= 0) {
            if (!(p.files != null)) {
              p.files = [];
            }
            p.files.push(result[2]);
          } else if (result[1].indexOf('directory') >= 0) {
            if (!(p.dirs != null)) {
              p.dirs = [];
            }
            p.dirs.push(result[2]);
          } else {
            p[result[1]] = result[2];
          }
        }
      }
      return p;
    };
    mpd.prototype.status = function() {
      return this.send("status");
    };
    mpd.prototype.next = function() {
      return this.send("next");
    };
    mpd.prototype.currentSongDetails = function() {
      return this.send("currentsong");
    };
    mpd.prototype.pause = function() {
      return this.send("pause");
    };
    mpd.prototype.stop = function() {
      return this.send("stop");
    };
    mpd.prototype.play = function(songId) {
      return this.send("play " + songId);
    };
    mpd.prototype.previous = function() {
      return this.send("previous");
    };
    mpd.prototype.random = function(state) {
      return this.send("random " + (state || !this.random_state));
    };
    mpd.prototype.repeat = function(state) {
      return this.send("repeat " + (state || !this.repeat_state));
    };
    mpd.prototype.seek = function(id, time) {
      return this.send("seek " + id + " " + time);
    };
    mpd.prototype.setvol = function(vol) {
      return this.send("setvol " + vol);
    };
    mpd.prototype.close = function() {
      return this.send("close");
    };
    mpd.prototype.password = function(password) {
      return this.send("password " + password);
    };
    mpd.prototype.ping = function() {
      return this.send("ping");
    };
    mpd.prototype.listall = function() {
      return this.send("listall");
    };
    mpd.prototype.find = function(type, search) {
      return this.send("find " + type + " \"" + search + "\"");
    };
    mpd.prototype.search = function(type, search) {
      return this.send("search " + type + " " + search);
    };
    return mpd;
  }();
}).call(this);
