#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

#terraform {
#  required_version = ">= 0.11.9" 
#}
#
resource "aws_vpc" "standard" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}

resource "aws_eip" "nat" {
  count = "${length(var.public_subnets)}"
  vpc   = "true"

  tags = "${merge(map("Name", "Nat"), var.tags)}"
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = "${length(var.public_subnets)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnets.*.id, count.index)}"

  tags = "${merge(map("Name", "Nat-Gateway"), var.tags)}"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.standard.id}"

  tags = "${merge(map("Name", "Internet-Gateway"), var.tags)}"
}

resource "aws_subnet" "public_subnets" {
  count = 3

  availability_zone = "${var.az[count.index]}"
  cidr_block        = "${element(var.public_subnets, count.index)}"
  vpc_id            = "${aws_vpc.standard.id}"

  tags = "${merge(map("Name", "Public"), var.tags)}"
}

resource "aws_subnet" "private_subnets" {
  count = 3

  availability_zone = "${var.az[count.index]}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  vpc_id            = "${aws_vpc.standard.id}"

  tags = "${merge(map("Name", "Private"), var.tags)}"
}

# Routes

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.standard.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }
  tags = "${merge(map("Name", "Public"), var.tags)}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.standard.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat_gateway.*.id, count.index)}"
  }
  tags = "${merge(map("Name", "Private"), var.tags)}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
