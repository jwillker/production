data "aws_ami" "ubuntu_1604" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["etcd-base-Packer-Ansible"]
  }
  owners    = ["self"]
}

#data "aws_route53_zone" "zone" {
#  name = "k8s.devopxlabx.com"
#}
#

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data-etcd.sh")}"

  vars {
    aws_region = "${data.aws_region.current.name}"
  }
}

data "aws_region" "current" {}
