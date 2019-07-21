const grpc = require('grpc');

const { GetProducts } = require('./methods/GetProducts');

function extractFromPackage(proto) {
  return proto.products.v1.Api.service;
}

function createV1Service(config) {
  let filename = { file: config.protos().v1(), root: config.grpc().root() };
  return extractFromPackage(grpc.load(filename));
}

function createGetProducts(repository, discounts) {
  return new GetProducts(repository, discounts).asFunction();
}

/** Creates the v1 service api, injecting all external dependencies and
 *  constructing the implementations for all the rpc methods.
 *
 * @param config {Configuration} - base application configuration.
 * @param repository {Object} - the application repository.
 * @param discounts {Object} - the discounts api client.
 * @returns {Promise<{service: *, implementation: {getProducts: *}, proto: (*|string)}>}
 */
module.exports.createV1 = async (config, repository, discounts) => {
  return {
    service: createV1Service(config),
    implementation: {
      getProducts: createGetProducts(repository, discounts),
    },
    proto: config.protos().v1(),
  };
};
