passport = require "passport"
authorization = require "../auth/authorization"
classmates = require './classmates'

module.exports = (app, config) ->
  bearer = passport.authenticate('bearer', { session: false })

  #app.get     '/api/schools',     bearer, authorization.restrictTo('schools', 'list'), schools.list
  app.post     '/api/schools/:school/stages/:stage/periods/:period/classes/:cls/classmates',  classmates.create
  #app.post     '/api/classes/:classId/classmates',     classmates.create