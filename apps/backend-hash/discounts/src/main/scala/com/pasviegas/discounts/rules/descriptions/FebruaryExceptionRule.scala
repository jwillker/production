package com.pasviegas.discounts.rules.descriptions

import java.time.Month
import java.util.Date

import com.pasviegas.discounts.rules.Rule.{Description, Params}
import com.pasviegas.discounts.support.Dates
import com.pasviegas.discounts.support.Exceptions.UsersCantBeBornOnFebruary29

import scala.util.{Failure, Success}

class FebruaryExceptionRule extends DefaultRule {

  /** If the parameters say the user was born on February 29,
    * it should return a failure, as no one can be registered on on February 29.
    */
  override protected def describe: Description = {
    case (discount, Params(_, Some(user))) =>
      if (invalidDate(user.dateOfBirth)) Failure(UsersCantBeBornOnFebruary29) else Success(discount)
  }

  private def invalidDate(dateOfBirth: Date) = {
    val date = Dates.localDate(dateOfBirth)
    date.getDayOfMonth == 29 && date.getMonth == Month.FEBRUARY
  }

}
