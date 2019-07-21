resource "aws_ebs_volume" "ebs-volume-a" {
  availability_zone = "${element(var.availability_zone, 0)}"
  size              = "2"

  tags {
    Name = "ebs_etcd_${element(var.zone_suffix, 0)}"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_ebs_volume" "ebs-volume-b" {
  availability_zone = "${element(var.availability_zone, 1)}"
  size              = "2"

  tags {
    Name = "ebs_etcd_${element(var.zone_suffix, 1)}"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_ebs_volume" "ebs-volume-c" {
  availability_zone = "${element(var.availability_zone, 2)}"
  size              = "2"

  tags {
    Name = "ebs_etcd_${element(var.zone_suffix, 2)}"
  }

  lifecycle {
    prevent_destroy = false
  }
}
