data "aws_ami" "k8s-base" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["K8s-base-Packer-Ansible"]
  }

  owners = ["self"]
}

data "template_file" "master_init" {
  template = "${file("${path.module}/master-init.sh")}"

  vars {
    aws_region = "${data.aws_region.current.name}"
  }
}

data "template_file" "master_join" {
  template = "${file("${path.module}/master-join.sh")}"

  vars {
    aws_region = "${data.aws_region.current.name}"
  }
}

data "template_file" "node_join" {
  template = "${file("${path.module}/node-join.sh")}"

  vars {
    aws_region = "${data.aws_region.current.name}"
  }
}

data "aws_region" "current" {}
