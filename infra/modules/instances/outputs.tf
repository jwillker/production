output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = "${compact(concat(aws_instance.instance.*.public_ip, list("")))}"
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances, if applicable"
  value       = "${compact(concat(aws_instance.instance.*.private_ip, list("")))}"
}

output "instance_id" {
  description = "List of instance ids"
  value       = "${compact(concat(aws_instance.instance.*.id, list("")))}"
}
