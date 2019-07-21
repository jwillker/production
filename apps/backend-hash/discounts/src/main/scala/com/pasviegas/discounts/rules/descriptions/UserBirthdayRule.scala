package com.pasviegas.discounts.rules.descriptions

import java.time.LocalDate
import java.util.Date

import com.pasviegas.discounts.database.models.Product
import com.pasviegas.discounts.rules.Rule.{Description, Discount, Params}
import com.pasviegas.discounts.support.Dates

import scala.util.{Success, Try}

class UserBirthdayRule extends DefaultRule {

  /** Fixed discount for the User Birthday Rule is 10%. */
  private val discountPercent = 10

  /** If the user was born in the same day as rule is being applied,
    * it should get a discount.
    */
  override protected def describe: Description = {
    case (existingDiscount, Params(Some(product), Some(user))) =>
      if (sameDay(user.dateOfBirth)) {
        computeDiscount(existingDiscount, product)
      } else {
        Success(existingDiscount)
      }
  }

  private def computeDiscount(discount: Discount, product: Product): Try[Discount] = Try {
    discount.compound(product, discountPercent)
  }

  private def sameDay(dateOfBirth: Date) = LocalDate.now.equals(Dates.localDate(dateOfBirth))
}
