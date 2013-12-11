// Generated by CoffeeScript 1.6.3
var Class, Classmate, Period, School, Stage, app, async, mongoose, request, should;

mongoose = require("mongoose");

async = require("async");

should = require("should");

request = require("supertest");

app = require("../../server");

School = mongoose.model('School');

Stage = mongoose.model('Stage');

Period = mongoose.model('Period');

Class = mongoose.model('Class');

Classmate = mongoose.model('Classmate');

describe("Classmate API", function() {
  var url;
  url = "http://localhost:3000";
  before(function(done) {
    this.school = new School({
      name: "School 1",
      stages: [
        {
          name: "Stage 1",
          periods: [
            {
              name: "Period 1.1"
            }, {
              name: "Period 1.2",
              classes: [
                {
                  name: "Class 1.2.1"
                }
              ]
            }
          ]
        }, {
          name: "Stage 2",
          periods: [
            {
              name: "Period 2.1"
            }, {
              name: "Period 2.2"
            }
          ]
        }
      ]
    });
    return this.school.save(function(err) {
      should.not.exist(err);
      return done();
    });
  });
  describe("POST /class/:id/classmates", function() {
    return it("should creates a new Classmate into a Class/Period/Stage/School", function(done) {
      var classmate,
        _this = this;
      classmate = {
        firstName: "Classmate 1 FN",
        lastName: "Classmate 1 SN"
      };
      return request(url).post("/api/class/" + this.school.stages[0].periods[1].classes[0]._id + "/classmates").field("firstName", classmate.firstName).field("lastName", classmate.lastName).attach('photo', 'unknown_photo.jpg').expect('Content-Type', /json/).expect(200).end(function(err, res) {
        var classmate_added;
        if (err) {
          throw err;
        }
        classmate_added = res.body;
        classmate_added.firstName.should.equal('Classmate 1 FN');
        classmate_added.lastName.should.equal('Classmate 1 SN');
        return done();
      });
    });
  });
  return after(function(done) {
    return mongoose.connection.db.dropCollection("classmates", function(err) {
      if (err) {
        done(err);
      }
      return done();
    });
  });
});
