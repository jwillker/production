package com.pasviegas.discounts.api.core.streams
import com.pasviegas.discounts.Application
import com.pasviegas.discounts.api.core.methods.Method
import io.grpc.stub.StreamObserver

import scala.util.{Failure, Success}

/** Manages streams from bidirectional streaming rpc methods.
  *
  * Applies a [[Method]] implementation to any incoming stream value. Managing successes,
  * failures, errors and streams completions.
  *
  * @param response - the [[StreamObserver]] responsible to return processed values to the client.
  * @param method - the implementation of the rpc method.
  * @tparam I - the input for the method, should be the type of the rpc method parameter.
  * @tparam O - the output from the method, should be the type of the rpc method return.
  */
case class BidirectionalStream[I <: Any, O <: Any](private val response: StreamObserver[O],
                                                   private val method: Method[I, O])
    extends StreamObserver[I] {

  private val logger = Application.logger(getClass)

  override def onNext(request: I): Unit = {
    logger.info(s"Will execute method ${method.getClass.getSimpleName} with $request")

    method.next(request) match {
      case Success(message) =>
        logger.info(s"onNext (${method.getClass.getSimpleName}): $message")
        response.onNext(message)
      case Failure(throwable) =>
        logger.info(s"onNext (${method.getClass.getSimpleName}): ${throwable.getMessage}")
        response.onNext(method.error(request, throwable))
    }
  }

  override def onError(error: Throwable): Unit = {
    logger.severe(s"onError (${method.getClass.getSimpleName}): ${error.getMessage}")
    response.onError(error)
  }

  override def onCompleted(): Unit = {
    logger.info(s"onCompleted (${method.getClass.getSimpleName})")
    response.onCompleted()
  }

}
