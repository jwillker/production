lazy val root = (project in file("."))
  .settings(
    name := "discounts",
    inThisBuild(
      List(
        organization := "com.pasviegas",
        scalaVersion := "2.12.7",
        version := "0.1.0-SNAPSHOT"
      )
    ),
    libraryDependencies ++= Seq(
      "io.grpc"              % "grpc-testing"          % scalapb.compiler.Version.grpcJavaVersion,
      "io.grpc"              % "grpc-netty"            % scalapb.compiler.Version.grpcJavaVersion,
      "com.thesamet.scalapb" %% "scalapb-runtime-grpc" % scalapb.compiler.Version.scalapbVersion,
      "com.thesamet.scalapb" %% "scalapb-runtime"      % scalapb.compiler.Version.scalapbVersion % "protobuf",
      "org.scalikejdbc"      %% "scalikejdbc"          % "3.3.0",
      "org.scalikejdbc"      %% "scalikejdbc-config"   % "3.3.0",
      "mysql"                % "mysql-connector-java"  % "5.1.46",
      "com.github.lalyos"    % "jfiglet"               % "0.0.8",
      "com.iheart"           %% "ficus"                % "1.4.4",
      "com.h2database"       % "h2"                    % "1.4.197" % Test,
      "org.scalikejdbc"      %% "scalikejdbc-test"     % "3.3.0" % Test,
      "org.scalatest"        %% "scalatest"            % "3.0.5" % Test
    )
  )
  .settings(scalaPbSettings)
  .settings(scalafmtSettings)
  .settings(coverageSettings)
  .settings(packageSettings)

// *****************************************************************************
// Settings
// *****************************************************************************

lazy val scalaPbSettings = Seq(
  PB.targets in Compile := Seq(scalapb.gen() -> (sourceManaged in Compile).value)
)

lazy val scalafmtSettings = Seq(
  scalafmtOnCompile := true,
  scalafmtOnCompile.in(Sbt) := false,
  scalafmtVersion := "1.3.0"
)

lazy val packageSettings = Seq(
  mainClass in assembly := Some("com.pasviegas.discounts.Application"),
  assemblyJarName in assembly := s"discounts-api-runnable.jar",
  test in assembly := {},
  assemblyMergeStrategy in assembly := {
    case x if x.endsWith("io.netty.versions.properties") => MergeStrategy.first
    case x =>
      val oldStrategy = (assemblyMergeStrategy in assembly).value
      oldStrategy(x)
  }
)

lazy val coverageSettings = Seq(
  coverageExcludedPackages := Seq(
    "com\\.pasviegas\\.discounts\\.v1\\.api\\.v1\\..*",
    "com\\.pasviegas\\.discounts\\.api\\.core\\..*",
    "com\\.pasviegas\\.discounts\\.boot\\..*",
    "com\\.pasviegas\\.discounts\\.support\\.Configuration",
    "com\\.pasviegas\\.discounts\\.Application",
    "com\\.pasviegas\\.discounts\\.api\\.ApiServer",
  ).mkString(";")
)
