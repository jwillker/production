#!/bin/bash

set -euxo pipefail
#TODO add ETCD

aws ssm delete-parameter --name "k8s-ca" --region us-east-1
aws ssm delete-parameter --name "k8s-ca-key" --region us-east-1
aws ssm delete-parameter --name "k8s-sa" --region us-east-1
aws ssm delete-parameter --name "k8s-sa-key" --region us-east-1
aws ssm delete-parameter --name "k8s-front-proxy-ca" --region us-east-1
aws ssm delete-parameter --name "k8s-front-proxy-ca-key" --region us-east-1
aws ssm delete-parameter --name "k8s-init-token" --region us-east-1
aws ssm delete-parameter --name "k8s-init-token-hash" --region us-east-1
