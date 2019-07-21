package com.pasviegas.discounts.rules.registry

import com.pasviegas.discounts.rules.Rule.{Discount, Params}
import com.pasviegas.discounts.support.Exceptions.UsersCantBeBornOnFebruary29
import org.scalatest._

import scala.util.{Failure, Success}

class InMemoryRulesRegistrySpec extends FlatSpec with Matchers {

  import com.pasviegas.discounts.test.mocks._

  "In memory registry" should "apply february rule in necessary" in {
    val failure = InMemoryRulesRegistry.apply(Params(Some(chair), Some(february29User)))
    failure should be(Failure(UsersCantBeBornOnFebruary29))
  }

  "In memory registry" should "apply user birthday rule in necessary" in {
    val discount = InMemoryRulesRegistry.apply(Params(Some(chair), Some(birthdayUser)))
    discount should be(Success(Discount(10, 1000)))
  }
}
