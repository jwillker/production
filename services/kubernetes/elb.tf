
resource "aws_lb" "control_plane" {
  name               = "${var.cluster_name}-api-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.subnets_public.*.id}"]

  tags = "${map("Cluster", "${var.cluster_name}", "${local.kube_cluster_tag}", "shared")}"
}

resource "aws_lb_target_group" "control_plane_api" {
  name     = "${var.cluster_name}-api"
  port     = 6443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.standard.id}"
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

resource "aws_lb_target_group_attachment" "control_plane_api" {
  count            = 3
  target_group_arn = "${aws_lb_target_group.control_plane_api.arn}"
  target_id        = "${element(aws_instance.k8s_masters.*.id, count.index)}" # verify if need be count.index + 1
  port             = 6443
}
