package com.pasviegas.discounts.api.core.grpc

import java.io.IOException

import io.grpc.{ServerBuilder, ServerServiceDefinition}

import scala.concurrent.{ExecutionContext, ExecutionContextExecutor}

object Server {
  type Builder = ServerBuilder[_ <: ServerBuilder[_]]
}

trait Server {

  protected val executor: ExecutionContextExecutor = ExecutionContext.global

  private val server = {
    services.foreach(builder.addService(_))
    builder.build
  }

  @throws[IOException]
  def start(): Unit = {
    server.start

    sys.addShutdownHook {
      server.shutdown()
    }
  }

  def stop(): Unit =
    if (server != null) server.shutdown

  @throws[InterruptedException]
  def blockUntilShutdown(): Unit =
    if (server != null) server.awaitTermination()

  protected def builder: Server.Builder

  protected def services: Seq[ServerServiceDefinition]
}
