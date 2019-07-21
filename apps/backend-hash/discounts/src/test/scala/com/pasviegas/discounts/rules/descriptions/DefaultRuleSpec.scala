package com.pasviegas.discounts.rules.descriptions

import com.pasviegas.discounts.rules.Rule.{Description, Discount}
import com.pasviegas.discounts.support.Exceptions.ProductNotFoundException
import org.scalatest._

import scala.util.{Failure, Success}

class DefaultRuleSpec extends FlatSpec with Matchers {

  import com.pasviegas.discounts.test.mocks._

  val fakeRule: DefaultRule = new DefaultRule() {
    override protected def describe: Description = {
      case (discount, _) => Success(discount)
    }
  }

  "With no product, rules" should "fail" in {
    val failure = fakeRule.apply(Success(noDiscount), userNoProduct)
    failure should be(Failure(ProductNotFoundException))
  }

  "With no user, rules" should "not apply a discount" in {
    val success = fakeRule.apply(Success(noDiscount), productNoUser)
    success shouldBe a[Success[_]]
    success should be(Success(Discount(0, 0)))
  }
}
