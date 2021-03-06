// Generated by CoffeeScript 1.6.3
var BasicStrategy, BearerStrategy, User, jwt, mongoose;

mongoose = require('mongoose');

BasicStrategy = require('passport-http').BasicStrategy;

BearerStrategy = require('passport-http-bearer').Strategy;

jwt = require('jwt-simple');

User = mongoose.model('User');

module.exports = function(passport, config) {
  passport.use(new BasicStrategy(function(username, password, done) {
    return User.findOne({
      username: username
    }, function(err, user) {
      if (err) {
        return done(err);
      }
      if (!user) {
        return done(null, false, {
          message: 'Unknown User'
        });
      }
      if (!user.authenticate(password)) {
        return done(null, false, {
          message: 'Invalid Password'
        });
      }
      return done(null, user);
    });
  }));
  return passport.use(new BearerStrategy(function(token, done) {
    return User.findOne({
      authToken: token
    }, function(err, user) {
      var tokenDecoded;
      if (err) {
        return done(err);
      }
      if (!user) {
        return done(null, false, {
          message: 'Missing Auth Token'
        });
      }
      tokenDecoded = jwt.decode(token, config.secret);
      if (!user.validateToken(token, tokenDecoded)) {
        return done(null, false, {
          message: 'Invalid Token'
        });
      }
      return done(null, user, {
        scope: 'all'
      });
    });
  }));
};
