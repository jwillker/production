package com.pasviegas.discounts.database.repositories

import com.pasviegas.discounts.database.Repository
import com.pasviegas.discounts.database.models.{Product, User}

case object DatabaseRepository extends Repository {

  import scalikejdbc._

  implicit val session: AutoSession.type = AutoSession

  override def product(id: String): Option[Product] = DB readOnly { implicit session =>
    sql"select * from products where id = ${id}"
      .map(Product(_))
      .single
      .apply()
  }

  override def user(id: String): Option[User] = DB readOnly { implicit session =>
    sql"select * from users where id = ${id}"
      .map(User(_))
      .single
      .apply()
  }
}
