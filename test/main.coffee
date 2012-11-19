faces = require '../'
fs = require 'fs'
{join} = require 'path'
{Stream} = require 'stream'
should = require 'should'
require 'mocha'

mona = fs.readFileSync join __dirname, './mona.png'

describe 'faces', ->
  describe 'createStream()', ->
    it 'should return a stream', (done) ->
      s = faces.createStream()
      should.exist s
      s.should.be.instanceof Stream
      done()

    it 'should work', (done) ->
      s = faces.createStream()
      should.exist s
      s.should.be.instanceof Stream

      s.on 'error', (err) -> throw err
      s.on 'data', (buf, faces) ->
        should.exist buf
        faces.length.should.equal 1
        done()

      s.write mona

    it 'should work with draw (ellipse)', (done) ->
      s = faces.createStream
        draw:
          type: 'ellipse'
      should.exist s
      s.should.be.instanceof Stream

      s.on 'error', (err) -> throw err
      s.on 'data', (buf, faces) ->
        should.exist buf
        should.exist faces
        faces.length.should.equal 1
        fs.writeFileSync join(__dirname, './newmona.png'), buf
        done()
      
      s.write mona

  describe 'find()', ->
    it 'should find mona lisa', (done) ->
      faces.find mona, (err, faces) ->
        should.not.exist err
        should.exist faces
        faces.length.should.equal 1
        done()

    it 'shouldnt find mona lisa with dumb options', (done) ->
      faces.find mona, {min:[900,900]}, (err, faces) ->
        should.not.exist err
        should.exist faces
        faces.length.should.equal 1
        done()

  describe 'toImageUrl()', ->
    it 'should return png buf from mona', (done) ->
      uri = faces.toImageUrl mona
      should.exist uri
      done()