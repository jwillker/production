const { ProductRepository } = require('./ProductRepository');
const { Product } = require('../models/Product');

test('should not return products from database', async () => {
  const fakeProduct = {
    id: 'id',
    title: 'title',
    description: 'description',
    priceInCents: 100,
  };

  const fakeDatabase = {
    select: jest.fn().mockReturnValue({ from: jest.fn().mockResolvedValue([fakeProduct]) }),
  };

  const result = await new ProductRepository(fakeDatabase).products();
  expect(result).toEqual(expect.arrayContaining([Product.fromDatabase(fakeProduct)]));
});
