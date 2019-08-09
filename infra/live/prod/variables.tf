variable "AWS_DEFAULT_REGION" {
  description = "AWS region to deploy"
}

variable "cluster_name" {
  description = "Name of the cluster"
  default     = "lab"
}


# Database variables
variable "identifier" {
  default     = "backend-apps-db"
  description = "Identifier for DB"
}

variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

variable "engine" {
  default     = "mysql"
  description = "Engine type"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.7.21"
  }
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "db_name" {
  default     = "api"
  description = "db name"
}

variable "username" {
  default     = "admin"
  description = "User name"
}

variable "password" {
  default     = "admin1234"
  description = "Password"
}
