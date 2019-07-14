# ETCD
etcd/upload/certs:
	cd ./etcd && ./upload_certs_ssm.sh

etcd/ami/build:
	cd ./etcd/ami && packer build packer.json



# Kubernetes
k8s/ami/build:
	cd ./ami && packer build packer.json
