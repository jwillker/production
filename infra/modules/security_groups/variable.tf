
variable "name" {
  description = "Name of Security Group"
}
variable "vpc_id" {
  description = "Id of VPC"
}

variable "create" {
  description = "Whether to create security group"
  default     = true
}

variable "description" {
  description = "Description of Security Group"
}

# Ingress
variable "ingress_cidr_blocks" {
  description = "Description of Security Group"
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "ingress_rules" {
  description = "List of ingress rules to create"
  default     = []
}

# Egress
variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  default     = ["0.0.0.0/0"]
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules to create"
  default     = []
}

variable "rules" {
  description = "Security Group rules name"
  type        = "map"
  default     = {
    # Allow ping
    all-icmp      = [-1, -1, "icmp", "All IPV4 ICMP"]
    # All protocols
    all-all       = [-1, -1, "-1", "All protocols"]
    # Allow SSH
    ssh-tcp = [22, 22, "tcp", "SSH"]
    # Allow HTTP
    http-80-tcp   = [80, 80, "tcp", "HTTP"]
    # Allow HTTPS
    https-443-tcp  = [443, 443, "tcp", "HTTPS"]
    _ = ["", "", ""]
  }
}
