mongoose = require 'mongoose'
Permission = mongoose.model('Permission')

# GET /api/permissions
# list all permissions
exports.list = (req, res) ->
  console.log "GET: "
  console.log req.query
  console.log req.authInfo

  return Permission.find()
    .exec (err, permissions) ->
      if err
        console.log err
        res.statusCode = 500
        return res.send "Error 500: Internal Server Error found!"
      return res.send permissions

# POST /api/permissions
# create a new permissions
exports.create = (req, res) ->
  console.log "POST: "
  console.log req.body
  permission = new Permission req.body
  permission.save (err) ->
    if err
      console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"
    console.log "created"
  return res.send permission