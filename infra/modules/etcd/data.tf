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
  # TODO find way to get owner
  owners    = ["self"]
}

#data "aws_route53_zone" "zone" {
#  name = "k8s.devopxlabx.com"
#}
#
