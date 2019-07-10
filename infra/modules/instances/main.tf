resource "aws_instance" "instance" {
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  user_data_base64 = "${var.user_data_base64}"
  count            = "${var.count}"
  key_name         = "${var.key_name}"

  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

  tags = "${merge(map("Name", format("%s", var.name)), var.tags)}"

  lifecycle {
    create_before_destroy = true
  }
}
