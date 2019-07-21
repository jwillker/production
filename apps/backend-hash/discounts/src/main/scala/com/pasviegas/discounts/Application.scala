package com.pasviegas.discounts

import java.util.logging.{Level, Logger}

import com.pasviegas.discounts.boot.{SetupDatabase, ShowApplicationBanner, StartApiServer}
import com.pasviegas.discounts.database.repositories.DatabaseRepository
import com.pasviegas.discounts.rules.registry.InMemoryRulesRegistry
import com.pasviegas.discounts.support.Configuration

object Application {

  private val config = new Configuration()

  @throws[Exception]
  def main(args: Array[String]): Unit = {
    ShowApplicationBanner(config)
    SetupDatabase(config)
    StartApiServer(config, DatabaseRepository, InMemoryRulesRegistry)
  }

  def logger(name: Class[_]): Logger = {
    val logger = Logger.getLogger(getClass.getName)
    logger.setLevel(Level.parse(config.log.level))
    logger
  }
}
