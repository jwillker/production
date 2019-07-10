variable "ami" {
  description = "ID of AMI to use for the instance"
}

variable "key_name" {
  description = "The key name to use for the instance"
  default     = ""
}

variable "count" {
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

variable "name" {
  description = "The name of instance"
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = "list"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
