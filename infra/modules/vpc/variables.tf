variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "cidr_block" {
  description = "CIDR Blocks for standard VPC"
  type        = "string"
  default     = "10.0.0.0/16"
}

variable "az" {
  description = "Availability zones list"
  default     = []
}

variable "private_subnets" {
  description = "CIDR Blocks for private subnets in Availability zones"
  type        = "list"
  default     = ["10.0.0.0/20","10.0.16.0/20","10.0.32.0/20"]
}

variable "public_subnets" {
  description = "CIDR Blocks for public subnets in Availability zones"
  type        = "list"
  default     = ["10.0.48.0/20","10.0.64.0/20","10.0.80.0/20"]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
