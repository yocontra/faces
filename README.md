![status](https://secure.travis-ci.org/wearefractal/faces.png?branch=master)

## Information

<table>
<tr> 
<td>Package</td><td>faces</td>
</tr>
<tr>
<td>Description</td>
<td>Facial Recognition</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.4</td>
</tr>
</table>

![Mona](https://raw.github.com/wearefractal/faces/master/test/newmona.png)

## Dependencies

You need to install opencv for this to work right.

## Usage

### Simple

```coffee-script
faces = require 'faces'
fs = require 'fs'

mona = fs.readFileSync 'mona.png'

faces.find mona, (err, faces) ->
   console.log "There are #{faces.length} faces"
```

### Streams

```coffee-script
faces = require 'faces'

faceStream = faces.createStream
  scale: 2
  min: [10, 10]
  draw: # optional, only specify this if you want to alter the image
    type: 'ellipse'

videoStream = someStream()
videoStream.pipe faceStream

faceStream.on 'data', (frame, faces) ->
  # frame is an image buffer
  # faces is an array of faces
```

## Docs

### createStream(opt)

createStream returns a readable/writeable stream that you can pipe image buffers too. Takes most image formats (png, jpeg, tiff, etc.) - .write(image buffer) and it will .emit('data', image buffer, faces, cvimg)

### find(buffer, opt, cb)

The actual facial recognition worker. opt is optional. Callback receives (err, faces) where faces is an array of ```{x,y,height,width}```

### draw(faces, cvimg, opt, cb)

opt.type can be either ellipse or rectangle
opt.color = [0,255,0] by default
opt.thickness is 0-255
cb receives (err, buff) where buff is a new image buffer

### toImageUrl(buf, fmt="png")

Turns an image buffer into a base64 data uri - useful for rendering to a webpage or sending over websockets.

## Examples

You can view more examples in the [example folder.](https://github.com/wearefractal/faces/tree/master/examples)

## LICENSE

(MIT License)

Copyright (c) 2012 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
