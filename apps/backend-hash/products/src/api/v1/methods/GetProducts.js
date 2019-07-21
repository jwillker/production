const R = require('ramda');
const logger = require('loglevel');

const { Method } = require('../../core/method/Method');
const { CollectStream } = require('../../core/streams/CollectStream');
const { GetDiscountRequest } = require('../../../external/models/GetDiscountRequest');

class GetProducts extends Method {
  constructor(repository, client) {
    super();
    this.client = client;
    this.repository = repository;
  }

  /** Fetches the list of products and checks whether it should apply discounts or not and returns
   * the update list to the user.
   *
   * If the user id (header X-USER-ID) is set, the discounts should be applied.
   *
   * @param request {Object} - contains the request properties for the call
   * @param respond {Function} - callback that ends the request with the given products
   */
  async execute(request, respond) {
    logger.info(`Will execute method getProducts`);

    const userId = this.userId(request);
    const products = await this.repository.products();

    if (this.shouldVerifyDiscount(userId, products)) {
      const results = await this.getDiscounts(products, userId);

      logger.info(`Discounts for user ${userId} applied: ${results.length}`);
      respond(null, {
        products: products.map(p => this.updateWithResults(p, results)).map(this.toProductResponse),
      });
    } else {
      logger.info(`Discounts not applied`);
      respond(null, {
        products: products.map(this.toProductResponse),
      });
    }
  }

  /** Process all products into requests to the discount service, collecting the
   * responses into a list.
   *
   * @param products {Array<Product>} - list of products to apply discounts
   * @param userId {String} - the user id
   * @returns {Promise<Array<Object>>} - list of responses collected
   */
  getDiscounts(products, userId) {
    return new CollectStream(this.client.getDiscounts()).process(
      products.map(p => GetDiscountRequest.fromProduct(p, userId))
    );
  }

  /** Updates the list of products with the discounts resulted from the discount
   * service call.
   *
   * @param product {Product} - the product to be updated
   * @param results {Array<Object>} - the list of discounts to be applied
   * @returns {Object} - the product with the applied discount
   */
  updateWithResults(product, results) {
    const update = results.find(r => r.details.request_id === product.id);
    return update ? R.assoc('discount', R.dissoc('details', update), product) : product;
  }

  /** Normalizes the product and discount information so that it can be returned to the user.
   *
   * If no discount returned from the discount service, the product will have the discounts object,
   * but with the inner fields indicating no discount.
   *
   * @param id
   * @param title
   * @param description
   * @param priceInCents
   * @param discount
   * @returns   {{
   *              id: String,
   *              title: String,
   *              description: String,
   *              price_in_cents: number,
   *              discount: {value_in_cents: number, pct: number},
   *            }}
   */
  toProductResponse({
    id,
    title,
    description,
    priceInCents,
    discount = { value_in_cents: 0, pct: 0 },
  }) {
    return { id, title, description, discount, price_in_cents: priceInCents };
  }

  /** Checks if the discount service should be called.
   *
   * @param userId {String|null} - the user id to be used when calling for the discounts.
   * @param products {Array<Product>} - the products that the discounts may be applied.
   * @returns {boolean}
   */
  shouldVerifyDiscount(userId, products) {
    return products.length > 0 && !!userId;
  }
}

module.exports.GetProducts = GetProducts;
