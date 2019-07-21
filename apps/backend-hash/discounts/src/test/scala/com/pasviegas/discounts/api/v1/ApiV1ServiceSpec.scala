package com.pasviegas.discounts.api.v1
import com.pasviegas.discounts.rules.registry.InMemoryRulesRegistry
import com.pasviegas.discounts.test.database.InMemoryRepository
import com.pasviegas.discounts.v1.api.v1.{ApiGrpc, GetDiscountsRequest, GetDiscountsResponse}
import io.grpc.stub.StreamObserver
import org.scalatest._

import scala.concurrent.{ExecutionContext, Promise}
import scala.util.Try

class ApiV1ServiceSpec extends AsyncFlatSpec with Matchers {
  import com.pasviegas.discounts.test.api._
  import com.pasviegas.discounts.test.mocks._

  "When asking for a discount, you" should "get one!" in withServer { server =>
    val promise = Promise[Assertion]

    server.getServiceRegistry.addService(service)
    val stub = ApiGrpc.stub(server.getChannel)

    def assert: GetDiscountsResponse => Unit = (value: GetDiscountsResponse) => {
      promise.complete(Try {
        value should be(GetDiscountsResponse(birthdayRequest.details, 10, 1000))
      })
    }

    lazy val requestObserver: StreamObserver[GetDiscountsRequest] =
      stub.getDiscounts(getDiscountsStream(promise, assert))

    requestObserver.onNext(birthdayRequest)
    requestObserver.onCompleted()
    promise.future
  }
  private def service = {
    ApiV1Service(InMemoryRepository, InMemoryRulesRegistry, ExecutionContext.global)
  }
}
