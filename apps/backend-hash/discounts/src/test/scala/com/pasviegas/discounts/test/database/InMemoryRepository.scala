package com.pasviegas.discounts.test.database
import com.pasviegas.discounts.database.Repository
import com.pasviegas.discounts.database.models.{Product, User}

case object InMemoryRepository extends Repository {
  import com.pasviegas.discounts.test.mocks._

  def product(id: String): Option[Product] =
    Seq(chair, bottle, lamp, candy).find(p => p.id == id)

  def user(id: String): Option[User] =
    Seq(user1, user2, user3, user4, unluckyUser, birthdayUser, february29User).find(u => u.id == id)
}
