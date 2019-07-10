output "public_ip" {
  description = "List of public DNS names assigned to the instances"
  value       = "${module.ec2_instance.public_ip}"
}
