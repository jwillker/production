package com.pasviegas.discounts.rules

import com.pasviegas.discounts.rules.Rule.{Discount, Params}

import scala.util.Try

/** Trait that describes how rules should be accessed in the system.
  *
  * @tparam T - the source in which the repository fetches the rules.
  */
trait RulesRegistry[T] {

  /** Applies all active discount rules, compounding the discounts.
    *
    * @param params - the necessary parameters for the rules to be applied.
    * @param initial - pre-existing discount to be applied if necessary, otherwise the empty value of [[Discount]]
    *                is used.
    * @return the outcome from applying all active discount rules, if success it contains the final discount,
    *         otherwise contains the failure.
    */
  def apply(params: Params, initial: Discount = Discount.empty): Try[Discount] =
    active.foldLeft(Try(initial)) { (discount, rule) =>
      rule.apply(discount, params)
    }

  protected def source: T

  protected def active: Seq[Rule]

}
