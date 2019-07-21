package com.pasviegas.discounts.api.core.methods
import scala.util.Try

/** Base trait to represent a rpc method.
  *
  * Requests are responded as a [[Try]] to encapsulate any possible error.
  *
  * Errors are also wrapped so they can be returned to the client without breaking the flow
  * in case of a stream.
  *
  * @tparam I - the input for the method, should be the type of the rpc method parameter.
  * @tparam O - the output from the method, should be the type of the rpc method return.
  */
trait Method[I, O] {

  def next(request: I): Try[O]

  def error(request: I, error: Throwable): O
}
