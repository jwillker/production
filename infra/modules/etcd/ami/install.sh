#!/bin/bash

set -euxo pipefail
export PIP_DISABLE_PIP_VERSION_CHECK=1

sudo apt-get -y install wget python-pip

sudo locale-gen en_GB.UTF-8
#sudo su && pip install --no-cache-dir awscli
sudo -H -u root bash -c 'pip install --no-cache-dir awscli'

# ETCD directories
sudo useradd etcd
sudo mkdir -p /opt/etcd

ETCD_VERSION="v3.3.8"
ETCD_URL="https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz"
ETCD_CONFIG=/etc/etcd


sudo wget ${ETCD_URL} -O /tmp/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -nv
sudo tar -xzf /tmp/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -C /tmp
sudo install --owner root --group root --mode 0755     /tmp/etcd-${ETCD_VERSION}-linux-amd64/etcd /usr/bin/etcd
sudo install --owner root --group root --mode 0755     /tmp/etcd-${ETCD_VERSION}-linux-amd64/etcdctl /usr/bin/etcdctl
sudo install -d --owner root --group root --mode 0755 ${ETCD_CONFIG}

sudo mv /tmp/etcd.service /etc/systemd/system/etcd.service
sudo mv /tmp/etcd.conf /etc/etcd/etcd.conf
sudo chmod 0644 /etc/systemd/system/etcd.service
