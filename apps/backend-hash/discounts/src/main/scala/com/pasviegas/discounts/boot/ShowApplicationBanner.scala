package com.pasviegas.discounts.boot
import com.github.lalyos.jfiglet.FigletFont
import com.pasviegas.discounts.support.Configuration

case class ShowApplicationBanner(protected val config: Configuration) extends BootTask {
  println(FigletFont.convertOneLine(config.app.name)) // scalastyle:ignore
}
