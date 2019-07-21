package com.pasviegas.discounts.support

object Percent {

  /** Gives the percent of the part from the total.
    *
    * e.g. 9 of 10 is 90%
    *
    * @param part - the amount representing the percentage as part of the total.
    * @param total - total value.
    */
  def of(part: Int, total: Int): Int = ((part.toFloat / total) * 100).toInt

  /** Calculates the value int value of a percentage.
    *
    * e.g. 10% of 10 is 1
    *
    * @param percent - percentage of the whole value.
    * @param value - total value.
    */
  def calculate(percent: Float, value: Int): Int = (value * (percent / 100)).toInt
}
