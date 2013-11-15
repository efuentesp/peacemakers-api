passport = require "passport"
users = require './users'

module.exports = (app, config) ->
  bearer = passport.authenticate('bearer', { session: false })

  app.get     '/api/users',     bearer, users.list
  #app.get     '/api/users',             users.list
  #app.get     '/api/users/:id',        users.show  
  app.post    '/api/users',             users.create
  app.post    '/api/users/:id/roles',   users.addRole
  #app.put     '/api/users/:id',        users.update
  #app.delete  '/api/users/:id',        users.destroy

# To test with http basic auth:
#   curl -v localhost:9001/api/users/?access_token=1234567890