output "security_group_id" {
  description = "The ID of the security group"
  value       = "${compact(concat(aws_security_group.security_group.*.id, list("")))}"
}
