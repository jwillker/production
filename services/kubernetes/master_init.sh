#!/bin/bash

set -euxo pipefail

locale-gen en_GB.UTF-8
hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/local-hostname)

mkdir -p /etc/kubernetes/pki/etcd

aws ssm get-parameters --names "etcd-ca" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/etcd/ca.crt
aws ssm get-parameters --names "etcd-server" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/apiserver-etcd-client.crt
aws ssm get-parameters --names "etcd-server-key" --query '[Parameters[0].Value]' --output text  --with-decryption --region us-east-1 > /etc/kubernetes/pki/apiserver-etcd-client.key

kubeadm init --config /opt/kubeadm-config.yaml --ignore-preflight-errors=all

# configure kubeconfig for kubectl
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown $(id -u):$(id -g) /root/.kube/config

# install calico
#kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
#kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
#

#Install cilium
#kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/cilium/cilium/v1.5/examples/kubernetes/1.14/cilium.yaml

#This is a requirement for some CNI plugins to work
sysctl net.bridge.bridge-nf-call-iptables=1

kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl --kubeconfig=/etc/kubernetes/admin.conf version | base64 | tr -d '\n')"

sleep 5
# initial master
aws ssm put-parameter --name "k8s-ca" --value "$(cat /etc/kubernetes/pki/ca.crt)"  --type "SecureString" --region us-east-1 --overwrite 
aws ssm put-parameter --name "k8s-ca-key" --value "$(cat /etc/kubernetes/pki/ca.key)"  --type "SecureString" --region us-east-1 --overwrite 
aws ssm put-parameter --name "k8s-sa" --value "$(cat /etc/kubernetes/pki/sa.pub)"  --type "SecureString" --region us-east-1 --overwrite 
aws ssm put-parameter --name "k8s-sa-key" --value "$(cat /etc/kubernetes/pki/sa.key)"  --type "SecureString" --region us-east-1 --overwrite 
aws ssm put-parameter --name "k8s-front-proxy-ca" --value "$(cat /etc/kubernetes/pki/front-proxy-ca.crt)"  --type "SecureString" --region us-east-1 --overwrite 
aws ssm put-parameter --name "k8s-front-proxy-ca-key" --value "$(cat /etc/kubernetes/pki/front-proxy-ca.key)"  --type "SecureString" --region us-east-1 --overwrite 

sleep 5
aws ssm put-parameter --name "k8s-init-token" --value "$(kubeadm token create)"  --type "SecureString" --region us-east-1 --overwrite 
aws ssm put-parameter --name "k8s-init-token-hash" --value "$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')"  --type "SecureString" --region us-east-1 --overwrite 
