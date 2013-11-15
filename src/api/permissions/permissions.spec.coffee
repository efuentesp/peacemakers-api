mongoose = require "mongoose"
should = require "should"
app = require "../../server"

Permission = mongoose.model('Permission')

describe "Permission Model", ->

  beforeEach (done) ->
    mongoose.connection.db.dropCollection("permissions", done())

  it "should register a new Permission", (done) ->
    permission = new Permission
      subject: "Schools"
      action: "create"
      displayName: "Create new School"
      description: "Description to create a new School."
    permission.save(done)

  afterEach (done) ->
    mongoose.connection.db.dropCollection("permissions", done())