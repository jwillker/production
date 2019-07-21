package com.pasviegas.discounts.database.repositories

import com.pasviegas.discounts.database.models.{Product, User}
import org.scalatest._

class DatabaseRepositorySpec extends FlatSpec with Matchers {
  import com.pasviegas.discounts.test.database._
  import com.pasviegas.discounts.test.mocks._

  "database repository" should "return the product with corresponding id" in withSession { _ =>
    DatabaseRepository.product("GyhyFM3T3U88mg4d") should be(Some(Product("GyhyFM3T3U88mg4d", "Bottle", "Good", 890)))
  }

  "database repository" should "return the user with corresponding id" in withSession { _ =>
    DatabaseRepository.user("8PiisPOauwPZzWTT") should be(
      Some(User("8PiisPOauwPZzWTT", "Pedro", "Viegas", birth("1988-06-01"))))
  }

}
