passport = require "passport"
permisions = require './permissions'

module.exports = (app, config) ->
  bearer = passport.authenticate('bearer', { session: false })

  app.get     '/api/permissions',     permisions.list
  #app.get     '/api/permissions/:id', permisions.show  
  app.post    '/api/permissions',     permisions.create
  #app.put     '/api/permissions/:id', permisions.update
  #app.delete  '/api/permissions/:id', permisions.destroy

# To test with http basic auth:
#   curl -v localhost:9001/api/permissions/?access_token=1234567890