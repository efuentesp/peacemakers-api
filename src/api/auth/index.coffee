passport = require "passport"
mongoose = require 'mongoose'
jwt = require 'jwt-simple'
User = mongoose.model('User')

module.exports = (app, config) ->
  auth = passport.authenticate('basic', { session: false })

  app.get     '/api/auth', auth, (req, res)->
    # GET /api/auth
    # Get authorization token
    authorization = req.headers.authorization
    if not authorization
        console.log "HTTP: Authorization not found!"
        res.statusCode = 400
        return res.send "Error 400: HTTP: Authorization not found!"
    parts = authorization.split(' ')
    scheme = parts[0]
    credentials = new Buffer(parts[1], 'base64').toString()
    index = credentials.indexOf(':')
    if scheme is not 'Basic' or index < 0
        console.log "Not Basic Authorization!"
        res.statusCode = 400
        return res.send "Error 400: HTTP: Not Basic Authorization!"

    username = credentials.slice(0, index)
    password = credentials.slice(index + 1)

    return User.findOne { username: username }, (err, user) ->
      return console.log err if err
      if user
        payload =
          username: user.username
          expires: Math.round((new Date().getTime()/1000)) + 3600 # 1 hr
        token = jwt.encode(payload, config.secret)
        user.authToken = token
        user.save (err) ->
          if err
            console.log err
            res.statusCode = 500
            return res.send "Error 500: Internal Server Error found!"
          console.log "updated"
          user.getPermissions (err, permissions) ->
            if err
              console.log err
              res.statusCode = 500
              return res.send "Error 500: Internal Server Error found!"
            #console.log permissions
            return res.send { token: token, auth: permissions }
      else
        console.log "Resource not found!"
        res.statusCode = 400
        return res.send "Error 400: Resource not found!"

# To test with http basic auth:
#   curl -v --basic --user admin:password localhost:9001/api/auth