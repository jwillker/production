variable "availability_zone" {
  description = "The list of availability zones to use one for each node"
  type        = "list"
}

variable "iam_instance_profile" {
  description = "Profile to attach in nodes, for access SSM"
}
variable "cluster_tag" {
  description = "Value of kubernetes cluster tag + cluster name"
}

variable "nodes" {
  description = "Number of nodes to provision"
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

variable "api_lb_subnets" {
  description = "The VPC Subnet ID"
  type        = "list"
}

variable "api_lb_vpc_id" {
  description = "The VPC ID"
}

