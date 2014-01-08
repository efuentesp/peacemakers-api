mongoose = require 'mongoose'
Schema = mongoose.Schema

# Classmate Schema
ClassmateSchema = new Schema {
  firstName:  { type: String, default: '' }
  lastName:   { type: String, default: '' }
  createdAt:  { type: Date, default: Date.now }
}

mongoose.model('Classmate', ClassmateSchema)