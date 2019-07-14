module "etcd-a" {
  source               = "../"
  availability_zone    = "us-east-1a"
  zone_suffix          = "a"
  iam_instance_profile = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  sg_id                = "${element(module.etcd_sg.security_group_id, 0)}"
  zone_id              = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id            = "subnet-286d194c"
}

module "etcd-b" {
  source               = "../"
  availability_zone    = "us-east-1b"
  zone_suffix          = "b"
  iam_instance_profile = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  sg_id                = "${element(module.etcd_sg.security_group_id, 0)}"
  zone_id              = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id            = "subnet-2337970c"
}

module "etcd-c" {
  source               = "../"
  availability_zone    = "us-east-1c"
  zone_suffix          = "c"
  iam_instance_profile = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  sg_id                = "${element(module.etcd_sg.security_group_id, 0)}"
  zone_id              = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id            = "subnet-2acca061"
}

resource "aws_route53_zone" "k8s_private_zone" {
  name = "k8s.devopxlabs.com"

  vpc {
    vpc_id = "${data.aws_vpc.default.id}"
  }
}
