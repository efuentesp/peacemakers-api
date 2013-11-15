// Generated by CoffeeScript 1.6.3
var app, auth, config, env, express, mongoose, passport, permissions, roles, schools, users;

env = process.env.NODE_ENV || 'development';

config = require('./config/config')[env];

mongoose = require('mongoose');

mongoose.connect(config.db);

require('./models/user');

require('./models/school');

passport = require('passport');

require('./config/passport')(passport, config);

express = require('express');

app = express();

app.use(express.bodyParser());

app.use(passport.initialize());

auth = require('./api/auth')(app, config);

permissions = require('./api/permissions')(app, config);

roles = require('./api/roles')(app, config);

users = require('./api/users')(app, config);

schools = require('./api/schools')(app);

app.listen(3000);

console.log("Listening on port 3000...");
