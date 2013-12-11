mongoose = require "mongoose"
async = require "async"
should = require "should"
request = require "supertest"
app = require "../../server"

School = mongoose.model('School')
Stage = mongoose.model('Stage')

describe "Stage API", ->
  url = "http://localhost:3000"

  before (done) ->
    @school = new School
      name: "Test 1"
    @school.save (err) ->
      should.not.exist err
      done()

  describe "POST /schools/:id/stages", ->

    it "should creates a new Stage into an existing School", (done) ->
      stage =
        name: "Stage 1"

      request(url)
        .post("/api/schools/" + @school._id + "/stages")
        .send(stage)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) =>
          throw err if err
          stage_added = res.body[0]
          stage_added.should.have.property('_id')
          stage_added.name.should.equal('Stage 1')
          stage_added.createdAt.should.not.equal(null)
          done()

    it "should not create a new Stage without name in an existing School", (done) ->
      stage =
        name: ""

      request(url)
        .post("/api/schools/" + @school._id + "/stages")
        .send(stage)
        .expect('Content-Type', /json/)
        .expect(400)
        .end (err, res) =>
          throw err if err
          done()

  after (done) ->
    mongoose.connection.db.dropCollection "schools", (err) ->
      done(err) if err
      done()