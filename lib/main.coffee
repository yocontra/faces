cv = require 'opencv'
{join} = require 'path'
async = require 'async'
{Stream} = require 'stream'

cascade = new cv.CascadeClassifier join __dirname, "./haarcascade_frontalface_alt.xml"

class FaceStream extends Stream
  constructor: (@opt={}) ->
    @writable = true
    @readable = true
    @destroyed = false

  write: (buf) ->
    faces.find buf, @opt, (err, faces, im) =>
      return if @destroyed
      return @emit 'error', err if err?
      @emit 'data', buf, faces, im

  destroy: -> @destroyed = true
  end: -> @destroy()

module.exports = faces =
  createStream: (opt) -> new FaceStream opt

  toImageUrl: (buf, fmt='png') ->
    "data:image/#{fmt};base64,#{buf.toString('base64')}"
    
  find: (buf, opt, cb) ->
    if typeof opt is 'function'
      cb = opt
      opt = {}

    opt.neighbors ?= 2
    opt.scale ?= 2
    opt.min ?= [10,10]
    cv.readImage buf, (err, im) ->
      return cb err if err?
      done = (err, f) ->
        return cb err if err?
        cb null, f, im
      cascade.detectMultiScale im, done, opt.neighbors, opt.scale, opt.min