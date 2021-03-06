// Generated by CoffeeScript 1.6.3
var authorization, classmates, passport;

passport = require("passport");

authorization = require("../auth/authorization");

classmates = require('./classmates');

module.exports = function(app, config) {
  var bearer;
  bearer = passport.authenticate('bearer', {
    session: false
  });
  app.get('/api/schools/:school/stages/:stage/periods/:period/classes/:cls/classmates', classmates.list);
  app.get('/api/schools/:school/stages/:stage/periods/:period/classes/:cls/classmates/:classmate', classmates.show);
  return app.post('/api/schools/:school/stages/:stage/periods/:period/classes/:cls/classmates', classmates.create);
};
