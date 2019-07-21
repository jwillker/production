const { config } = require('./support/Configuration');

const { showApplicationBanner } = require('./boot/showApplicationBanner');
const { setApplicationLogLevel } = require('./boot/setApplicationLogLevel');
const { createProductRepository } = require('./boot/createProductRepository');
const { createDiscountsClient } = require('./boot/createDiscountsClient');
const { startServerAndGateway } = require('./boot/startServerAndGateway');

(async () => {
  await showApplicationBanner(config);
  await setApplicationLogLevel(config);

  const repository = await createProductRepository(config);
  const discounts = await createDiscountsClient(config);

  await startServerAndGateway(config, repository, discounts);
})();
