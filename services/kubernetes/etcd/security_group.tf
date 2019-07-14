module "etcd_sg" {
  source      = "../../security_groups"
  name        = "etcd_sg"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "etcd_sg"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
    "all-icmp",
    "etcd-2379-tcp",
    "etcd-2380-tcp",
  ]

  egress_rules = ["all-all"]
}
