package com.pasviegas.discounts.api.v1.methods

import com.pasviegas.discounts.rules.registry.InMemoryRulesRegistry
import com.pasviegas.discounts.support.Exceptions.{DetailsNotFoundException, ProductNotFoundException}
import com.pasviegas.discounts.test.database.InMemoryRepository
import com.pasviegas.discounts.v1.api.v1.{Details, GetDiscountsResponse}
import org.scalatest._

import scala.util.{Failure, Success}

class GetDiscountsSpec extends FlatSpec with Matchers {

  import com.pasviegas.discounts.test.mocks._

  "Get discounts method" should "apply a discount when is the user birthday" in {
    val response = GetDiscounts(InMemoryRepository, InMemoryRulesRegistry).next(birthdayRequest)
    response should be(Success(GetDiscountsResponse(birthdayRequest.details, 10, 1000)))
  }

  "Get discounts method" should "not apply a discount when no rules match the request" in {
    val response = GetDiscounts(InMemoryRepository, InMemoryRulesRegistry).next(simpleRequest)
    response should be(Success(GetDiscountsResponse(simpleRequest.details)))
  }

  "Get discounts method" should "fail if no product is found" in {
    val response = GetDiscounts(InMemoryRepository, InMemoryRulesRegistry).next(noProductRequest)
    response should be(Failure(ProductNotFoundException))
  }

  "Get discounts method" should "not apply a discount when no user is found" in {
    val response = GetDiscounts(InMemoryRepository, InMemoryRulesRegistry).next(noUserRequest)
    response should be(Success(GetDiscountsResponse(noUserRequest.details)))
  }

  "Get discounts method" should "fail if no details provided" in {
    val response = GetDiscounts(InMemoryRepository, InMemoryRulesRegistry).next(noDetailsRequest)
    response should be(Failure(DetailsNotFoundException))
  }

  "Get discounts method" should "create a error response if needed" in {
    val error = GetDiscounts(InMemoryRepository, InMemoryRulesRegistry).error(noUserRequest, DetailsNotFoundException)
    error should be(GetDiscountsResponse(Some(Details("1", DetailsNotFoundException.getMessage))))
  }

}
