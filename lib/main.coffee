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
    if @opt.draw?.type?
      @opt.draw.color ?= [0,255,0]
      @opt.draw.thickness ?= 2

  write: (buf) ->
    return @ if @destroyed
    faces.find buf, @opt, (err, faceres, im) =>
      return if @destroyed
      return @emit 'error', err if err?
      if @opt.draw?.type?
        faces.draw faceres, im, @opt.draw, (err, buff) =>
          @emit 'data', buff, faceres, im
      else
        @emit 'data', buf, faceres, im
    return @

  destroy: -> 
    @destroyed = true
    return @

  end: -> 
    @destroy()
    return @

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

  draw: (faces, im, opt, cb) ->
    switch opt.type
      when 'rectangle'
        for f in faces
          im.rectangle [f.x,f.y], [f.x+f.width,f.y+f.height], opt.color, opt.thickness

      when 'ellipse'
        for f in faces
          im.ellipse f.x+f.width/2, f.y+f.height/2, f.width/2, f.height/2, opt.color, opt.thickness

    im.toBuffer cb


