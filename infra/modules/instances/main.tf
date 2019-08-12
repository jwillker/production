# ssh -i './deploy-key' <instance ip or dns>

# Not a production key, just for this module
resource "aws_key_pair" "deploy" {
  key_name   = "deploy-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+JU1XbsRml+fYSncdjJ3MAgt2NX5wsUmF0cnMSdfBWcJ3dygiKcnnj5FKPeNSOnHyYUKciFvmHZ0kVvX4pS5zmD1eZhB1iaHdnOFeSVN6tB+PnRdtUxtxIGyA89pb//0Xc01cWd6mGsXGXMHVZmc/D6iPWPXUJMK7o5Oc6uwWaFYBf0lB0105c0X6zUxKeix2sh7D6zWwYJCHjwPfljHKLcpJxOQpMM2Ja/tzdG95sWnfvTIBT/lmoUhJ3yZP6fVJgfa36PGykYxihyvW3xO3SN4l0ywXcse2vKC9qu+KUZ5nqZ7VKys6r1ix30nuuhZDzEbMHP76BitnEtoTGfVRPe1ASGPitsDJd3/VIjp2XnwkjMGV/Da7gnvCJtIIxLa4d52F4vs60HXtX40Ja+6c2FFdoSQg2ULNiPowTAG0IsxFwQKH0N85NnjN9DUyghxgJmMtsKc5kv2VKH7UGewDDVjOj+SCCWWt+rdYBYSHwR1LlhM0arP5J96Ku/c9CI3mC/Lvh373MsjvVjHkCgpnEr6sn7I8L35iKn6MPire2gMl3VleNvePNn51yrh2zfrhn6zpHeO8/5pELr/czuyzNsKZr5fJU6k4cOiNRzGeKnUhDKkt1CW3KIDMpqANic+oufIIUI4K7qaGGjOR410lxqCR4ZK5/LAyR5nzcyeF5Q== deploy@domain.io"
}

resource "aws_instance" "instance" {
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  user_data_base64 = "${var.user_data_base64}"
  count            = "${var.servers}"
  key_name         = "deploy-key"
  subnet_id        = "${var.subnet_id}"

  availability_zone           = "${var.availability_zone}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = "${var.public_ip_address}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]

  tags = "${merge(map("Name", format("%s", var.name)), var.tags)}"

  lifecycle {
    create_before_destroy = true
  }
}

