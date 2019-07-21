#!/bin/bash

set -euxo pipefail

locale-gen en_GB.UTF-8

#slave node

hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/local-hostname)

#This is a requirement for some CNI plugins to work
sysctl net.bridge.bridge-nf-call-iptables=1

# wait for master node
while [ "None" = "$(aws ssm get-parameters --names 'k8s-init-token' --query '[Parameters[0].Value]' --output text  --with-decryption --region "${aws_region}")" ];do echo "waiting for init master"; sleep 5;done

TOKEN=$(aws ssm get-parameters --names "k8s-init-token" --query '[Parameters[0].Value]' --output text --with-decryption  --region "${aws_region}")
TOKEN_HASH=$(aws ssm get-parameters --names "k8s-init-token-hash" --query '[Parameters[0].Value]' --output text  --with-decryption --region "${aws_region}")

kubeadm join kubernetes.k8s.devopxlabs.com:6443 --token $TOKEN --discovery-token-ca-cert-hash sha256:$TOKEN_HASH 
