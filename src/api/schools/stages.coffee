passport = require 'passport'
mongoose = require 'mongoose'
School = mongoose.model('School')
Stage = mongoose.model('Stage')

# GET /api/schools/{school-id}}/stages
# list all stages in a school
exports.list = (req, res) ->
  console.log "GET: #{req.params}"
  return School.findById req.params.school, (err, school) ->
    if not err
      if school
        return res.send school.stages
      else
        console.log "Resource not found!"
        res.statusCode = 400
        return res.send "Error 400: Resource not found!"
    else
      return console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"

# POST /api/schools/{school-id}/stages
# create a new school
exports.create = (req, res) ->
  #console.log "POST: "
  #console.log req.body

  req.assert('name', 'Please enter a name').notEmpty()

  errors = req.validationErrors(true)

  if not errors
    School.findById req.params.school, (err, school) ->
      if not err
        if school
          stage = school.stages.addToSet req.body
          school.save (err) ->
            if not err
              #console.log "created"
              return res.send stage
            else
              console.log err
              res.statusCode = 500
              return res.send "Error 500: Internal Server Error found!"
        else
          console.log "Resource not found!"
          res.statusCode = 400
          return res.send "Error 400: Resource not found!"
      else
        return console.log err
        res.statusCode = 500
        return res.send "Error 500: Internal Server Error found!"
  else
    #console.log errors
    res.statusCode = 400
    return res.send errors