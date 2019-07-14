#!/bin/bash

set -euxo pipefail

locale-gen en_GB.UTF-8

mkdir -p /etc/kubernetes/pki/etcd

aws ssm get-parameters --names "etcd-ca" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/etcd/ca.crt
aws ssm get-parameters --names "etcd-server" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/apiserver-etcd-client.crt
aws ssm get-parameters --names "etcd-server-key" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/apiserver-etcd-client.key

#secondary master

# wait for master node
while [ "None" = "$(aws ssm get-parameters --names 'k8s-init-token' --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1)" ];do echo "waiting for init master"; sleep 5;done
 
aws ssm get-parameters --names "k8s-ca" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/ca.crt
aws ssm get-parameters --names "k8s-ca-key" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/ca.key
aws ssm get-parameters --names "k8s-sa" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/sa.pub
aws ssm get-parameters --names "k8s-sa-key" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/sa.key
aws ssm get-parameters --names "k8s-front-proxy-ca" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/front-proxy-ca.crt
aws ssm get-parameters --names "k8s-front-proxy-ca-key" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/front-proxy-ca.key

TOKEN=$(aws ssm get-parameters --names "k8s-init-token" --query '[Parameters[0].Value]' --output text --with-decryption  --region us-east-1)
TOKEN_HASH=$(aws ssm get-parameters --names "k8s-init-token-hash" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1)

kubeadm join kubernetes.k8s.devopxlabs.com:6443 --token $TOKEN --discovery-token-ca-cert-hash sha256:$TOKEN_HASH --experimental-control-plane

# configure kubeconfig for kubectl
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown $(id -u):$(id -g) /root/.kube/config
