# Security Group and rules

resource "aws_security_group" "security_group" {
  count       = "${var.create ? 1 : 0}"
  name        = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  description = "${var.description}"

  tags = "${map("Name", "${var.name}")}"

}

resource "aws_security_group_rule" "ingress" {
  count             = "${var.create ? length(var.ingress_rules) : 0}"
  description       = "${element(var.rules[var.ingress_rules[count.index]], 3)}"
  type              = "ingress"

  security_group_id = "${aws_security_group.security_group.id}"
  cidr_blocks       = ["${var.ingress_cidr_blocks}"]

  from_port = "${element(var.rules[var.ingress_rules[count.index]], 0)}"
  to_port   = "${element(var.rules[var.ingress_rules[count.index]], 1)}"
  protocol  = "${element(var.rules[var.ingress_rules[count.index]], 2)}"
}

resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
  count = "${var.create ? length(var.ingress_with_cidr_blocks) : 0}"

  security_group_id = "${aws_security_group.security_group.id}"
  type              = "ingress"

  cidr_blocks     = ["${split(",", lookup(var.ingress_with_cidr_blocks[count.index], "cidr_blocks", join(",", var.ingress_cidr_blocks)))}"]
  description     = "${element(var.rules[var.ingress_rules[count.index]], 3)}"

  from_port = "${lookup(var.ingress_with_cidr_blocks[count.index], "from_port", element(var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")], 0))}"
  to_port   = "${lookup(var.ingress_with_cidr_blocks[count.index], "to_port", element(var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")], 1))}"
  protocol  = "${lookup(var.ingress_with_cidr_blocks[count.index], "protocol", element(var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")], 2))}"
}

resource "aws_security_group_rule" "egress_rules" {
  count = "${var.create ? length(var.egress_rules) : 0}"

  security_group_id = "${aws_security_group.security_group.id}"
  type              = "egress"

  cidr_blocks      = ["${var.egress_cidr_blocks}"]
  description      = "${element(var.rules[var.egress_rules[count.index]], 3)}"

  from_port = "${element(var.rules[var.egress_rules[count.index]], 0)}"
  to_port   = "${element(var.rules[var.egress_rules[count.index]], 1)}"
  protocol  = "${element(var.rules[var.egress_rules[count.index]], 2)}"
}
