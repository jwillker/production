package com.pasviegas.discounts.test

import java.text.SimpleDateFormat
import java.time.{LocalDate, ZoneId}
import java.util.Date

import com.pasviegas.discounts.database.models.{Product, User}
import com.pasviegas.discounts.rules.Rule
import com.pasviegas.discounts.rules.Rule.Discount
import com.pasviegas.discounts.v1.api.v1.{Details, GetDiscountsRequest}

package object mocks {

  // discounts
  lazy val noDiscount      = Discount(0, 0)
  lazy val tenPercentOf100 = Discount(10, 1000)

  // params
  lazy val productNoUser = Rule.Params(Some(chair), None)
  lazy val userNoProduct = Rule.Params(None, Some(user1))

  // products
  lazy val bottle = Product("GyhyFM3T3U88mg4d", "Bottle", "Good", 89000)
  lazy val chair  = Product("QoPvAyf9A5kntaUH", "Chair", "Bad", 10000)
  lazy val lamp   = Product("Gwck3TO3oxI6", "Lamp", "Ugly", 45600)
  lazy val candy  = Product("AeLRZ1pSSi54Eo21", "Candy", "Sweet", 12300)

  // users
  lazy val user1 = User("8PiisPOauwPZzWTT", "Pedro", "Viegas", birth("1988-06-01"))
  lazy val user2 = User("tARa/xEqGsljjYtl", "João", "Souza", birth("1988-03-10"))
  lazy val user3 = User("I2BoXtZMW20A6Zxc", "Lucas", "Koch", birth("1988-12-07"))
  lazy val user4 = User("MXPmNsurzjAlVxwO", "Bruno", "Porto", birth("1988-01-15"))

  lazy val february29User = User("RrPzFQhUQVQr6Yvv", "Wrong", "Guy", birth("2000-02-29"))
  lazy val birthdayUser   = User("P++Owqz4g3MCQ0nG", "Lucky", "Guy", today)
  lazy val unluckyUser    = User("1wWerzq9RejPIwaM", "Unlucky", "Guy", tomorrow)

  // requests
  lazy val simpleRequest    = GetDiscountsRequest(Some(Details("1")), chair.id, user1.id)
  lazy val birthdayRequest  = GetDiscountsRequest(Some(Details("1")), chair.id, birthdayUser.id)
  lazy val noProductRequest = GetDiscountsRequest(Some(Details("1")), "1", user1.id)
  lazy val noUserRequest    = GetDiscountsRequest(Some(Details("1")), chair.id, "1")
  lazy val noDetailsRequest = GetDiscountsRequest(None, chair.id, user1.id)

  def birth(value: String): Date = new SimpleDateFormat("yyyy-MM-dd").parse(value)

  def today: Date = new Date

  def tomorrow: Date =
    Date.from(LocalDate.now().plusDays(1).atStartOfDay(ZoneId.systemDefault).toInstant)
}
