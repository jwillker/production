package com.pasviegas.discounts.database

import com.pasviegas.discounts.database.models.{Product, User}

trait Repository {

  def product(id: String): Option[Product]

  def user(id: String): Option[User]
}
