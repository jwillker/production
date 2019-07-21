package com.pasviegas.discounts.rules

import com.pasviegas.discounts.database.models.{Product, User}
import com.pasviegas.discounts.rules.Rule.{Discount, Params}
import com.pasviegas.discounts.support.Percent

import scala.util.Try

/** Domain model responsible to represent a discount rule.
  *
  * A Rule describes how the discount is applied for each parameter.
  *
  * After a rule has been applied the outcome is a final discount or a failure.
  */
trait Rule {

  def apply(existingDiscount: Try[Discount], params: Params): Try[Discount]

  protected def describe: Rule.Description
}

object Rule {
  type Description = PartialFunction[(Discount, Params), Try[Discount]]

  /** The representation of a discount.
    *
    * @param percent - how much was discounted from the original value.
    * @param valueInCents - total discount in cents.
    */
  case class Discount(percent: Float, valueInCents: Int) {

    /** Compounds the existing discount with a new percentage using a base product.
      *
      * @param product - the product with total price for the discount to be compounded on.
      * @param percent - the new percentage to be compounded.
      */
    def compound(product: Product, percent: Float): Discount = {
      val finalPercent = Percent.calculate(percent, product.priceInCents - valueInCents) + valueInCents
      Discount(Percent.of(finalPercent, product.priceInCents), finalPercent)
    }
  }

  /** The necessary parameters for the rules to be applied.
    *
    * @param product - the product for the rules to be applied.
    * @param user - the user that the discounts will be applied for.
    */
  case class Params(product: Option[Product], user: Option[User])

  object Discount {

    /** Empty (Zero) representation of a Discount. */
    def empty: Discount = Discount(0, 0)
  }

}
