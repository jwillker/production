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


data "aws_availability_zones" "available" {
}


module "vpc" {
  source = "../"
  name   = "standard"
  az     = "${data.aws_availability_zones.available.names}"
  tags   = {
    Environment = "staging"
  }
}
