output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${compact(concat(aws_vpc.standard.*.id, list("")))}"
}

output "public_subnets_id" {
  description = "The ID of the Public Subnets"
  value       = "${compact(concat(aws_subnet.public_subnets.*.id, list("")))}"
}

output "private_subnets_id" {
  description = "The ID of the Private Subnets"
  value       = "${compact(concat(aws_subnet.private_subnets.*.id, list("")))}"
}

output "public_route_tables_id" {
  description = "The ID of the Public Route tables"
  value       = "${compact(concat(aws_route_table.public.*.id, list("")))}"
}

output "private_route_tables_id" {
  description = "The ID of the Private Route tables"
  value       = "${compact(concat(aws_route_table.private.*.id, list("")))}"
}
