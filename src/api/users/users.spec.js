// Generated by CoffeeScript 1.6.3
var Permission, Role, User, app, async, mongoose, should;

mongoose = require("mongoose");

async = require("async");

should = require("should");

app = require("../../server");

Permission = mongoose.model('Permission');

Role = mongoose.model('Role');

User = mongoose.model('User');

describe("User Model", function() {
  var _this = this;
  before(function(done) {
    var addPermissionsToRole, permissions, savePermissions;
    permissions = [
      {
        subject: "Schools",
        action: "create",
        displayName: "Create new School",
        description: "Description to create a new School."
      }, {
        subject: "Schools",
        action: "edit",
        displayName: "Edit a School",
        description: "Description to edit a new School."
      }, {
        subject: "Schools",
        action: "destroy",
        displayName: "Destroy a School",
        description: "Description to destroy a School."
      }
    ];
    savePermissions = function(p, done) {
      var permission;
      permission = new Permission(p);
      return permission.save(function(err) {
        if (err) {
          done(err);
        }
        return done();
      });
    };
    addPermissionsToRole = function(p, done) {
      var _this = this;
      return this.role.addPermission(p, function(err) {
        if (err) {
          return done(err);
        }
        return role.save(function(err) {
          if (err) {
            return done(err);
          }
          return done();
        });
      });
    };
    return async.each(permissions, savePermissions, function(err) {
      if (err) {
        return done(err);
      }
      this.role = new Role({
        name: "admin",
        displayName: "Admin",
        description: "Site Administrator"
      });
      return async.each(permissions, addPermissionsToRole, function(err) {
        if (err) {
          return done(err);
        }
        return done();
      });
    });
  });
  it("should register a new User", function(done) {
    _this.user = new User({
      username: "test",
      password: "password",
      email: "test@mail.com"
    });
    return _this.user.save(function(err) {
      should.not.exist(err);
      return done();
    });
  });
  it("should add a new Role to User", function(done) {
    return _this.user.addRole('admin', function(err) {
      should.not.exist(err);
      return _this.user.save(function(err) {
        should.not.exist(err);
        _this.user.roles.should.have.lengthOf(1);
        return done();
      });
    });
  });
  it("should notify when a Role was previously added", function(done) {
    return _this.user.addRole('admin', function(err) {
      should.exist(err);
      _this.user.roles.should.have.lengthOf(1);
      return done();
    });
  });
  it("should notify when the new Role doesn't exist", function(done) {
    return _this.user.addRole('xxx', function(err) {
      should.exist(err);
      _this.user.roles.should.have.lengthOf(1);
      return done();
    });
  });
  it("should list all permissions", function(done) {
    return _this.user.getPermissions(function(err, permissions) {
      should.not.exist(err);
      permissions.should.have.lengthOf(3);
      return done();
    });
  });
  it("should tell if it has certain permissions", function(done) {
    return _this.user.can('Schools', 'edit', function(err, has) {
      should.not.exist(err);
      has.should.equal(true);
      return done();
    });
  });
  return after(function(done) {
    mongoose.connection.db.dropCollection("permissions", function(err) {
      if (err) {
        return done(err);
      }
    });
    mongoose.connection.db.dropCollection("roles", function(err) {
      if (err) {
        return done(err);
      }
    });
    return mongoose.connection.db.dropCollection("users", function(err) {
      if (err) {
        done(err);
      }
      return done();
    });
  });
});