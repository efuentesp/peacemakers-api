# Configurations
env = process.env.NODE_ENV || 'development'
config = require('./config/config')[env]

# Database connection
mongoose = require 'mongoose'
mongoose.connect config.db

# Models
require './models/user'
require './models/school'
require './models/classmate'

# Authentication Middlware
passport = require 'passport'
require('./config/passport')(passport, config)

# Express
express = require 'express'
expressValidator = require 'express-validator'
app = express()
app.use express.bodyParser()
app.use expressValidator()
app.use passport.initialize()

# Modules
auth = require('./api/auth')(app, config)
permissions = require('./api/permissions')(app, config)
roles = require('./api/roles')(app, config)
users = require('./api/users')(app, config)
schools = require('./api/schools')(app, config)
classmates = require('./api/classmates')(app, config)

# Start server
app.listen 3000
console.log "Listening on port 3000..."