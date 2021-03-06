// Generated by CoffeeScript 1.6.3
var ClassSchema, PeriodSchema, Schema, SchoolSchema, StageSchema, mongoose;

mongoose = require('mongoose');

Schema = mongoose.Schema;

PeriodSchema = new Schema({
  name: {
    type: String,
    "default": ''
  },
  classes: [ClassSchema],
  createdAt: {
    type: Date,
    "default": Date.now
  }
});

StageSchema = new Schema({
  name: {
    type: String,
    "default": ''
  },
  periods: [PeriodSchema],
  createdAt: {
    type: Date,
    "default": Date.now
  }
});

ClassSchema = new Schema({
  name: {
    type: String,
    "default": ''
  },
  classmates: [
    {
      type: Schema.ObjectId,
      ref: 'Classmate'
    }
  ],
  createdAt: {
    type: Date,
    "default": Date.now
  }
});

SchoolSchema = new Schema({
  name: {
    type: String,
    "default": ''
  },
  www: {
    type: String,
    "default": ''
  },
  stages: [StageSchema],
  createdAt: {
    type: Date,
    "default": Date.now
  }
});

SchoolSchema.statics.findClass = function(schoolId, stageId, periodId, classId, done) {
  return this.findById(schoolId, function(err, school) {
    var cls, period, stage, _i, _len, _ref;
    if (!err) {
      if (school) {
        stage = school.stages.id(stageId);
        period = stage.periods.id(periodId);
        _ref = period.classes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cls = _ref[_i];
          if (cls._id === classId) {
            return done(null, cls);
          }
        }
        return done(new Error("Class [" + classId + "] doesn't exist."));
      } else {
        return done(new Error("School [" + schoolId + "] doesn't exist."));
      }
    } else {
      return done(err);
    }
  });
};

SchoolSchema.statics.findClassmate = function(schoolId, stageId, periodId, classId, classmateId, done) {
  return this.findById(schoolId, function(err, school) {
    var classmate, cls, period, stage, _i, _j, _len, _len1, _ref, _ref1;
    if (!err) {
      if (school) {
        stage = school.stages.id(stageId);
        period = stage.periods.id(periodId);
        _ref = period.classes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cls = _ref[_i];
          if (cls._id === classId) {
            _ref1 = cls.classmates;
            for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
              classmate = _ref1[_j];
              if (classmate === classmateId) {
                return done(null, classmate);
              }
            }
          }
        }
        return done(new Error("Classmate [" + classmateId + "] doesn't exist."));
      } else {
        return done(new Error("School [" + schoolId + "] doesn't exist."));
      }
    } else {
      return done(err);
    }
  });
};

SchoolSchema.statics.addClassmate = function(schoolId, stageId, periodId, classId, classmateId, done) {
  return this.findById(schoolId, function(err, school) {
    var cls, period, stage, _i, _len, _ref;
    if (!err) {
      if (school) {
        stage = school.stages.id(stageId);
        period = stage.periods.id(periodId);
        _ref = period.classes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          cls = _ref[_i];
          if (cls._id === classId) {
            cls.classmates.push({
              _id: classmateId
            });
            school.save(function(err) {
              if (err) {
                return done(err);
              }
              return done(null, school);
            });
          }
        }
        return done(new Error("Class [" + classId + "] doesn't exist."));
      } else {
        return done(new Error("School [" + schoolId + "] doesn't exist."));
      }
    } else {
      return done(err);
    }
  });
};

mongoose.model('School', SchoolSchema);

mongoose.model('Stage', StageSchema);

mongoose.model('Period', PeriodSchema);

mongoose.model('Class', ClassSchema);
