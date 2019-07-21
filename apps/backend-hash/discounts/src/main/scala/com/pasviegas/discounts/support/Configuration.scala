package com.pasviegas.discounts.support

import com.typesafe.config.{Config, ConfigFactory}

class Configuration {
  import net.ceedubs.ficus.Ficus._

  private val config: Config = ConfigFactory.load()

  def app: AppConfig.type = AppConfig

  def log: LogConfig.type = LogConfig

  def grpc: GrpcConfig.type = GrpcConfig

  def database: DatabaseConfig.type = DatabaseConfig

  object AppConfig {
    def name: String = config.as[String]("app.name")
    def env: String  = config.as[String]("app.env")
  }

  object LogConfig {
    def level: String = config.as[String]("log.level")
  }

  object GrpcConfig {
    def port: Int = config.as[Int]("grpc.port")
  }

  object DatabaseConfig {
    def host: String = config.as[String]("database.host")
    def name: String = config.as[String]("database.name")
    def user: String = config.as[String]("database.user")
    def pass: String = config.as[String]("database.pass")
  }
}
