passport = require 'passport'
mongoose = require 'mongoose'
School = mongoose.model('School')

# GET /api/schools
# list all schools
exports.list = (req, res) ->
  console.log "GET: "
  console.log req.query

  return School.find()
    .exec (err, schools) ->
      if not err
        return res.send schools
      else
        return console.log err
        res.statusCode = 500
        return res.send "Error 500: Internal Server Error found!"

# GET /api/schools/{school-id}
# show a specific school
exports.show = (req, res) ->
  console.log "GET: #{req.params.id}"
  return School.findById req.params.id, (err, school) ->
    if not err
      if school
        return res.send school
      else
        console.log "Resource not found!"
        res.statusCode = 400
        return res.send "Error 400: Resource not found!"
    else
      return console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"

# POST /api/schools
# create a new school
exports.create = (req, res) ->
  console.log "POST: "
  console.log req.body
  school = new School req.body
  school.save (err) ->
    if not err
      return console.log "created"
    else
      return console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"
  return res.send school

# PUT /api/schools/{school-id}
# update a school
exports.update = (req, res) ->
  console.log "PUT: #{req.params.id}"
  return School.findById req.params.id, (err, school) ->
    if not err
      if school
        school.name = req.body.name
        school.www = req.body.www
        return school.save (err) ->
          if not err
            console.log "updated"
          else
            console.log err
            res.statusCode = 500
            return res.send "Error 500: Internal Server Error found!"
          return res.send school
      else
        console.log "Resource not found!"
        res.statusCode = 400
        return res.send "Error 400: Resource not found!"
    else
      return console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"

# DELETE /api/schools/{school-id}
# delete a school
exports.destroy = (req, res) ->
  console.log "DELETE: #{req.params.id}"
  return School.findById req.params.id, (err, school) ->
    if not err
      if school
        return school.remove (err) ->
          if not err
            console.log "removed"
            return res.send ''
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