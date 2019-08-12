kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: generic
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  zones: ${AWS_DEFAULT_REGION}a, ${AWS_DEFAULT_REGION}b
  iopsPerGB: "10"
  fsType: ext4