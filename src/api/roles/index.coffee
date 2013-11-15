passport = require "passport"
roles = require './roles'

module.exports = (app, config) ->
  bearer = passport.authenticate('bearer', { session: false })

  app.get     '/api/roles',                   roles.list
  #app.get     '/api/roles/:id',              roles.show  
  app.post    '/api/roles',                   roles.create
  app.post    '/api/roles/:id/permissions',   roles.addPermission
  #app.put     '/api/roles/:id',              roles.update
  #app.delete  '/api/roles/:id',              roles.destroy

# To test with http basic auth:
#   curl -v localhost:9001/api/roles/?access_token=1234567890