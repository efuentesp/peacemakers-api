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

SchoolSchema.statics.findClass = (schoolId, stageId, periodId, classId, done) ->
  this.findById schoolId, (err, school) ->
    if not err
      if school
        stage = school.stages.id(stageId)
        period = stage.periods.id(periodId)
        for cls in period.classes
          if cls._id is classId
            return done(null, cls)
        return done(new Error "Class [#{classId}] doesn't exist.")
      else
        return done(new Error "School [#{schoolId}] doesn't exist.")
    else
      return done(err)

SchoolSchema.statics.findClassmate = (schoolId, stageId, periodId, classId, classmateId, done) ->
  this.findById schoolId, (err, school) ->
    if not err
      if school
        stage = school.stages.id(stageId)
        period = stage.periods.id(periodId)
        for cls in period.classes
          if cls._id is classId
            for classmate in cls.classmates
              if classmate is classmateId
                return done(null, classmate)
        return done(new Error "Classmate [#{classmateId}] doesn't exist.")
      else
        return done(new Error "School [#{schoolId}] doesn't exist.")
    else
      return done(err)

SchoolSchema.statics.addClassmate = (schoolId, stageId, periodId, classId, classmateId, done) ->
  this.findById schoolId, (err, school) ->
    if not err
      if school
        stage = school.stages.id(stageId)
        period = stage.periods.id(periodId)
        for cls in period.classes
          if cls._id is classId
            cls.classmates.push _id: classmateId
            school.save (err)->
              return done(err) if err
              return done(null, school)
        return done(new Error "Class [#{classId}] doesn't exist.")
      else
        return done(new Error "School [#{schoolId}] doesn't exist.")
    else
      return done(err)

mongoose.model('School', SchoolSchema)
mongoose.model('Stage', StageSchema)
mongoose.model('Period', PeriodSchema)
mongoose.model('Class', ClassSchema)