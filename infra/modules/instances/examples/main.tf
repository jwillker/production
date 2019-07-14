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

data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
}

locals {
  instance-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
echo 'This is a user_data'
USERDATA
}

# Create a key pair to use in instance
# To access the instance using this key, run this in current directory:
# ssh -i './deploy-key' <instance ip or dns>

# Not a production key, just for this module
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+JU1XbsRml+fYSncdjJ3MAgt2NX5wsUmF0cnMSdfBWcJ3dygiKcnnj5FKPeNSOnHyYUKciFvmHZ0kVvX4pS5zmD1eZhB1iaHdnOFeSVN6tB+PnRdtUxtxIGyA89pb//0Xc01cWd6mGsXGXMHVZmc/D6iPWPXUJMK7o5Oc6uwWaFYBf0lB0105c0X6zUxKeix2sh7D6zWwYJCHjwPfljHKLcpJxOQpMM2Ja/tzdG95sWnfvTIBT/lmoUhJ3yZP6fVJgfa36PGykYxihyvW3xO3SN4l0ywXcse2vKC9qu+KUZ5nqZ7VKys6r1ix30nuuhZDzEbMHP76BitnEtoTGfVRPe1ASGPitsDJd3/VIjp2XnwkjMGV/Da7gnvCJtIIxLa4d52F4vs60HXtX40Ja+6c2FFdoSQg2ULNiPowTAG0IsxFwQKH0N85NnjN9DUyghxgJmMtsKc5kv2VKH7UGewDDVjOj+SCCWWt+rdYBYSHwR1LlhM0arP5J96Ku/c9CI3mC/Lvh373MsjvVjHkCgpnEr6sn7I8L35iKn6MPire2gMl3VleNvePNn51yrh2zfrhn6zpHeO8/5pELr/czuyzNsKZr5fJU6k4cOiNRzGeKnUhDKkt1CW3KIDMpqANic+oufIIUI4K7qaGGjOR410lxqCR4ZK5/LAyR5nzcyeF5Q== deploy@domain.io"
}

# Create the instance
module "ec2_instance" {
  source           = "../"
  name             = "Instance"
  ami              = "${data.aws_ami.amazon_linux.id}"
  instance_type    = "t2.micro"
  servers          = 1
  user_data_base64 = "${base64encode(local.instance-userdata)}"
  key_name         = "deployer-key" 

  vpc_security_group_ids = [
    "${module.security_group.security_group_id}"
  ]

  tags   = {
    Environment = "staging"
  }
}


# Create the sg
module "security_group" {
  source      = "../../security_groups"
  name        = "web"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "Allow Http"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
    "all-icmp"
  ]

  egress_rules = ["all-all"]
}
