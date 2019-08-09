output "master_private_ip" {
  description = "The master private ip"
  value       = "${module.master-1.private_ip}"
}

output "api_lb" {
  description = "K8s api-server LB endpoint"
  value       = "${aws_lb.control_plane.dns_name}"
}
