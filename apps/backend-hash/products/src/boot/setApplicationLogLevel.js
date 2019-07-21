const logger = require('loglevel');

module.exports.setApplicationLogLevel = async config => {
  logger.setLevel(config.log().level());
  logger.info(`Log level set: ${config.log().level()}`);
};
