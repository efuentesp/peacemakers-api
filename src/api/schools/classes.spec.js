// Generated by CoffeeScript 1.6.3
var Class, Period, School, Stage, app, async, mongoose, request, should;

mongoose = require("mongoose");

async = require("async");

should = require("should");

request = require("supertest");

app = require("../../server");

School = mongoose.model('School');

Stage = mongoose.model('Stage');

Period = mongoose.model('Period');

Class = mongoose.model('Class');

describe("Class API", function() {
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
              name: "Period 1.2"
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
  describe("POST /schools/:id/stages/:id/periods/:id/classes", function() {
    return it("should creates a new Class into a Period/Stage/School", function(done) {
      var cls,
        _this = this;
      cls = {
        name: "Class 2.1.1"
      };
      return request(url).post("/api/schools/" + this.school._id + "/stages/" + this.school.stages[1]._id + "/periods/" + this.school.stages[1].periods[0]._id + "/classes").send(cls).expect('Content-Type', /json/).expect(200).end(function(err, res) {
        var class_added;
        if (err) {
          throw err;
        }
        class_added = res.body;
        class_added.name.should.equal('Class 2.1.1');
        return done();
      });
    });
  });
  return after(function(done) {
    return mongoose.connection.db.dropCollection("schools", function(err) {
      if (err) {
        done(err);
      }
      return done();
    });
  });
});
