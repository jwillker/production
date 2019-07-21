package com.pasviegas.discounts.database.models
import com.pasviegas.discounts.database.Model
import scalikejdbc.WrappedResultSet

case class Product(id: String, title: String, description: String, priceInCents: Int) extends Model

object Product {
  def apply(resultSet: WrappedResultSet): Product = Product(
    resultSet.string("id"),
    resultSet.string("title"),
    resultSet.string("description"),
    resultSet.int("price_in_cents")
  )
}
