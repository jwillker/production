package com.pasviegas.discounts.test
import com.pasviegas.discounts.v1.api.v1.GetDiscountsResponse
import io.grpc.stub.StreamObserver
import org.scalatest.Assertion

import scala.concurrent.{Future, Promise}

package object api {

  def withServer(test: FlatSpecGrpcServer => Future[Assertion]): Future[Assertion] = {
    val server: FlatSpecGrpcServer = new FlatSpecGrpcServer
    server.before()
    try {
      test(server)
    } finally server.after()
  }

  def getDiscountsStream(promise: Promise[Assertion],
                         assert: GetDiscountsResponse => Unit): StreamObserver[GetDiscountsResponse] =
    new StreamObserver[GetDiscountsResponse] {
      override def onError(t: Throwable): Unit = {
        promise.failure(t)
      }

      override def onCompleted(): Unit = {}
      override def onNext(value: GetDiscountsResponse): Unit = {
        assert(value)
      }
    }

}
