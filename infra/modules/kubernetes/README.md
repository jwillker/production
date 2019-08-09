# Kubernetes Terraform module

## Usage

```hcl
...
module "k8s-cluster" {
  source                 = "../../modules/kubernetes"
  nodes                  = 3
  cluster_tag            = "${local.kube_cluster_tag}"
  iam_instance_profile   = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  availability_zone      = ["${local.az_a}", "${local.az_b}", "${local.az_c}"]
  sg_id                  = "${element(module.security_group.security_group_id, 0)}"
  zone_id                = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id              = "${module.vpc.private_subnets_id}"
  api_lb_subnets         = "${module.vpc.public_subnets_id}"
  api_lb_vpc_id          = "${element(module.vpc.vpc_id, 0)}"
 }
...
```
### Environment variables and credentials:


1. TF_VAR_AWS_DEFAULT_REGION

Credentials:

    $ aws configure

# Build ami

    $ packer build ami/packer.json



# BEFORE DESTROY

    $ kubectl delete ns istio-system

Istio had created an lb resource
