package com.pasviegas.discounts.rules.descriptions

import com.pasviegas.discounts.rules.Rule.{Discount, Params}
import org.scalatest._

import scala.util.Success

class UserBirthdayRuleSpec extends FlatSpec with Matchers {

  import com.pasviegas.discounts.test.mocks._

  "User" should "get a 10 percent discount if its his birthday" in {
    val discount = new UserBirthdayRule().apply(Success(noDiscount), Params(Some(chair), Some(birthdayUser)))
    discount should be(Success(Discount(10, 1000)))
  }

  "User" should "get a 19 percent discount if its his birthday and he had another 10 percent" in {
    val discount = new UserBirthdayRule().apply(Success(tenPercentOf100), Params(Some(chair), Some(birthdayUser)))
    discount should be(Success(Discount(19, 1900)))
  }

  "User" should "not get a discount if he wasn'' born todat" in {
    val discount = new UserBirthdayRule().apply(Success(noDiscount), Params(Some(chair), Some(unluckyUser)))
    discount should be(Success(Discount(0, 0)))
  }
}
