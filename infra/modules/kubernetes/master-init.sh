#!/bin/bash

set -euxo pipefail

locale-gen en_GB.UTF-8
hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/local-hostname)

mkdir -p /etc/kubernetes/pki/etcd

#Get etcd certificates
aws ssm get-parameters --names "etcd-ca" --query '[Parameters[0].Value]' --output text  --with-decryption --region "${aws_region}" > /etc/kubernetes/pki/etcd/ca.crt
aws ssm get-parameters --names "etcd-server" --query '[Parameters[0].Value]' --output text  --with-decryption --region "${aws_region}" > /etc/kubernetes/pki/apiserver-etcd-client.crt
aws ssm get-parameters --names "etcd-server-key" --query '[Parameters[0].Value]' --output text  --with-decryption --region "${aws_region}" > /etc/kubernetes/pki/apiserver-etcd-client.key

kubeadm init --config /opt/kubeadm-config.yaml --ignore-preflight-errors=all

# configure kubeconfig for kubectl
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown $(id -u):$(id -g) /root/.kube/config

#Install cilium cni
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/cilium/cilium/v1.5/examples/kubernetes/1.14/cilium.yaml

#This is a requirement for some CNI plugins to work
sysctl net.bridge.bridge-nf-call-iptables=1

sleep 5
# initial master
aws ssm put-parameter --name "k8s-ca" --value "$(cat /etc/kubernetes/pki/ca.crt)"  --type "SecureString" --region "${aws_region}" --overwrite
aws ssm put-parameter --name "k8s-ca-key" --value "$(cat /etc/kubernetes/pki/ca.key)"  --type "SecureString" --region "${aws_region}" --overwrite
aws ssm put-parameter --name "k8s-sa" --value "$(cat /etc/kubernetes/pki/sa.pub)"  --type "SecureString" --region "${aws_region}" --overwrite
aws ssm put-parameter --name "k8s-sa-key" --value "$(cat /etc/kubernetes/pki/sa.key)"  --type "SecureString" --region "${aws_region}" --overwrite
aws ssm put-parameter --name "k8s-front-proxy-ca" --value "$(cat /etc/kubernetes/pki/front-proxy-ca.crt)"  --type "SecureString" --region "${aws_region}" --overwrite
aws ssm put-parameter --name "k8s-front-proxy-ca-key" --value "$(cat /etc/kubernetes/pki/front-proxy-ca.key)"  --type "SecureString" --region "${aws_region}" --overwrite

sleep 5
#Upload certificates
aws ssm put-parameter --name "k8s-init-token" --value "$(kubeadm token create)"  --type "SecureString" --region "${aws_region}" --overwrite
aws ssm put-parameter --name "k8s-init-token-hash" --value "$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')"  --type "SecureString" --region "${aws_region}" --overwrite
