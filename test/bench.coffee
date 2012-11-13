faces = require '../'
fs = require 'fs'
{join} = require 'path'
{Stream} = require 'stream'
should = require 'should'
async = require 'async'
require 'mocha'

mona = fs.readFileSync join __dirname, './mona.png'

acceptable = 50
iterations = 60

describe 'faces', ->
  describe 'find()', ->
    it 'shouldnt take long', (done) ->
      start = Date.now()
      faces.find mona, (err, faces) ->
        end = Date.now()
        should.not.exist err
        should.exist faces
        faces.length.should.equal 1
        dur = end-start
        (dur < acceptable).should.equal true
        done()

  describe 'find() multiple', ->
    it 'shouldnt take long', (done) ->
      count = []
      run = (cb) ->
        start = Date.now()
        faces.find mona, (err, faces) ->
          end = Date.now()
          should.not.exist err
          should.exist faces
          faces.length.should.equal 1
          dur = end-start
          count.push dur
          cb()

      under = -> count.length < iterations
      async.whilst under, run, (e) ->
        should.not.exist e
        throw "Slow! #{c}" for c in count when c > acceptable
        done()