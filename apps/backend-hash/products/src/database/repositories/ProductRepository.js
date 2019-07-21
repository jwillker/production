const { Product } = require('../models/Product');

class ProductRepository {
  constructor(database) {
    this.database = database;
  }

  async products() {
    const products = await this.database.select().from('products');
    return products.map(Product.fromDatabase);
  }
}

module.exports.ProductRepository = ProductRepository;
