package com.pasviegas.discounts.rules.descriptions

import com.pasviegas.discounts.rules.Rule
import com.pasviegas.discounts.rules.Rule.{Discount, Params}
import com.pasviegas.discounts.support.Exceptions.ProductNotFoundException

import scala.util.{Failure, Success, Try}

abstract class DefaultRule extends Rule {

  /** Applies the underlying rule, guarding it from possible incomplete parameters.
    *
    * @param existingDiscount - any pre-existing discount.
    * @param params - the necessary parameters for the rules to be applied.
    * @return the outcome from applying all active discount rules.
    */
  override def apply(existingDiscount: Try[Discount], params: Params): Try[Discount] =
    existingDiscount.flatMap(discount => guard.applyOrElse((discount, params), describe))

  /** Guards any rule from receiving incomplete parameters.
    *
    * If there is no product, it should return a failure.
    *
    */
  private def guard: Rule.Description = {
    case (_, Params(None, _))        => Failure(ProductNotFoundException)
    case (discount, Params(_, None)) => Success(discount)
  }
}
