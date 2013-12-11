mongoose = require "mongoose"
async = require "async"
should = require "should"
request = require "supertest"
app = require "../../server"

School = mongoose.model('School')
Stage = mongoose.model('Stage')
Period = mongoose.model('Period')
Class = mongoose.model('Class')

describe "Class API", ->
  url = "http://localhost:3000"

  before (done) ->
    @school = new School
      name: "School 1"
      stages: [
        { name: "Stage 1", periods: [ { name: "Period 1.1" }, { name: "Period 1.2" } ] }
        { name: "Stage 2", periods: [ { name: "Period 2.1" }, { name: "Period 2.2" } ] }
      ]
    @school.save (err) ->
      should.not.exist err
      done()

  describe "POST /schools/:id/stages/:id/periods/:id/classes", ->

    it "should creates a new Class into a Period/Stage/School", (done) ->
      cls =
        name: "Class 2.1.1"

      request(url)
        .post("/api/schools/" + @school._id + "/stages/" + @school.stages[1]._id + "/periods/" + @school.stages[1].periods[0]._id + "/classes")
        .send(cls)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) =>
          throw err if err
          class_added = res.body
          #class_added.should.have.property('_id')
          class_added.name.should.equal('Class 2.1.1')
          #class_added.createdAt.should.not.equal(null)
          done()

  after (done) ->
    mongoose.connection.db.dropCollection "schools", (err) ->
      done(err) if err
      done()