module "etcd-1" {
  source           = "../instances"
  name             = "etcd-k8s-1"
  ami              = "${data.aws_ami.ubuntu_1604.id}"
  instance_type    = "t2.medium"
  servers          = 1
  user_data_base64 = "${base64encode(data.template_file.user_data.rendered)}"
  key_name         = "${var.key_name}"
  subnet_id        = "${element(var.subnet_id, 0)}"

  iam_instance_profile = "${var.iam_instance_profile}"

  availability_zone = "${element(var.availability_zone, 0)}"

  vpc_security_group_ids = [
    "${var.sg_id}"
  ]

  tags   = {
    Environment = "staging"
  }
}

module "etcd-2" {
  source           = "../instances"
  name             = "etcd-k8s-2"
  ami              = "${data.aws_ami.ubuntu_1604.id}"
  instance_type    = "t2.medium"
  servers          = 1
  user_data_base64 = "${base64encode(data.template_file.user_data.rendered)}"
  key_name         = "${var.key_name}"
  subnet_id        = "${element(var.subnet_id, 1)}"

  iam_instance_profile = "${var.iam_instance_profile}"

  availability_zone = "${element(var.availability_zone, 1)}"

  vpc_security_group_ids = [
    "${var.sg_id}"
  ]

  tags   = {
    Environment = "staging"
  }
}

module "etcd-3" {
  source           = "../instances"
  name             = "etcd-k8s-3"
  ami              = "${data.aws_ami.ubuntu_1604.id}"
  instance_type    = "t2.medium"
  servers          = 1
  user_data_base64 = "${base64encode(data.template_file.user_data.rendered)}"
  key_name         = "${var.key_name}"
  subnet_id        = "${element(var.subnet_id, 2)}"

  iam_instance_profile = "${var.iam_instance_profile}"

  availability_zone = "${element(var.availability_zone, 2)}"

  vpc_security_group_ids = [
    "${var.sg_id}"
  ]

  tags   = {
    Environment = "staging"
  }
}
