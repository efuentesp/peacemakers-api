mongoose = require 'mongoose'
crypto = require 'crypto'
async = require 'async'

Schema = mongoose.Schema

PermissionSchema = new Schema
  subject:
    type: String
    default: ''
  action:
    type: String
    default: ''
  displayName: String
  description: String

mongoose.model('Permission', PermissionSchema)

resolvePermission = (permission, done) ->
  mongoose.model('Permission').findOne {subject: permission.subject, action: permission.action}, (err, permission) ->
    return done(err) if err
    return done(new Error "Unknown Permission: #{permission}") if not permission
    return done(null, permission)

RoleSchema = new Schema
  name:
    type: String
    default: ''
  displayName: String
  description: String
  permissions: [type: Schema.ObjectId, ref: 'Permission']

RoleSchema.methods = {

  hasPermission: (permissionId) ->
    if @.permissions
      for p in @.permissions
        return true if permissionId.toString() is p.toString()
    false

  addPermission: (p, done) ->
    resolvePermission p, (err, permission) =>
      return done(err) if err
      if @.hasPermission permission._id
        return done(new Error "Existing Permission: #{permission.subject} #{permission.action}")
      @.permissions.push _id: permission._id
      done()

}

mongoose.model('Role', RoleSchema)

resolveRole = (roleName, done) ->
  mongoose.model('Role').findOne {name: roleName}, (err, role) ->
    return done(err) if err
    return done(new Error "Unknown Role: #{roleName}") if not role
    return done(null, role)


UserSchema = new Schema
  username:
    type: String
    default: ''
  hashed_password:
    type: String
    default: ''
  email:
    type: String
    default: ''
  authToken:
    type: String
    default: ''
  salt:
    type: String
    default: ''
  roles: [type: Schema.ObjectId, ref: 'Role']

UserSchema
  .virtual('password')
  .set((password) ->
    @._password = password
    @.salt = @.makeSalt()
    @.hashed_password = @.encryptPassword(password)
  )
  .get(-> @._password)

UserSchema.methods = {

  authenticate: (plainText) ->
    #plainText is @hashed_password
    @.encryptPassword(plainText) is @.hashed_password
  
  validateToken: (token, tokenDecoded) ->
    return false if token isnt @authToken
    now = Math.round((new Date().getTime()/1000))
    return tokenDecoded.expires > now

  makeSalt: ->
    Math.round((new Date().valueOf() * Math.random())) + ''

  encryptPassword: (password) ->
    return '' if not password
    try
      encrypred = crypto.createHmac('sha1', @.salt).update(password).digest('hex')
      return encrypred
    catch err
      return ''

  hasRole: (roleId) ->
    if @.roles
      for r in @.roles
        return true if roleId.toString() is r.toString()
    false

  addRole: (roleName, done) ->
    resolveRole roleName, (err, role) =>
      return done(err) if err
      if @.hasRole role._id
        return done(new Error "Existing Role: #{roleName}")
      @.roles.push _id: role._id
      done()

  getPermissions: (done) ->
    permissions = []

    loopPermissions = (p, done) ->
      mongoose.model('Permission').findById p, (err, permission) ->
        return done(err) if err
        permissions.push
          subject: permission.subject
          action: permission.action
        #console.log "1. #{permissions}"
        done()

    loopRoles = (r, done) ->
      mongoose.model('Role').findById r, (err, role) ->
        return done(err) if err
        if role.permissions
          async.each role.permissions, loopPermissions, (err) ->
            done(err) if err
            #console.log "2. #{permissions}"
            done()
        else
          done()

    if @.roles
      async.each @.roles, loopRoles, (err) ->
        return done(err) if err
        #console.log "3. #{permissions}"
        return done(null, permissions)
    else
      return done(null, permissions)

  can: (subject ,action, done) ->
    isAuthorized = false

    findPermission = (p, done) ->
      if p.subject is subject and p.action is action
        isAuthorized = true
      done()

    if @.roles
      @.getPermissions (err, permissions) ->
        async.each permissions, findPermission, () ->
          return done(null, isAuthorized)
    else
      return done(null, isAuthorized)
}

mongoose.model('User', UserSchema)