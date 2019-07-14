#!/bin/bash

set -euxo pipefail
aws ssm put-parameter --name "etcd-ca" --value "$(cat /etc/kubernetes/pki/ca.crt)"  --type "SecureString" --region us-east-1 --overwrite 
