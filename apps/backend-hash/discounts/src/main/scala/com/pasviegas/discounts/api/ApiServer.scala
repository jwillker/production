package com.pasviegas.discounts.api
import com.pasviegas.discounts.api.core.grpc.Server
import com.pasviegas.discounts.api.v1.ApiV1Service
import com.pasviegas.discounts.database.Repository
import com.pasviegas.discounts.rules.RulesRegistry
import com.pasviegas.discounts.support.Configuration
import io.grpc.{ServerBuilder, ServerServiceDefinition}

class ApiServer(protected override val builder: Server.Builder, repository: Repository, rules: RulesRegistry[_])
    extends Server {

  override protected def services: Seq[ServerServiceDefinition] =
    Seq(ApiV1Service(repository, rules, executor))
}

object ApiServer {

  def apply(config: Configuration, repository: Repository, rules: RulesRegistry[_]): ApiServer =
    ApiServer(ServerBuilder.forPort(config.grpc.port), repository, rules)

  def apply(builder: Server.Builder, repository: Repository, rules: RulesRegistry[_]): ApiServer =
    new ApiServer(builder, repository, rules)

}
