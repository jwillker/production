output "public_ip" {
  description = "Public IP addresse assigned to the instances, if applicable"
  value = "${module.etcd.public_ip}"
}
