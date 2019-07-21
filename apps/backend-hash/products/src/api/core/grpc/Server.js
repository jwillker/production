const grpc = require('grpc');

class Server {
  /** Instantiates and configures an grpc server with the provided api version
   * and address.
   *
   * @param api {Object} - api version information
   * @param api.service {T} - the grpc service facade
   * @param api.implementation {T} - the grpc service implementation
   * @param config {Configuration} - base application configuration
   */
  constructor(api, config) {
    this.instance = new grpc.Server();
    this.instance.addService(api.service, api.implementation);
    this.address = config.grpc().address();
  }

  async start() {
    this.instance.bind(this.address, grpc.ServerCredentials.createInsecure());
    this.instance.start();
  }
}

module.exports.Server = Server;
