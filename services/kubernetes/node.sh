#!/bin/bash

set -euxo pipefail

locale-gen en_GB.UTF-8

#slave node

hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/local-hostname)

#This is a requirement for some CNI plugins to work
sysctl net.bridge.bridge-nf-call-iptables=1

# wait for master node
while [ "None" = "$(aws ssm get-parameters --names 'k8s-init-token' --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1)" ];do echo "waiting for init master"; sleep 5;done

TOKEN=$(aws ssm get-parameters --names "k8s-init-token" --query '[Parameters[0].Value]' --output text --with-decryption  --region us-east-1)
TOKEN_HASH=$(aws ssm get-parameters --names "k8s-init-token-hash" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1)

kubeadm join kubernetes.k8s.devopxlabs.com:6443 --token $TOKEN --discovery-token-ca-cert-hash sha256:$TOKEN_HASH 

# configure kubeconfig for kubectl
#mkdir -p /root/.kube
#cp -i /etc/kubernetes/admin.conf /root/.kube/config
#chown $(id -u):$(id -g) /root/.kube/config
#
