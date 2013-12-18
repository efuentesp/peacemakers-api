mongoose = require "mongoose"
async = require "async"
should = require "should"
request = require "supertest"
app = require "../../server"

School = mongoose.model('School')

describe 'School Model', ->

  it "should register a new School", (done) ->
    school = new School
      name: "Test 1"
    school.save (err) ->
      should.not.exist err
      done()


describe "Schools API", ->
  url = "http://localhost:3000"

  describe "GET /schools", ->

    before (done) ->
      schools = [
        {
          name: "Test School 1"
        }
        {
          name: "Test School 2"
        }
        {
          name: "Test School 3"
        }
      ]
      for s in schools
        school = new School s
        school.save (err) ->
          throw err if err
      done()

    it "should retrieve all Schools", (done) ->
      request(url)
        .get("/api/schools")
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) ->
          throw err if err
          res.should.be.json
          res.body.length.should.equal(4)
          #res.body.should.include({ name: "Test School 2" })
          done()

    after (done) ->
      School.collection.remove(done)

  describe "POST /schools/:id", ->

    it "should creates a new School", (done) ->
      school =
        name: "Test School 1"

      request(url)
        .post("/api/schools")
        .send(school)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) =>
          throw err if err
          school_added = res.body
          res.body.should.have.property('_id')
          res.body.name.should.equal('Test School 1')
          res.body.createdAt.should.not.equal(null)
          done()

    it "should not create a new School without name", (done) ->
      school =
        name: ""

      request(url)
        .post("/api/schools")
        .send(school)
        .expect('Content-Type', /json/)
        .expect(400)
        .end (err, res) =>
          throw err if err
          done()

  describe "PUT /schools/:id", ->

    before (done) ->
      @school_before = new School
        name: "New School"
      @school_before.save(done)

    it "should update an existing School", (done) ->
      school =
        name: "Test School 1 modified"

      request(url)
        .put("/api/schools/#{@school_before._id}")
        .send(school)
        .expect('Content-Type', /json/)
        .expect(200)
        .end (err, res) ->
          throw err if err
          res.body.should.have.property('_id')
          res.body.name.should.equal('Test School 1 modified')
          res.body.createdAt.should.not.equal(null)
          done()

    it "should not update a School without name", (done) ->
      school =
        name: ""

      request(url)
        .post("/api/schools")
        .send(school)
        .expect('Content-Type', /json/)
        .expect(400)
        .end (err, res) =>
          throw err if err
          done()

  describe "DELETE /schools/:id", ->

    before (done) ->
      @school_before = new School
        name: "New School"
        www: "www.newschool.edu.mx"
      @school_before.save(done)

    it "should delete an existing School", (done) ->

      request(url)
        .del("/api/schools/#{@school_before._id}")
        .expect(200)
        .end (done)

  after (done) ->
    mongoose.connection.db.dropCollection "schools", (err) ->
      done(err) if err
      done()