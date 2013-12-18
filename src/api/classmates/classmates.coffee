passport = require 'passport'
mongoose = require 'mongoose'
async = require 'async'
fs = require 'fs'
im = require 'imagemagick'

School = mongoose.model('School')
Classmate = mongoose.model('Classmate')

# POST /api/classes/{class-id}/classmates
# create a new classmate into a class
exports.create = (req, res) ->
  #console.log "POST: "
  #console.log req.body

  photo = req.files.photo
  #console.log photo.name
  #console.log photo.path
  #console.log __dirname

  req.assert('firstName', 'Please enter a first name').notEmpty()
  req.assert('lastName', 'Please enter a last name').notEmpty()

  errors = req.validationErrors(true)

  if not errors
    classmate = new Classmate req.body
    classmate.save (err) ->
      if not err
        #console.log "created"
        tempPath  = '/home/efuentesp/development/peacemakers/uploads/temp/'   + classmate.id + '.jpg'
        thumbPath = '/home/efuentesp/development/peacemakers/uploads/thumb/'  + classmate.id + '.jpg'
        async.series
          resizePhoto: (done) ->
            fs.readFile photo.path, (err, data) ->
              fs.writeFile tempPath, data, (err) ->
                im.resize
                  srcPath: tempPath
                  dstPath: thumbPath
                  width: 100
                  height: 120
                , (err, stdout, stderr) ->
                  done(err) if err
                  done()
          deletePhoto: (done) ->
            fs.unlinkSync tempPath
        
        return res.send classmate
      else
        console.log err
        res.statusCode = 500
        return res.send "Error 500: Internal Server Error found!"
    return res.send classmate
  else
    #console.log errors
    res.statusCode = 400
    return res.send errors
