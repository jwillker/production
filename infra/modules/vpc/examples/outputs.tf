output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

output "public_subnets_id" {
  description = "The ID of the Public Subnets"
  value       = "${module.vpc.public_subnets_id}"
}

output "private_subnets_id" {
  description = "The ID of the Private Subnets"
  value       = "${module.vpc.private_subnets_id}"
}

output "public_route_tables_id" {
  description = "The ID of the Public Route tables"
  value       = "${module.vpc.public_route_tables_id}"
}

output "private_route_tables_id" {
  description = "The ID of the Private Route tables"
  value       = "${module.vpc.private_route_tables_id}"
}
