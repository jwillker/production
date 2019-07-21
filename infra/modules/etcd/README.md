# ETCD Terraform module

## Usage

```hcl
...
module "etcd-cluster" {
  source               = "../"
  availability_zone    = ["${local.az_a}", "${local.az_b}", "${local.az_c}"]
  zone_suffix          = ["a", "b", "c"]
  iam_instance_profile = "${aws_iam_instance_profile.aws_iam_instance_profile.name}"
  sg_id                = "${element(module.etcd_sg.security_group_id, 0)}"
  zone_id              = "${aws_route53_zone.k8s_private_zone.zone_id}"
  subnet_id            = "${data.aws_subnet_ids.subnets.ids}"
}
...
# See more in ./examples
```
### Environment variables and credentials:


1. TF_VAR_AWS_DEFAULT_REGION

Credentials:
   
    $ aws configure

# Tests:

    $ ETCDCTL_API=3 etcdctl --endpoints=https://etcd-b.k8s.devopxlabs.com:2379,https://etcd-a.k8s.devopxlabs.com:2379,https://etcd-c.k8s.devopxlabs.com:2379 -w table endpoint --cluster status

    $ ETCDCTL_API=3 etcdctl --endpoints=https://etcd-b.k8s.devopxlabs.com:2379,https://etcd-a.k8s.devopxlabs.com:2379,https://etcd-c.k8s.devopxlabs.com:2379 endpoint --cluster health

# Build ami

    $ packer build ami/packer.json
