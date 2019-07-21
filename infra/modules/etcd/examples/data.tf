data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  tags {
    Name = "default"
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = "${data.aws_vpc.default.id}"
}


