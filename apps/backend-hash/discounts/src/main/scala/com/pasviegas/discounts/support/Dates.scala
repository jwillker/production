package com.pasviegas.discounts.support
import java.time.{LocalDate, ZoneId}
import java.util.Date

object Dates {

  def localDate(date: Date): LocalDate = date.toInstant.atZone(ZoneId.systemDefault()).toLocalDate
}
