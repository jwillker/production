data "aws_caller_identity" "current" {}

# Get amis
data "aws_ami" "ubuntu_1604" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["etcd-base-Packer-Ansible"]
  }

  owners    = ["self"]
}

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

  owners = ["self"]
}

data "aws_availability_zones" "available" {}
