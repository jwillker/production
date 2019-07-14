data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  tags {
    Name = "default"
  }
}

