# TODO descriptions
variable "availability_zone" {}

variable "zone_suffix" {}

variable "iam_instance_profile" {}

variable "sg_id" {}
variable "zone_id" {}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
}
