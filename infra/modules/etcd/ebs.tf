resource "aws_ebs_volume" "ebs-volume" {
  availability_zone = "${var.availability_zone}"
  size              = "2"

  tags {
    Name        = "ebs_etcd_${var.zone_suffix}"
  }

  lifecycle {
    prevent_destroy = false
  }
}
