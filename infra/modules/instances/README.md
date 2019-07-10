# Instance Terraform module

## Usage

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
}

locals {
  instance-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
echo 'This is a user_data'
USERDATA
}

module "ec2_instance" {
  source           = "../"
  name             = "Instance"
  ami              = "${data.aws_ami.amazon_linux.id}"
  instance_type    = "t2.micro"
  count            = 1
  user_data_base64 = "${base64encode(local.instance-userdata)}"
  key_name         = "deployer-key" 

  vpc_security_group_ids = [
    "sg-00000"
  ]

  tags   = {
    Environment = "staging"
  }
}
```
### Environment variables and credentials:


1. TF_VAR_AWS_DEFAULT_REGION

Credentials:
   
    $ aws configure

## Tests

```shell
 $ make test
```

To access the instance using key pair run this in current directory:
   
    $ ssh -i './deploy-key' <instance ip or dns>
