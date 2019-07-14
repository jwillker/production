terraform {
  backend "s3" {
    bucket = "devopxlabs-terraform-state"
    key    = "modules-etcd/terraform.tfstate"
    region = "us-east-1"
  }
}
