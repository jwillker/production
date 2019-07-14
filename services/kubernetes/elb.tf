resource "aws_lb" "control_plane" {
  name               = "${var.cluster_name}-api-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${module.vpc.public_subnets_id}"]

  tags = "${map("Cluster", "${var.cluster_name}", "${local.kube_cluster_tag}", "shared")}"
}

resource "aws_lb_target_group" "control_plane_api" {
  name     = "${var.cluster_name}-api"
  port     = 6443
  protocol = "TCP"
  vpc_id   = "${element(module.vpc.vpc_id, 0)}"
}

resource "aws_lb_listener" "control_plane_api" {
  load_balancer_arn = "${aws_lb.control_plane.arn}"
  port              = 6443
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.control_plane_api.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "control_plane_api_1" {
  count            = 1
  target_group_arn = "${aws_lb_target_group.control_plane_api.arn}"
  target_id        = "${element(module.master-1.instance_id, 0)}"
  port             = 6443
}

resource "aws_lb_target_group_attachment" "control_plane_api_2" {
  count            = 1
  target_group_arn = "${aws_lb_target_group.control_plane_api.arn}"
  target_id        = "${element(module.master-2.instance_id, 0)}"
  port             = 6443
}

resource "aws_lb_target_group_attachment" "control_plane_api_3" {
  count            = 1
  target_group_arn = "${aws_lb_target_group.control_plane_api.arn}"
  target_id        = "${element(module.master-3.instance_id, 0)}"
  port             = 6443
}

#data "aws_route53_zone" "k8s_zone" {
#  name         = "k8s.devopxlabs.com."
#  private_zone = true
#}
#
resource "aws_route53_record" "kubernetes" {
  name    = "kubernetes"
  type    = "A"
  zone_id = "${aws_route53_zone.k8s_private_zone.zone_id}"

  alias {
    name                   = "${aws_lb.control_plane.dns_name}"
    zone_id                = "${aws_lb.control_plane.zone_id}"
    evaluate_target_health = false
  }
}
