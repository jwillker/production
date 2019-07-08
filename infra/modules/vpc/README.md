# VPC Terraform module

## Usage

```hcl

data "aws_availability_zones" "available" {
}

module "vpc" {
  source = "../../modules/vpc"
  name   = "vpc-name"
  az     = "${data.aws_availability_zones.available.names}"
  cidr   = "10.0.0.0/16"

  private_subnets = ["10.0.0.0/20","10.0.16.0/20","10.0.32.0/20"]
  public_subnets  = ["10.0.48.0/20","10.0.64.0/20","10.0.80.0/20"]

  tags = {
    Environment = "staging"
    Kubernetes  = "cluster-name"
  }
}
```
### Environment variable

1. AWS_SECRET_ACCESS_KEY

2. AWS_ACCESS_KEY_ID

3. TF_AWS_DEFAULT_REGION

or just:
   
    $ aws configure

## Tests

```shell
 $ make test
```
