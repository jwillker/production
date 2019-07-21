const { GetDiscountRequest } = require('./GetDiscountRequest');

test('should create a request from a product and user', () => {
  const product = {
    id: 'id',
    title: 'title',
    description: 'description',
    priceInCents: 100,
  };

  const request = GetDiscountRequest.fromProduct(product, '1');

  expect(request.details.request_id).toBe('id');
  expect(request.product_id).toBe('id');
  expect(request.user_id).toBe('1');
});
