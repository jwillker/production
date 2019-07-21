const logger = require('loglevel');

const { ProductRepository } = require('../database/repositories/ProductRepository');
const { createConnection } = require('./../database');

module.exports.createProductRepository = async config => {
  const repository = new ProductRepository(createConnection(config));

  logger.info(`Application repository created!`);
  return repository;
};
