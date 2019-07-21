const nconf = require('nconf');
const {config} = require('./Configuration');

nconf.overrides({
  APP_NAME: 'products-api',
  APP_ENV: 'development',
  DB_HOST: 'database',
  DB_DATABASE: 'api',
  DB_USERNAME: 'root',
  DB_PASSWORD: 'secret',
  HTTP_PORT: '80',
  GRPC_PORT: '5002',
  DISCOUNTS_PORT: '5001',
  DISCOUNTS_ADDRESS: '0.0.0.0',
});

test('should have correct apps configs set', () => {
  expect(config.app().name()).toBe('products-api');
  expect(config.app().env()).toBe('development');
});

test('should have correct log configs when no log level is set', () => {
  expect(config.log().level()).toBe('ERROR');
});

test('should have correct log configs when a log level is set', () => {
  nconf.defaults({ LOG_LEVEL: 'INFO' });
  expect(config.log().level()).toBe('INFO');
});

test('should have correct protos configs set', () => {
  expect(config.protos().v1()).toBe('api.v1.proto');
});

test('should have correct http configs set', () => {
  expect(config.http().port()).toBe('80');
});

test('should have correct discounts configs set', () => {
  expect(config.discounts().root()).toBe('../discounts/src/main/protobuf');
  expect(config.discounts().proto()).toBe('../discounts/src/main/protobuf/api.v1.proto');
  expect(config.discounts().address()).toBe('0.0.0.0:5001');
});

test('should have correct grpc configs set', () => {
  expect(config.grpc().root()).toBe('./proto');
  expect(config.grpc().proto('file')).toBe('./proto/file');
  expect(config.grpc().address()).toBe('0.0.0.0:5002');
});

test('should have correct database configs set', () => {
  expect(config.database().host()).toBe('database');
  expect(config.database().name()).toBe('api');
  expect(config.database().pass()).toBe('secret');
  expect(config.database().user()).toBe('root');
});
