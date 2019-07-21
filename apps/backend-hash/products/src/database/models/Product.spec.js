const { Product } = require('./Product');

test('should create a full product from another ', () => {
  const product = new Product({
    id: 'id',
    title: 'title',
    description: 'description',
    priceInCents: 100,
  });
  expect(product.id).toBe('id');
  expect(product.title).toBe('title');
  expect(product.description).toBe('description');
  expect(product.priceInCents).toBe(100);
});

test('should create a full product from a resultset', () => {
  const product = Product.fromDatabase({
    id: 'id',
    title: 'title',
    description: 'description',
    price_in_cents: 100,
  });
  expect(product.id).toBe('id');
  expect(product.title).toBe('title');
  expect(product.description).toBe('description');
  expect(product.priceInCents).toBe(100);
});
