const grpc = require('grpc');
const express = require('express');
const bodyParser = require('body-parser');
const grpcGateway = require('grpc-dynamic-gateway');

class Gateway {
  /** Instantiates and configures an express server with the provided api version
   * and port, so it can serve as a gateway to the underlying grpc server.
   *
   * @param api {Object} - api version information
   * @param api.proto {string} - .proto file location
   * @param config {Configuration} - base application configuration
   */
  constructor(api, config) {
    this.instance = express();
    this.instance.use(bodyParser.json());
    this.instance.use(bodyParser.urlencoded({ extended: false }));
    this.instance.use('/', this.createGateway(api, config));
    this.port = config.http().port();
  }

  createGateway(api, config) {
    return grpcGateway(
      [api.proto],
      config.grpc().address(),
      grpc.credentials.createInsecure(),
      false,
      config.grpc().root(),
      grpc
    );
  }

  start() {
    return new Promise(resolve => {
      this.instance.listen(this.port, resolve);
    });
  }
}

module.exports.Gateway = Gateway;
