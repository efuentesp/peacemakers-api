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

  describe "POST /class/:id/classmates", ->

    it "should creates a new Classmate into a Class/Period/Stage/School", (done) ->
      classmate =
        firstName: "Classmate 1 FN"
        lastName: "Classmate 1 SN"

      request(url)
        .post("/api/class/" + @school.stages[0].periods[1].classes[0]._id + "/classmates")
        .field("firstName", classmate.firstName)
        .field("lastName", classmate.lastName)
        .attach('photo', 'unknown_photo.jpg')
        #.send(classmate)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) =>
          throw err if err
          classmate_added = res.body
          #classmate_added.should.have.property('_id')
          classmate_added.firstName.should.equal('Classmate 1 FN')
          classmate_added.lastName.should.equal('Classmate 1 SN')
          #classmate_added.createdAt.should.not.equal(null)
          done()

  after (done) ->
    mongoose.connection.db.dropCollection "classmates", (err) ->
      done(err) if err
      done()