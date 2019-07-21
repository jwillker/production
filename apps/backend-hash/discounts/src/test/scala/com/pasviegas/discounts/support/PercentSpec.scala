package com.pasviegas.discounts.support

import org.scalatest._

class PercentSpec extends FlatSpec with Matchers {

  "10 percent of 360" should "be 10" in {
    Percent.calculate(10, 360) should be(36)
  }

  "90 of 360" should "be 25 percent" in {
    Percent.of(90, 360) should be(25)
  }

}
