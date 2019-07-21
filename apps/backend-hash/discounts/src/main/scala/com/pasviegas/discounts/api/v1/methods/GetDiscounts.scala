package com.pasviegas.discounts.api.v1.methods
import com.pasviegas.discounts.api.core.methods.Method
import com.pasviegas.discounts.database.Repository
import com.pasviegas.discounts.rules.{Rule, RulesRegistry}
import com.pasviegas.discounts.support.Exceptions.DetailsNotFoundException
import com.pasviegas.discounts.v1.api.v1.{GetDiscountsRequest, GetDiscountsResponse}

import scala.util.{Failure, Try}

case class GetDiscounts(private val repository: Repository, private val rules: RulesRegistry[_])
    extends Method[GetDiscountsRequest, GetDiscountsResponse] {

  /** Process the getDiscounts request, returning the final discounts or a failure.
    *
    * @param request - the getDiscounts request parameter.
    * @return the outcome from applying all active discount rules.
    */
  override def next(request: GetDiscountsRequest): Try[GetDiscountsResponse] = request.details match {
    case Some(_) => applyRules(request)
    case None    => Failure(DetailsNotFoundException)
  }

  /** Applies all discount rules given the request.
    *
    * @param request - the getDiscounts request parameter.
    * @return the final discount.
    */
  private def applyRules(request: GetDiscountsRequest) =
    rules
      .apply(params(request))
      .map(d => GetDiscountsResponse(request.details, d.percent, d.valueInCents))

  /** Retrieves the product and user from the repository using the getDiscounts request and creates
    * the discount rules parameters.
    *
    * @param request - the getDiscounts request parameter.
    * @return the discount rules parameters.
    */
  private def params(request: GetDiscountsRequest): Rule.Params =
    Rule.Params(repository.product(request.productId), repository.user(request.userId))

  /** Wraps any error in a response.
    *
    * @param request - the getDiscounts request parameter.
    * @param error - any possible failure that may have occurred in the discount rules application.
    */
  override def error(request: GetDiscountsRequest, error: Throwable): GetDiscountsResponse =
    GetDiscountsResponse(request.details.map(d => d.withError(error.getMessage)))

}
