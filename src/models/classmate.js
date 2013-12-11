// Generated by CoffeeScript 1.6.3
var ClassmateSchema, Schema, mongoose;

mongoose = require('mongoose');

Schema = mongoose.Schema;

ClassmateSchema = new Schema({
  firstName: {
    type: String,
    "default": ''
  },
  lastName: {
    type: String,
    "default": ''
  },
  photo: {
    type: String,
    "default": ''
  },
  createdAt: {
    type: Date,
    "default": Date.now
  }
});

mongoose.model('Classmate', ClassmateSchema);