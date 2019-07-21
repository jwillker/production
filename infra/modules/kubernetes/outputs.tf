output "master_private_ip" {
  description = "The master private ip"
  value       = "${module.master-1.private_ip}"
}
