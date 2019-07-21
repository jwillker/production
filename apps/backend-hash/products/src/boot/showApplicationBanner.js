const figlet = require('figlet');

module.exports.showApplicationBanner = async config => {
  // eslint-disable-next-line no-console
  console.log(figlet.textSync(config.app().name()));
};
