module "etcd" {
  source           = "../instances"
  name             = "etcd-k8s-${var.zone_suffix}"
  ami              = "${data.aws_ami.ubuntu_1604.id}"
  instance_type    = "t2.micro"
  servers          = 1
  user_data_base64 = "${base64encode(file("etcd.sh"))}"
  key_name         = "Bastion_Key"
  subnet_id        = "${var.subnet_id}"

  iam_instance_profile = "${var.iam_instance_profile}"

  availability_zone = "${var.availability_zone}"

  vpc_security_group_ids = [
    "${var.sg_id}"
  ]
  #TODO ebs attach the right zone
  #depends_on = "aws_ebs_volume.ebs-volume"

  tags   = {
    Environment = "staging"
  }
}


resource "aws_route53_record" "etcd" {
  zone_id = "${var.zone_id}"
  name    = "etcd-${var.zone_suffix}"
  type    = "A"
  ttl     = "300"
  records = ["${module.etcd.private_ip}"]
}
