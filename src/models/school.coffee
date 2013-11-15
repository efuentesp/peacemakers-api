mongoose = require 'mongoose'
Schema = mongoose.Schema

# School Schema
SchoolSchema = new Schema {
  name:       { type: String, default: '' }
  www:        { type: String, default: '' }
  createdAt:  { type: Date, default: Date.now }
}

mongoose.model('School', SchoolSchema)