module.exports = {

  development: {
    app: {
      name: 'Peacemakers (dev)'
    },
    db: 'mongodb://localhost/peacemakers-dev',
    secret: 'Peacemakers2.0'
  }

  test: {
    app: {
      name: 'Peacemakers (test)'
    },
    db: 'mongodb://localhost/peacemakers-test',
    secret: 'Peacemakers2.0'
  }
}