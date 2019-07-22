
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

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
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
    # ETCD
    etcd-2379-tcp  = [2379, 2379, "tcp", "ETCD"]
    etcd-2380-tcp  = [2380, 2380, "tcp", "ETCD"]
    api-server-6443-tcp = [6443, 6443, "tcp", "Api server"]
    cilium-8472-udp = [8472, 8472, "udp", "Cilium"]
    kubelet-10250-tcp = [10250, 10250, "tcp", "Kubelet API"]
    kube-scheduler-10251-tcp = [10251, 10251, "tcp", "kube-scheduler"]
    kube-controller-mgt-10252-tcp = [10252, 10252, "tcp", "kube-controller-manager"]
    node-ports-30000-tcp = [30000, 32767, "tcp", "Node Ports"]
    _ = ["", "", ""]
  }
}
