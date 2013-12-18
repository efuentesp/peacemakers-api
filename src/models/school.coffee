mongoose = require 'mongoose'
Schema = mongoose.Schema

# Period
PeriodSchema = new Schema {
  name:       { type: String, default: '' }
  classes:    [ClassSchema]
  createdAt:  { type: Date, default: Date.now }
}

# Stage
StageSchema = new Schema {
  name:       { type: String, default: '' }
  periods:     [PeriodSchema]
  createdAt:  { type: Date, default: Date.now }
}

# Class
ClassSchema = new Schema {
  name:       { type: String, default: '' }
  classmates: [ type: Schema.ObjectId, ref: 'Classmate' ]
  createdAt:  { type: Date, default: Date.now }
}

# School Schema
SchoolSchema = new Schema {
  name:       { type: String, default: '' }
  www:        { type: String, default: '' }
  stages:     [StageSchema]
  createdAt:  { type: Date, default: Date.now }
}

mongoose.model('School', SchoolSchema)
mongoose.model('Stage', StageSchema)
mongoose.model('Period', PeriodSchema)
mongoose.model('Class', ClassSchema)