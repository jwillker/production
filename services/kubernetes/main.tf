provider "aws" {
  region     = "${var.AWS_DEFAULT_REGION}"
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

data "aws_availability_zones" "available" {
}
# Get ami
data "aws_ami" "k8s-base" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["K8s-base-Packer-Ansible"]
  }
  owners    = ["967724168372"]
}

# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
module "vpc" {
  source = "../../infra/modules/vpc"
  name   = "standard"
  az     = "${data.aws_availability_zones.available.names}"
  tags   = {
    Environment                 = "staging"
    "${local.kube_cluster_tag}" = "shared"
  }
}

# Create the instance
module "masters" {
  source           = "../../infra/modules/instances"
  name             = "master"
  ami              = "${data.aws_ami.k8s-base}"
  instance_type    = "t2.micro"
  count            = 3
  user_data_base64 = "${base64encode(local.instance-userdata)}"
  key_name         = "Bastion_Key"

  vpc_security_group_ids = [
    "${module.security_group.security_group_id}"
  ]

  tags   = {
    Environment                 = "staging"
    "${local.kube_cluster_tag}" = "shared"
  }
}

module "nodes" {
  source           = "../../infra/modules/instances"
  name             = "nodes"
  ami              = "${data.aws_ami.k8s-base}"
  instance_type    = "t2.micro"
  count            = 3
  user_data_base64 = "${base64encode(local.instance-userdata)}"
  key_name         = "Bastion_Key"
  # TODO vpc set
  vpc_security_group_ids = [
    "${module.security_group.security_group_id}"
  ]

  tags   = {
    Environment                 = "staging"
    "${local.kube_cluster_tag}" = "shared"
  }
}

# Create the sg
module "security_group" {
  source      = "../../infra/modules/security_groups"
  name        = "web"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "Allow Http"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
    "all-icmp"
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Kubernetes API server"
    },
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "NodePorts"
    },
  ]

  egress_rules = ["all-all"]
}
