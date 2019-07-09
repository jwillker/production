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

module "security_group" {
  source      = "../"
  name        = "web"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "Allow Http"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "http-80-tcp",
    "https-443-tcp",
    "all-icmp"
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH only from that cidr"
      cidr_blocks = "10.0.0.0/16"
    },
  ]

  egress_rules = ["all-all"]
}
