mongoose = require 'mongoose'
Role = mongoose.model('Role')

# GET /api/roles
# list all roles
exports.list = (req, res) ->
  console.log "GET: "
  console.log req.query
  console.log req.authInfo

  return Role.find()
    .exec (err, roles) ->
      if err
        console.log err
        res.statusCode = 500
        return res.send "Error 500: Internal Server Error found!"
      return res.send roles

# POST /api/roles
# create a new role
exports.create = (req, res) ->
  console.log "POST: "
  console.log req.body
  role = new Role req.body
  role.save (err) ->
    if err
      console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"
    console.log "created"
    return res.send role

# POST /api/roles/{role-id}/permissions
# add a new permission to role
exports.addPermission = (req, res) ->
  console.log "Role: #{req.params.id}"
  console.log "POST: "
  console.log req.body
  Role.findById req.params.id, (err, role) ->
    if err
      console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"
    if not role
      console.log err
      res.statusCode = 404
      return res.send "Error 404: Resource not found!"

    role.addPermission req.body, (err) ->
      if err
        console.log err
        res.statusCode = 500
        return res.send "Error 500: Internal Server Error found!"
      role.save (err) ->
        if err
          console.log err
          res.statusCode = 500
          return res.send "Error 500: Internal Server Error found!"
        console.log "permission added to role"
        return res.send role