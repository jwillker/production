class Product {
  static fromDatabase({ id, title, description, price_in_cents }) {
    return new Product({
      id,
      title,
      description,
      priceInCents: price_in_cents,
    });
  }

  constructor({ id, title, description, priceInCents }) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.priceInCents = priceInCents;
  }
}

module.exports.Product = Product;
