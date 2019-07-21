resource "aws_instance" "instance" {
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  user_data_base64 = "${var.user_data_base64}"
  count            = "${var.servers}"
  key_name         = "${var.key_name}"
  subnet_id        = "${var.subnet_id}"

  availability_zone           = "${var.availability_zone}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = "${var.public_ip_address}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]

  tags = "${merge(map("Name", format("%s", var.name)), var.tags)}"

  #depends_on = ["${var.depends_on}"]
  lifecycle {
    create_before_destroy = true
  }
}

# TODO add key_pair create resource
