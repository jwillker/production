package com.pasviegas.discounts.rules

import com.pasviegas.discounts.rules.Rule.Discount
import org.scalatest._

class RuleSpec extends FlatSpec with Matchers {

  import com.pasviegas.discounts.test.mocks._

  "Discount" should "empty representation should be 0,0" in {
    Discount.empty should be(Discount(0, 0))
  }

  "Discount" should "compound with more percentages" in {
    val newDiscount = tenPercentOf100.compound(chair, 10)
    newDiscount should be(Discount(19, 1900))
  }
}
