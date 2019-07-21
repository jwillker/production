package com.pasviegas.discounts.rules.registry

import com.pasviegas.discounts.rules.descriptions.{FebruaryExceptionRule, UserBirthdayRule}
import com.pasviegas.discounts.rules.{Rule, RulesRegistry}

case object InMemoryRulesRegistry extends RulesRegistry[Seq[Rule]] {

  override protected def active: Seq[Rule] = source

  override protected def source: Seq[Rule] = Seq(new UserBirthdayRule, new FebruaryExceptionRule)
}
