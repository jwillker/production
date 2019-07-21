class GetDiscountRequest {
  static fromProduct(product, userId) {
    return new GetDiscountRequest({ request_id: product.id }, product.id, userId);
  }

  constructor(details, productId, userId) {
    this.details = details;
    this.product_id = productId;
    this.user_id = userId;
  }
}

module.exports.GetDiscountRequest = GetDiscountRequest;
