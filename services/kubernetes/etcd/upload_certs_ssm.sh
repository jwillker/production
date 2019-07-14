#!/bin/bash

# TODO copy this files via packer

set -euxo pipefail
aws ssm put-parameter --name "etcd-ca" --value "$(cat ./ca.pem)"  --type "SecureString" --region us-east-1 --overwrite

aws ssm put-parameter --name "etcd-server" --value "$(cat ./server.pem)"  --type "SecureString" --region us-east-1 --overwrite

aws ssm put-parameter --name "etcd-server-key" --value "$(cat ./server-key.pem)"  --type "SecureString" --region us-east-1 --overwrite
