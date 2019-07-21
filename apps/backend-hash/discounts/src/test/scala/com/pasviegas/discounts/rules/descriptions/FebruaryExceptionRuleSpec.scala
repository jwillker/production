package com.pasviegas.discounts.rules.descriptions

import com.pasviegas.discounts.rules.Rule.Params
import com.pasviegas.discounts.support.Exceptions.UsersCantBeBornOnFebruary29
import org.scalatest._

import scala.util.{Failure, Success}

class FebruaryExceptionRuleSpec extends FlatSpec with Matchers {

  import com.pasviegas.discounts.test.mocks._

  "User" should "not be born on February 29" in {
    val failure = new FebruaryExceptionRule().apply(Success(noDiscount), Params(Some(chair), Some(february29User)))
    failure should be(Failure(UsersCantBeBornOnFebruary29))
  }
}
