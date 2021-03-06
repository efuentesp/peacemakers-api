// Generated by CoffeeScript 1.6.3
var passport, roles;

passport = require("passport");

roles = require('./roles');

module.exports = function(app, config) {
  var bearer;
  bearer = passport.authenticate('bearer', {
    session: false
  });
  app.get('/api/roles', roles.list);
  app.post('/api/roles', roles.create);
  return app.post('/api/roles/:id/permissions', roles.addPermission);
};
