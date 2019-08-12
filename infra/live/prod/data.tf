data "aws_caller_identity" "current" {}


data "aws_availability_zones" "available" {}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data  "template_file" "database-init" {
  template = "${file("./database-init.tpl")}"
  vars {
    IMAGEDATABASE  = "${aws_ecr_repository.database.repository_url}"
    MYSQLHOST      = "${aws_db_instance.db.address}"
  }
}

resource "local_file" "k8s_file" {
  content  = "${data.template_file.database-init.rendered}"
  filename = "../../../apps/backend-hash/database/init.yaml"
}
