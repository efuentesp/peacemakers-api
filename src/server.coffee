# Configurations
env = process.env.NODE_ENV || 'development'
config = require('./config/config')[env]

# Database connection
mongoose = require 'mongoose'
mongoose.connect config.db

# Models
require './models/user'
require './models/school'

# Authentication Middlware
passport = require 'passport'
require('./config/passport')(passport, config)

# Express
express = require 'express'
app = express()
app.use express.bodyParser()
app.use passport.initialize()

# Modules
auth = require('./api/auth')(app, config)
permissions = require('./api/permissions')(app, config)
roles = require('./api/roles')(app, config)
users = require('./api/users')(app, config)
schools = require('./api/schools')(app)

# Start server
app.listen 3000
console.log "Listening on port 3000..."