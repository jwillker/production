terraform/backend/init:
	cd infra/live/remote-state && terraform init

terraform/backend/apply:
	cd infra/live/remote-state && terraform apply -auto-approve

terraform/backend/destroy:
	cd infra/live/remote-state && terraform destroy -auto-approve

cloud/infra/kubernetes/init:
	cd infra/live/kubernetes && terraform init

cloud/infra/kubernetes/apply:
	cd infra/live/kubernetes && terraform apply -auto-approve

cloud/infra/kubernetes/apply:
	cd infra/live/kubernetes && terraform destroy -auto-approve
