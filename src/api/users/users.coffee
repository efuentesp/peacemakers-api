mongoose = require 'mongoose'
User = mongoose.model('User')

# GET /api/users
# list all users
exports.list = (req, res) ->
  console.log "GET: "
  console.log req.query
  console.log req.authInfo

  return User.find()
    .exec (err, users) ->
      if err
        console.log err
        res.statusCode = 500
        return res.send "Error 500: Internal Server Error found!"
      return res.send users

# POST /api/users
# create a new user
exports.create = (req, res) ->
  console.log "POST: "
  console.log req.body
  user = new User req.body
  user.save (err) ->
    if err
      console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"
    console.log "created"
    return res.send user

# POST /api/users/{user-id}/roles
# add new role to user
exports.addRole = (req, res) ->
  console.log "User: #{req.params.id}"
  console.log "POST: "
  console.log req.body
  User.findById req.params.id, (err, user) ->
    if err
      console.log err
      res.statusCode = 500
      return res.send "Error 500: Internal Server Error found!"
    if not user
      console.log err
      res.statusCode = 404
      return res.send "Error 404: Resource not found!"

    user.addRole req.body.roleName, (err) ->
      if err
        console.log err
        res.statusCode = 500
        return res.send "Error 500: Internal Server Error found!"
      user.save (err) ->
        if err
          console.log err
          res.statusCode = 500
          return res.send "Error 500: Internal Server Error found!"
        console.log "role added to user"
        return res.send user