const grpc = require('grpc');
const logger = require('loglevel');

function extractFromPackage(proto) {
  return proto.com.pasviegas.discounts.v1;
}

module.exports.createDiscountsClient = async config => {
  const { Api } = extractFromPackage(grpc.load(config.discounts().proto()));
  let api = new Api(config.discounts().address(), grpc.credentials.createInsecure());

  logger.info(`Discounts client created!`);
  return api;
};
