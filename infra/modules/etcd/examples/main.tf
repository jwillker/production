locals {
  az_a             = "${var.AWS_DEFAULT_REGION}a"
  az_b             = "${var.AWS_DEFAULT_REGION}b"
  az_c             = "${var.AWS_DEFAULT_REGION}c"
}

module "etcd-cluster" {
  source               = "../"
  availability_zone    = ["${local.az_a}", "${local.az_b}", "${local.az_c}"]
  zone_suffix          = ["a", "b", "c"]
  iam_instance_profile = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  sg_id                = "${element(module.etcd_sg.security_group_id, 0)}"
  zone_id              = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id            = "${data.aws_subnet_ids.subnets.ids}"
}

resource "aws_route53_zone" "k8s_private_zone" {
  name = "k8s.devopxlabs.com"

  vpc {
    vpc_id = "${data.aws_vpc.default.id}"
  }
}
