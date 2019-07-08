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
  #kube_cluster_tag = "kubernetes.io/cluster/${var.cluster_name}"
}

data "aws_availability_zones" "available" {
}


module "vpc" {
  source = "../../infra/modules/vpc"
  name   = "standard"
  az     = "${data.aws_availability_zones.available.names}"
  tags   = {
    Kubernetes  = "prod"
  }
}
