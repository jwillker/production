package com.pasviegas.discounts.test

import io.grpc.testing.GrpcServerRule

class FlatSpecGrpcServer extends GrpcServerRule {
  override def after(): Unit = super.after()

  override def before(): Unit = super.before()
}
