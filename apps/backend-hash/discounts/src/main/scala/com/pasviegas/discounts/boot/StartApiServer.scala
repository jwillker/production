package com.pasviegas.discounts.boot

import com.pasviegas.discounts.Application
import com.pasviegas.discounts.api.ApiServer
import com.pasviegas.discounts.database.Repository
import com.pasviegas.discounts.rules.RulesRegistry
import com.pasviegas.discounts.support.Configuration

case class StartApiServer(protected val config: Configuration,
                          private val repository: Repository,
                          private val rules: RulesRegistry[_])
    extends BootTask {

  private val logger = Application.logger(getClass)

  private val server = ApiServer(config, repository, rules)
  server.start()

  logger.info(s"Server started on 0.0.0.0${config.grpc.port} with success!")
  server.blockUntilShutdown()
}
