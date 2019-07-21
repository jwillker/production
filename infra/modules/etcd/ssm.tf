resource "aws_ssm_parameter" "etcd-ca" {
  name  = "etcd-ca"
  type  = "SecureString"
  value = "${file("${path.module}/certs/ca.pem")}"
  overwrite = "true"
}

resource "aws_ssm_parameter" "etcd-server" {
  name  = "etcd-server"
  type  = "SecureString"
  value = "${file("${path.module}/certs/server.pem")}"
  overwrite = "true"
}

resource "aws_ssm_parameter" "etcd-server-key" {
  name  = "etcd-server-key"
  type  = "SecureString"
  value = "${file("${path.module}/certs/server-key.pem")}"
  overwrite = "true"
}
