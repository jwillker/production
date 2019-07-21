const knex = require('knex');

module.exports.createConnection = config => {
  return knex({
    client: 'mysql2',
    connection: {
      host: config.database().host(),
      user: config.database().user(),
      password: config.database().pass(),
      database: config.database().name(),
    },
  });
};
