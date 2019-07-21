const { GetProducts } = require('./GetProducts');
const { Product } = require('../../../database/models/Product');
const { DuplexMock } = require('stream-mock');

const repository = {
  async products() {
    return [
      new Product({
        id: '111',
        title: '222',
        description: '323233',
        priceInCents: 1200,
      }),
    ];
  },
};

test('should not apply discounts when no user has been set', () => {
  const getProducts = new GetProducts(repository, {});
  let verifyDiscount = getProducts.shouldVerifyDiscount(null, []);

  expect(verifyDiscount).toBe(false);
});

test('should not apply discounts when no product will be returned', () => {
  const getProducts = new GetProducts(repository, {});
  let verifyDiscount = getProducts.shouldVerifyDiscount('123123', []);

  expect(verifyDiscount).toBe(false);
});

test('should apply discounts when the user and products are set', () => {
  const getProducts = new GetProducts(repository, {});
  let verifyDiscount = getProducts.shouldVerifyDiscount('123123', ['']);

  expect(verifyDiscount).toBe(true);
});

test('should create a products response from product model', () => {
  const product = new Product({
    id: 'id',
    title: 'title',
    description: 'description',
    priceInCents: 100,
  });

  const getProducts = new GetProducts(repository, {});
  let response = getProducts.toProductResponse(product);

  expect(response.id).toBe('id');
  expect(response.title).toBe('title');
  expect(response.description).toBe('description');
  expect(response.price_in_cents).toBe(100);
  expect(response.discount.pct).toBe(0);
  expect(response.discount.value_in_cents).toBe(0);
});

test('should return the products even if they dont have discounts', () => {
  const product = new Product({
    id: 'id',
    title: 'title',
    description: 'description',
    priceInCents: 100,
  });

  const getProducts = new GetProducts(repository, {});
  let updated = getProducts.updateWithResults(product, []);

  expect(updated.id).toBe('id');
  expect(updated.title).toBe('title');
  expect(updated.description).toBe('description');
  expect(updated.priceInCents).toBe(100);
});

test('should update the products if they have discounts', () => {
  const response = [{ details: { request_id: 'id' }, pct: 10, value_in_cents: 20 }];
  const product = new Product({
    id: 'id',
    title: 'title',
    description: 'description',
    priceInCents: 100,
  });

  const getProducts = new GetProducts(repository, {});
  let updated = getProducts.updateWithResults(product, response);

  expect(updated.id).toBe('id');
  expect(updated.title).toBe('title');
  expect(updated.description).toBe('description');
  expect(updated.priceInCents).toBe(100);
  expect(updated.discount.pct).toBe(10);
  expect(updated.discount.value_in_cents).toBe(20);
});

test('should get the result from the discount stream', async () => {
  const stream = new DuplexMock({ readableObjectMode: true, writableObjectMode: true });
  const client = { getDiscounts: () => stream };
  const product = new Product({
    id: 'id',
    title: 'title',
    description: 'description',
    priceInCents: 100,
  });

  const getProducts = new GetProducts(repository, client);
  let response = await getProducts.getDiscounts([product], '1');

  expect(response.length).toBe(1);
});

test('should get the product list with no discount if no user was provided', async () => {
  const stream = new DuplexMock({ readableObjectMode: true, writableObjectMode: true });
  const client = { getDiscounts: jest.fn().mockReturnValue(stream) };

  const getProducts = new GetProducts(repository, client);
  await getProducts.execute({ metadata: new Map() }, (_, response) => {
    expect(client.getDiscounts).toHaveBeenCalledTimes(0);
    expect(response.products.length).toBe(1);
  });
});

test('should get the product list with discount if a user was provided', async () => {
  const stream = new DuplexMock({ readableObjectMode: true, writableObjectMode: true });
  const client = { getDiscounts: jest.fn().mockReturnValue(stream) };

  const getProducts = new GetProducts(repository, client);
  await getProducts.execute({ metadata: new Map([['x-user-id', ['1']]]) }, (_, response) => {
    expect(client.getDiscounts).toHaveBeenCalledTimes(1);
    expect(response.products.length).toBe(1);
  });
});
