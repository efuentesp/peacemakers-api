mongoose = require 'mongoose'
User = mongoose.model('User')

exports.restrictTo = (subject, action) ->
  (req, res, next) ->
    User.findById req.user._id, (err, user) ->
      next(err) if err
      user.can subject, action, (err, has) ->
        next(err) if err
        if not has
          res.statusCode = 403
          return res.send "Error 403: Forbidden!"
          next()
          #next(new Error('Unauthorized')) if not has
        next()