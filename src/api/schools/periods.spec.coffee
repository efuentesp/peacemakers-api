mongoose = require "mongoose"
async = require "async"
should = require "should"
request = require "supertest"
app = require "../../server"

School = mongoose.model('School')
Stage = mongoose.model('Stage')
Period = mongoose.model('Period')

describe "Period API", ->
  url = "http://localhost:3000"

  before (done) ->
    @school = new School
      name: "Test 1"
      stages: [
        { name: "Stage 1" }
        { name: "Stage 2" }
      ]
    @school.save (err) ->
      should.not.exist err
      done()

  describe "POST /schools/:id/stages/:id/periods", ->

    it "should creates a new Period into a Stage/School", (done) ->
      period =
        name: "Period 1"

      request(url)
        .post("/api/schools/" + @school._id + "/stages/" + @school.stages[0]._id + "/periods")
        .send(period)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) =>
          throw err if err
          stage_added = res.body[0]
          stage_added.should.have.property('_id')
          stage_added.name.should.equal('Period 1')
          stage_added.createdAt.should.not.equal(null)
          done()

  after (done) ->
    mongoose.connection.db.dropCollection "schools", (err) ->
      done(err) if err
      done()