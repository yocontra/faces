cv = require 'opencv'
{join} = require 'path'
async = require 'async'
es = require 'event-stream'

module.exports = faces =
  load: (file) -> 
    faces.cascade = new cv.CascadeClassifier file

  createStream: (opt={}) -> es.map (data, cb) ->
    faces.find data, opt, (err, faceres, im) ->
      return cb err if err?
      if opt.draw?.type?
        faces.draw faceres, im, opt.draw, (err, buff) ->
          return cb err if err?
          cb null, buff, faceres, im
      else
        cb null, data, faceres, im

  findCenter: ({x,y,width,height}) ->
    centerX = 320
    centerY = 184
    matchCenterX = x+(width/2)
    x: matchCenterX
    y: coordinate.y+(height/2)
    xDist: Math.abs(centerX-matchCenterX)

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
      faces.cascade.detectMultiScale im, done, opt.neighbors, opt.scale, opt.min

  draw: (faces, im, opt, cb) ->
    opt.color ?= [0,255,0]
    opt.thickness ?= 2
    switch opt.type
      when 'rectangle'
        for f in faces
          im.rectangle [f.x,f.y], [f.x+f.width,f.y+f.height], opt.color, opt.thickness

      when 'ellipse'
        for f in faces
          im.ellipse f.x+f.width/2, f.y+f.height/2, f.width/2, f.height/2, opt.color, opt.thickness

    im.toBuffer cb

faces.load join __dirname, "./face.xml"
