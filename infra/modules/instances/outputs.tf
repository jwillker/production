output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = "${compact(concat(aws_instance.instance.*.public_ip, list("")))}"
}
