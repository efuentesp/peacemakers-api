mongoose = require 'mongoose'
BasicStrategy = require('passport-http').BasicStrategy
BearerStrategy = require('passport-http-bearer').Strategy
jwt = require 'jwt-simple'
User = mongoose.model 'User'

module.exports = (passport, config) ->

  passport.use new BasicStrategy (username, password, done) ->
    User.findOne { username: username }, (err, user) ->
      return done(err) if err
      return done(null, false, {message: 'Unknown User'}) if not user
      return done(null, false, {message: 'Invalid Password'}) if not user.authenticate(password)
      return done(null, user)

  passport.use new BearerStrategy (token, done) ->
    User.findOne { authToken: token }, (err, user) ->
      return done(err) if err
      return done(null, false, {message: 'Missing Auth Token'}) if not user
      tokenDecoded = jwt.decode(token, config.secret)
      return done(null, false, {message: 'Invalid Token'}) if not user.validateToken(token, tokenDecoded)
      return done(null, user, { scope: 'all' })