output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

output "bastion_ip" {
  description = "The bastion public ip for ssh access"
  value       = "${module.bastion.public_ip}"
}

output "master_private_ip" {
  description = "The master private ip"
  value       = "${module.k8s-cluster.master_private_ip}"
}

output "kubernetes_api_lb" {
  description = "K8s api-server LB endpoint"
  value       = "${module.k8s-cluster.api_lb}"
}

output "discounts_ecr" {
  value  = "${aws_ecr_repository.discounts.repository_url}"
}

output "products_ecr" {
  value  = "${aws_ecr_repository.products.repository_url}"
}

output "database_ecr" {
  value  = "${aws_ecr_repository.database.repository_url}"
}

output "db_instance_address" {
  value = "${aws_db_instance.db.address}"
}

