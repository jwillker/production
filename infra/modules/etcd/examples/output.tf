output "public_ip_a" {
  value = "${module.etcd-a.public_ip}"
}
output "public_ip_b" {
  value = "${module.etcd-b.public_ip}"
}
output "public_ip_c" {
  value = "${module.etcd-c.public_ip}"
}
