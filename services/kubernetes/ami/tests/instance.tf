provider "aws" {
  region = "${var.AWS_DEFAULT_REGION}"
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS region to deploy"
}

terraform {
  backend "s3" {
    bucket = "devopxlabs-terraform-state"
    key    = "kubernetes-ami-test/terraform.tfstate"
    region = "us-east-1"
  }
}

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

resource "aws_instance" "test" {
  ami           = "${data.aws_ami.k8s-base.id}"
  instance_type = "t2.micro"
  key_name      = "Bastion_Key"

  tags = {
    Name = "inspec-test"
  }
}

output "public_ip" {
  value = "${aws_instance.test.public_ip}"
}
