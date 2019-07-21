package com.pasviegas.discounts.database.models
import java.util.Date

import com.pasviegas.discounts.database.Model
import scalikejdbc.WrappedResultSet

case class User(id: String, firstName: String, lastName: String, dateOfBirth: Date) extends Model

object User {
  def apply(resultSet: WrappedResultSet): User = User(
    resultSet.string("id"),
    resultSet.string("first_name"),
    resultSet.string("last_name"),
    new Date(resultSet.date("date_of_birth").getTime)
  )
}
