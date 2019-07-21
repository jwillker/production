variable "ami" {
  description = "ID of AMI to use for the instance"
}

variable "public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  default     = false
}

variable "key_name" {
  description = "The key name to use for the instance"
  default     = ""
}

variable "servers" {
  description = "Number of instances to launch"
  default     = 1
}

variable "user_data_base64" {
  description = "The user data to provide when launching the instance"
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
}

variable "availability_zone" {
  description = "The list of availability zones to use one for each node"
}
variable "iam_instance_profile" {
  description = "Profile to attach in nodes, for access SSM"
}

variable "name" {
  description = "The name of instance"
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = "list"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
