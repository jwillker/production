const logger = require('loglevel');

const { Gateway } = require('../api/core/grpc/Gateway');
const { Server } = require('../api/core/grpc/Server');

const { createV1 } = require('../api/v1');

module.exports.startServerAndGateway = async (config, repository, discounts) => {
  const v1 = await createV1(config, repository, discounts);

  await new Server(v1, config).start();
  logger.info(`Grpc served started!`);

  await new Gateway(v1, config).start();
  logger.info(`Http gateway started!`);
};
