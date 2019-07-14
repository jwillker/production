# TODO separate resources ex: data in data.tf files, backend in backend.tf file...
provider "aws" {
  region = "${var.AWS_DEFAULT_REGION}"
}

terraform {
  backend "s3" {
    bucket = "devopxlabs-terraform-state"
    key    = "kubernetes/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  az_count         = "${length(data.aws_availability_zones.available.names)}"
  az_a             = "${var.AWS_DEFAULT_REGION}a"
  az_b             = "${var.AWS_DEFAULT_REGION}b"
  az_c             = "${var.AWS_DEFAULT_REGION}c"
  kube_cluster_tag = "kubernetes.io/cluster/${var.cluster_name}"
}

data "aws_availability_zones" "available" {}


# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
module "vpc" {
  source = "../../infra/modules/vpc"
  name   = "standard"
  az     = "${data.aws_availability_zones.available.names}"

  tags = {
    Environment                 = "staging"
    "${local.kube_cluster_tag}" = "shared"
  }
}

resource "aws_route53_zone" "k8s_private_zone" {
  name = "k8s.devopxlabs.com"

  vpc {
    vpc_id = "${element(module.vpc.vpc_id, 0)}"
  }
}

module "etcd-a" {
  source               = "../../infra/modules/etcd"
  availability_zone    = "us-east-1a"
  zone_suffix          = "a"
  iam_instance_profile = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  sg_id                = "${element(module.etcd_sg.security_group_id, 0)}"
  zone_id              = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id            = "${element(module.vpc.private_subnets_id, 0)}"
}

module "etcd-b" {
  source               = "../../infra/modules/etcd"
  availability_zone    = "us-east-1b"
  zone_suffix          = "b"
  iam_instance_profile = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  sg_id                = "${element(module.etcd_sg.security_group_id, 0)}"
  zone_id              = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id            = "${element(module.vpc.private_subnets_id, 1)}"
}

module "etcd-c" {
  source               = "../../infra/modules/etcd"
  availability_zone    = "us-east-1c"
  zone_suffix          = "c"
  iam_instance_profile = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  sg_id                = "${element(module.etcd_sg.security_group_id, 0)}"
  zone_id              = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id            = "${element(module.vpc.private_subnets_id, 2)}"
}
# Create the instance
module "master-1" {
  source                 = "../../infra/modules/instances"
  name                   = "master-1"
  ami                    = "${data.aws_ami.k8s-base.id}"
  instance_type          = "t2.micro"
  servers                = 1
  user_data_base64       = "${base64encode(file("master_init.sh"))}"
  key_name               = "Bastion_Key"
  iam_instance_profile   = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  availability_zone      = "${element(data.aws_availability_zones.available.names, 0)}"
  subnet_id              = "${element(module.vpc.private_subnets_id, 0)}"
  vpc_security_group_ids = ["${module.security_group.security_group_id}"]

  tags = {
    Environment                 = "staging"
    "${local.kube_cluster_tag}" = "shared"
  }
}

module "master-2" {
  source                 = "../../infra/modules/instances"
  name                   = "master-2"
  ami                    = "${data.aws_ami.k8s-base.id}"
  instance_type          = "t2.micro"
  servers                = 1
  user_data_base64       = "${base64encode(file("master_join.sh"))}"
  key_name               = "Bastion_Key"
  iam_instance_profile   = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  availability_zone      = "${element(data.aws_availability_zones.available.names, 1)}"
  subnet_id              = "${element(module.vpc.private_subnets_id, 1)}"
  vpc_security_group_ids = ["${module.security_group.security_group_id}"]

  tags = {
    Environment                 = "staging"
    "${local.kube_cluster_tag}" = "shared"
  }
}

module "master-3" {
  source                 = "../../infra/modules/instances"
  name                   = "master-3"
  ami                    = "${data.aws_ami.k8s-base.id}"
  instance_type          = "t2.micro"
  servers                = 1
  user_data_base64       = "${base64encode(file("master_join.sh"))}"
  key_name               = "Bastion_Key"
  iam_instance_profile   = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  availability_zone      = "${element(data.aws_availability_zones.available.names, 2)}"
  subnet_id              = "${element(module.vpc.private_subnets_id, 2)}"
  vpc_security_group_ids = ["${module.security_group.security_group_id}"]

  tags = {
    Environment                 = "staging"
    "${local.kube_cluster_tag}" = "shared"
  }
}

module "nodes" {
  source                 = "../../infra/modules/instances"
  name                   = "nodes"
  ami                    = "${data.aws_ami.k8s-base.id}"
  instance_type          = "t2.micro"
  servers                = 3
  user_data_base64       = "${base64encode(file("node.sh"))}"
  key_name               = "Bastion_Key"
  iam_instance_profile   = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  availability_zone      = "${element(data.aws_availability_zones.available.names, 0)}"
  subnet_id              = "${element(module.vpc.private_subnets_id, 3)}"              #TODO separate subnets or azs
  vpc_security_group_ids = ["${module.security_group.security_group_id}"]

  tags = {
    Environment                 = "staging"
    "${local.kube_cluster_tag}" = "shared"
  }
}

module "bastion" {
  source                      = "../../infra/modules/instances"
  name                        = "Bastion"
  ami                         = "${data.aws_ami.k8s-base.id}"
  instance_type               = "t2.micro"
  servers                     = 1
  key_name                    = "Bastion_Key"
  iam_instance_profile        = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  availability_zone           = "${element(data.aws_availability_zones.available.names, 0)}"
  subnet_id                   = "${element(module.vpc.public_subnets_id, 0)}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${module.ssh-sg.security_group_id}"]
}

# Create the sg
module "security_group" {
  source      = "../../infra/modules/security_groups"
  name        = "Kubernetes"
  vpc_id      = "${element(module.vpc.vpc_id, 0)}"
  description = "Kubernetes comunication"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
    "all-icmp",
    "etcd-2379-tcp",
    "etcd-2380-tcp",
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
  source      = "../../infra/modules/security_groups"
  name        = "Public ssh"
  vpc_id      = "${element(module.vpc.vpc_id, 0)}"
  description = "Allow SSH"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
  ]

  egress_rules = ["all-all"]
}
