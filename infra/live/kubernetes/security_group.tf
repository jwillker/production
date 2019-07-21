module "etcd_sg" {
  source      = "../../modules/security_groups"
  name        = "etcd_sg"
  vpc_id      = "${element(module.vpc.vpc_id, 0)}"
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

# Create the sg
module "security_group" {
  source      = "../../modules/security_groups"
  name        = "Kubernetes"
  vpc_id      = "${element(module.vpc.vpc_id, 0)}"
  description = "Kubernetes comunication"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    #"all-all", # TODO remove this
    "ssh-tcp",
    "all-icmp",
    "etcd-2379-tcp",
    "etcd-2380-tcp",
    "kubelet-10250-tcp",
    "kube-scheduler-10251-tcp",
    "kube-controller-mgt-10252-tcp",
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Kubernetes API server"
    },
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "NodePorts"
    },
  ]

  egress_rules = ["all-all"]
}

module "ssh-sg" {
  source      = "../../modules/security_groups"
  name        = "Public ssh"
  vpc_id      = "${element(module.vpc.vpc_id, 0)}"
  description = "Allow SSH"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
  ]

  egress_rules = ["all-all"]
}
