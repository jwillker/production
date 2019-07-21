# DNS records to use in etcd nodes
resource "aws_route53_record" "etcd-1" {
  zone_id = "${var.zone_id}"
  name    = "etcd-${element(var.zone_suffix, 0)}"
  type    = "A"
  ttl     = "300"
  records = ["${module.etcd-1.private_ip}"]
}

resource "aws_route53_record" "etcd-2" {
  zone_id = "${var.zone_id}"
  name    = "etcd-${element(var.zone_suffix, 1)}"
  type    = "A"
  ttl     = "300"
  records = ["${module.etcd-2.private_ip}"]
}

resource "aws_route53_record" "etcd-3" {
  zone_id = "${var.zone_id}"
  name    = "etcd-${element(var.zone_suffix, 2)}"
  type    = "A"
  ttl     = "300"
  records = ["${module.etcd-3.private_ip}"]
}
