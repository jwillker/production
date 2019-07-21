package com.pasviegas.discounts.support

object Exceptions {
  case object DetailsNotFoundException extends Exception("No details provided in the request")

  case object ProductNotFoundException extends Exception("No product found with given id!")

  case object UsersCantBeBornOnFebruary29 extends Exception("Users can't be born on February 29th")
}
