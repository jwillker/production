deploy:
	@cd examples && terraform init
	@cd examples && terraform apply -auto-approve

destroy:
	@cd examples && terraform destroy -auto-approve

verify:
	@inspec exec tests/instances -t aws://

test: deploy verify destroy
