output "security_group_id" {
  description = "The ID of the security group"
  value       = "${module.security_group.security_group_id}"
}
