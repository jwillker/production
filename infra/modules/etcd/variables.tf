variable "availability_zone" {
  description = "The list of availability zones to use one for each node"
  type        = "list"
}

variable "zone_suffix" {
  description = "Suffix of the zone, to use in dns and ebs. Ex: a , b, c"
  type        = "list"
}

variable "iam_instance_profile" {
  description = "Profile to attach in nodes, for access SSM"
}

variable "sg_id" {
  description = "Security Group to use in nodes"
}
variable "zone_id" {
  description = "The id of route53 private zone, where records will be create"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = "list"
}
