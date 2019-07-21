build:
	packer build packer.json

terraform/init:
	cd tests && terraform init

terraform/apply:
	cd tests && terraform apply -auto-approve

terraform/destroy:
	cd tests && terraform destroy -auto-approve

verify:
	cd tests && inspec exec base -t ssh://ubuntu@$(shell cd tests && terraform output public_ip) --log-level=error

test: terraform/init terraform/apply verify terraform/destroy
