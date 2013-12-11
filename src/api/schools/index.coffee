passport = require "passport"
authorization = require "../auth/authorization"
schools = require './schools'
stages  = require './stages'
classes = require './classes'
periods = require './periods'

module.exports = (app) ->
  bearer = passport.authenticate('bearer', { session: false })

  #app.get     '/api/schools',     bearer, authorization.restrictTo('schools', 'list'), schools.list
  app.get     '/api/schools',     schools.list
  app.get     '/api/schools/:id', schools.show  
  app.post    '/api/schools',     schools.create
  app.put     '/api/schools/:id', schools.update
  app.delete  '/api/schools/:id', schools.destroy

  app.get     '/api/schools/:school/stages',                  stages.list
  app.post    '/api/schools/:school/stages',                  stages.create

  app.get     '/api/schools/:school/stages/:stage/periods',   periods.list
  app.post    '/api/schools/:school/stages/:stage/periods',   periods.create

  app.get     '/api/schools/:school/stages/:stage/periods/:period/classes',   classes.list
  app.post    '/api/schools/:school/stages/:stage/periods/:period/classes',   classes.create