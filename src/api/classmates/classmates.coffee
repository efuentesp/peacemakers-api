passport = require 'passport'
mongoose = require 'mongoose'
async = require 'async'
fs = require 'fs'
im = require 'imagemagick'

School = mongoose.model('School')
Classmate = mongoose.model('Classmate')

# GET /api/schools/{school-id}/stages/{stage-id}/periods/{period-id}/classes/{class-id}/classmates
# lists all classmates in a class
exports.list = (req, res) ->
  #console.log "GET: "
  #console.log req.params

  return School.findById req.params.school, (err, school) ->
    if not err
      if school
        stage = school.stages.id(req.params.stage)
        period = stage.periods.id(req.params.period)
        #cls = period.classes.id(req.params.cls)
        for cls in period.classes
          if cls._id is req.params.cls
            return res.send cls.classmates
      else
        console.log "Resource not found!"
        res.statusCode = 400
        return res.send "Error 400: Resource not found!"
    else
      return console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"

# TODO: Get only one classmate
# GET /api/schools/{school-id}/stages/{stage-id}/periods/{period-id}/classes/{class-id}/classmates/{classmate-id}
# show classmate in a class
exports.show = (req, res) ->
  #console.log "GET: "
  #console.log req.params

  return School.findById req.params.school, (err, school) ->
    if not err
      if school
        stage = school.stages.id(req.params.stage)
        period = stage.periods.id(req.params.period)
        for cls in period.classes
          if cls._id is req.params.cls
            for classmate in cls.classmates
              if classmate is req.params.classmate
                return res.send classmate
        console.log "Resource not found!"
        res.statusCode = 400
        return res.send "Error 400: Resource not found!"
      else
        console.log "Resource not found!"
        res.statusCode = 400
        return res.send "Error 400: Resource not found!"
    else
      return console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"


# POST /api/schools/{school-id}/stages/{stage-id}/periods/{period-id}/classes/{class-id}/classmates
# create a new classmate in a class
exports.create = (req, res) ->
  #console.log "POST: "
  #console.log req.params
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


