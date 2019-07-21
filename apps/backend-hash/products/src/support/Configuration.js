const nconf = require('nconf');

class Configuration {
  constructor() {
    nconf.env();
  }

  app() {
    return {
      name: () => nconf.get('APP_NAME'),
      env: () => nconf.get('APP_ENV'),
    };
  }

  log() {
    return {
      level: () => nconf.get('LOG_LEVEL') || 'ERROR',
    };
  }

  protos() {
    return {
      v1: () => 'api.v1.proto',
    };
  }

  http() {
    return {
      port: () => nconf.get('HTTP_PORT'),
    };
  }

  grpc() {
    return {
      root: () => './proto',
      address: () => `0.0.0.0:${nconf.get('GRPC_PORT')}`,
      proto: name => `${this.grpc().root()}/${name}`,
    };
  }

  discounts() {
    return {
      root: () => '../discounts/src/main/protobuf',
      address: () => `${nconf.get('DISCOUNTS_ADDRESS')}:${nconf.get('DISCOUNTS_PORT')}`,
      proto: () => `${this.discounts().root()}/api.v1.proto`,
    };
  }

  database() {
    return {
      host: () => nconf.get('DB_HOST'),
      user: () => nconf.get('DB_USERNAME'),
      pass: () => nconf.get('DB_PASSWORD'),
      name: () => nconf.get('DB_DATABASE'),
    };
  }
}

module.exports.config = new Configuration();
