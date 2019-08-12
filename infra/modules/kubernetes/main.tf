module "master-1" {
  source                 = "../instances"
  name                   = "master-k8s-1"
  ami                    = "${data.aws_ami.k8s-base.id}"
  instance_type          = "t2.medium"
  servers                = 1
  user_data_base64       = "${base64encode(data.template_file.master_init.rendered)}"
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  availability_zone      = "${element(var.availability_zone, 0)}"
  subnet_id              = "${element(var.subnet_id, 0)}"

  vpc_security_group_ids = [
    "${var.sg_id}"
  ]

  tags = {
    Environment          = "production"
    "${var.cluster_tag}" = "shared"
  }
}

module "master-2" {
  source                 = "../instances"
  name                   = "master-k8s-2"
  ami                    = "${data.aws_ami.k8s-base.id}"
  instance_type          = "t2.medium"
  servers                = 1
  user_data_base64       = "${base64encode(data.template_file.master_join.rendered)}"
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  availability_zone      = "${element(var.availability_zone, 1)}"
  subnet_id              = "${element(var.subnet_id, 1)}"

  vpc_security_group_ids = [
    "${var.sg_id}"
  ]

  tags = {
    Environment          = "production"
    "${var.cluster_tag}" = "shared"
  }
}

module "master-3" {
  source                 = "../instances"
  name                   = "master-k8s-3"
  ami                    = "${data.aws_ami.k8s-base.id}"
  instance_type          = "t2.medium"
  servers                = 1
  user_data_base64       = "${base64encode(data.template_file.master_join.rendered)}"
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  availability_zone      = "${element(var.availability_zone, 2)}"
  subnet_id              = "${element(var.subnet_id, 2)}"

  vpc_security_group_ids = [
    "${var.sg_id}"
  ]

  tags = {
    Environment          = "production"
    "${var.cluster_tag}" = "shared"
  }
}

resource "aws_launch_configuration" "nodes" {
  count                       = 1
  name_prefix                 = "node-k8s-"
  image_id                    = "${data.aws_ami.k8s-base.id}"
  instance_type               = "t3.xlarge"
  iam_instance_profile        = "${var.iam_instance_profile}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.sg_id}"]
  user_data_base64            = "${base64encode(data.template_file.node_join.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nodes" {
  count = 1

  name_prefix          = "nodes-k8s-"
  launch_configuration = "${aws_launch_configuration.nodes.name}"
  vpc_zone_identifier  = ["${var.subnet_id}"]
  max_size             = "${var.nodes + 10}"
  min_size             = "${var.nodes}"
  desired_capacity     = "${var.nodes}"

  health_check_type         = "EC2"

  force_delete              = true
  termination_policies      = ["OldestInstance"]

  tags = [
    {
      key                  = "Environment"
      value                = "staging"
      propagate_at_launch  = true
    },
    {
      key                  = "${var.cluster_tag}"
      value                = "shared"
      propagate_at_launch  = true
    },
    {
      key                  = "Name"
      value                = "node-k8s"
      propagate_at_launch  = true
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "nodes_target_tracking_policy" {
  name                      = "nodes-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = "${aws_autoscaling_group.nodes.name}"
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "60"
  }
}
