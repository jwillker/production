terraform {
  backend "s3" {
    bucket = "devopxlabs-terraform-state"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "devopxlabs-terraform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
