mongoose = require "mongoose"
async = require "async"
should = require "should"
request = require "supertest"
app = require "../../server"

School = mongoose.model('School')
Stage = mongoose.model('Stage')
Period = mongoose.model('Period')
Class = mongoose.model('Class')
Classmate = mongoose.model('Classmate')

describe "Classmate API", ->
  url = "http://localhost:3000"

  before (done) ->
    @school = new School
      name: "School 1"
      stages: [
        { name: "Stage 1", periods: [ { name: "Period 1.1" }, { name: "Period 1.2", classes: [ {name: "Class 1.2.1"} ] } ] }
        { name: "Stage 2", periods: [ { name: "Period 2.1" }, { name: "Period 2.2" } ] }
      ]
    @school.save (err) ->
      should.not.exist err
      done()

  describe "POST /classes/:id/classmates", ->

    it "should creates a new Classmate", (done) ->
      classmate =
        firstName: "Classmate FirstName"
        lastName: "Classmate LastName"

      request(url)
        .post("/api/schools/" + @school._id + "/stages/" + @school.stages[0]._id + "/periods/" + @school.stages[0].periods[1]._id + "/classes/" + @school.stages[0].periods[1].classes[0]._id + "/classmates")
        #.post("/api/classes/" + @school.stages[0].periods[1].classes[0]._id + "/classmates")
        .field("firstName", classmate.firstName)
        .field("lastName", classmate.lastName)
        .attach('photo', __dirname+'/photo.jpg')
        .end (err, res) =>
          throw err if err
          res.should.have.status 200
          classmate_added = res.body
          #classmate_added.should.have.property('_id')
          classmate_added.firstName.should.equal('Classmate FirstName')
          classmate_added.lastName.should.equal('Classmate LastName')
          #classmate_added.createdAt.should.not.equal(null)
          done()

    it "should link a Classmate within a Class", (done) ->
      request(url)
        .get("/api/schools/" + @school._id + "/stages/" + @school.stages[0]._id + "/periods/" + @school.stages[0].periods[1]._id + "/classes/" + @school.stages[0].periods[1].classes[0]._id + "/classmates")
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) ->
          throw err if err
          res.should.be.json
          res.body.length.should.equal(3)
          #res.body.should.include({ name: "Test School 2" })
          done()

  after (done) ->
    mongoose.connection.db.dropCollection "classmates", (err) ->
      done(err) if err
      done()