package com.pasviegas.discounts.boot

import com.pasviegas.discounts.Application
import com.pasviegas.discounts.support.Configuration
import scalikejdbc.config.DBs

case class SetupDatabase(protected val config: Configuration) extends BootTask {
  private val logger = Application.logger(getClass)

  DBs.setupAll

  logger.info("Database setup completed with success!")
}
