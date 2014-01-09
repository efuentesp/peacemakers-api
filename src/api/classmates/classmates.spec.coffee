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
    class1 = new Class
      name: "Class 1.2.1"

    @school = new School
      name: "School 1"
      stages: [
        { name: "Stage 1", periods: [ { name: "Period 1.1" }, { name: "Period 1.2" } ] }
        { name: "Stage 2", periods: [ { name: "Period 2.1" }, { name: "Period 2.2" } ] }
      ]
    #@school.stages[0].periods[1].classes.addToSet class1
    @school.save (err) ->
      should.not.exist err
      #done()

    request(url)
      .post("/api/schools/" + @school._id + "/stages/" + @school.stages[0]._id + "/periods/" + @school.stages[0].periods[1]._id + "/classes")
      .send(class1)
      .expect('Content-Type', /json/)
      .expect(200)
      .end (err, res) =>
        throw err if err
        @class_added = res.body
        @class_added.name.should.equal('Class 1.2.1')
        done()

  describe "POST /schools/:id/stages/:id/periods/:id/classes/:id/classmates", ->

    it "should creates a new Classmate", (done) ->
      classmate =
        firstName: "Classmate FirstName"
        lastName: "Classmate LastName"

      request(url)
        .post("/api/schools/" + @school._id + "/stages/" + @school.stages[0]._id + "/periods/" + @school.stages[0].periods[1]._id + "/classes/" + @class_added._id + "/classmates")
        #.post("/api/classes/" + @school.stages[0].periods[1].classes[0]._id + "/classmates")
        .field("firstName", classmate.firstName)
        .field("lastName", classmate.lastName)
        .attach('photo', __dirname+'/photo.jpg')
        .end (err, res) =>
          throw err if err
          res.should.have.status 200
          @classmate_added = res.body
          #classmate_added.should.have.property('_id')
          @classmate_added.firstName.should.equal('Classmate FirstName')
          @classmate_added.lastName.should.equal('Classmate LastName')
          #classmate_added.createdAt.should.not.equal(null)
          done()

    it "should link a Classmate in a Class", (done) ->
      request(url)
        .get("/api/schools/" + @school._id + "/stages/" + @school.stages[0]._id + "/periods/" + @school.stages[0].periods[1]._id + "/classes/" + @class_added._id + "/classmates/" + @classmate_added._id)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) ->
          throw err if err
          res.should.be.json
          res.body.length.should.equal(1)
          done()


  describe "GET /schools/:id/stages/:id/periods/:id/classes/:id/classmates", ->

    it "should lists a Classmates in a Class", (done) ->
      request(url)
        .get("/api/schools/" + @school._id + "/stages/" + @school.stages[0]._id + "/periods/" + @school.stages[0].periods[1]._id + "/classes/" + @class_added._id + "/classmates")
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) ->
          throw err if err
          res.should.be.json
          res.body.length.should.equal(1)
          done()

  after (done) ->
    mongoose.connection.db.dropCollection "classmates", (err) ->
      done(err) if err
      done()