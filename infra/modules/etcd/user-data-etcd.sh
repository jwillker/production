#!/bin/bash

set -euxo pipefail

sleep 30

AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | cut -b 10)

locale-gen en_GB.UTF-8

VOLUME_ID=$(aws ec2 describe-volumes --filters "Name=status,Values=available"  Name=tag:Name,Values=ebs_etcd_$AVAILABILITY_ZONE --query "Volumes[].VolumeId" --output text --region "${aws_region}")

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

aws ec2 attach-volume --region "${aws_region}" \
              --volume-id $VOLUME_ID \
              --instance-id $INSTANCE_ID \
              --device "/dev/xvdf"

while [ -z $(aws ec2 describe-volumes --filters "Name=status,Values=in-use"  Name=tag:Name,Values=ebs_etcd_$AVAILABILITY_ZONE --query "Volumes[].VolumeId" --output text --region "${aws_region}") ] ; do sleep 10; echo "ebs not ready"; done

sleep 5

if [[ -z $(blkid /dev/xvdf) ]]; then
  mkfs -t ext4 /dev/xvdf
fi

mount /dev/xvdf /opt/etcd
sudo mkdir -p /opt/etcd/data
sudo chown -R etcd:etcd /opt/etcd

sed -i s~AZONE~$AVAILABILITY_ZONE~g /etc/etcd/etcd.conf

aws ssm get-parameters --names "etcd-ca" --query '[Parameters[0].Value]' --output text  --with-decryption --region "${aws_region}" > /etc/ssl/certs/ca.pem
aws ssm get-parameters --names "etcd-server" --query '[Parameters[0].Value]' --output text  --with-decryption --region "${aws_region}" > /etc/ssl/server.pem
aws ssm get-parameters --names "etcd-server-key" --query '[Parameters[0].Value]' --output text  --with-decryption --region "${aws_region}" > /etc/ssl/server-key.pem

chmod 0600  /etc/ssl/server-key.pem
chmod 0644 /etc/ssl/server.pem
chown etcd:etcd /etc/ssl/server-key.pem
chown etcd:etcd /etc/ssl/server.pem

systemctl enable etcd
systemctl start etcd
