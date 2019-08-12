resource "aws_ssm_parameter" "k8s-ca" {
  name  = "k8s-ca"
  type  = "SecureString"
  value = "None"
  overwrite = "true"
}

resource "aws_ssm_parameter" "k8s-ca-key" {
  name  = "k8s-ca-key"
  type  = "SecureString"
  value = "None"
  overwrite = "true"
}
resource "aws_ssm_parameter" "k8s-sa" {
  name  = "k8s-sa"
  type  = "SecureString"
  value = "None"
  overwrite = "true"
}

resource "aws_ssm_parameter" "k8s-sa-key" {
  name  = "k8s-sa-key"
  type  = "SecureString"
  value = "None"
  overwrite = "true"
}
resource "aws_ssm_parameter" "k8s-front-proxy-ca" {
  name  = "k8s-front-proxy-ca"
  type  = "SecureString"
  value = "None"
  overwrite = "true"
}
resource "aws_ssm_parameter" "k8s-front-proxy-ca-key" {
  name  = "k8s-front-proxy-ca-key"
  type  = "SecureString"
  value = "None"
  overwrite = "true"
}
resource "aws_ssm_parameter" "k8s-init-token" {
  name  = "k8s-init-token"
  type  = "SecureString"
  value = "None"
  overwrite = "true"
}
resource "aws_ssm_parameter" "k8s-init-token-hash" {
  name  = "k8s-init-token-hash"
  type  = "SecureString"
  value = "None"
  overwrite = "true"
}

resource "aws_ssm_parameter" "kube-config" {
  name  = "kube-config"
  type  = "SecureString"
  tier  = "Advanced"
  value = "None"
  overwrite = "true"
}
