deploy:
	@cd examples && terraform init
	@cd examples && terraform apply -auto-approve

destroy:
	@cd examples && terraform destroy -auto-approve

verify:
	@inspec exec tests/sg -t aws://

output-file:
	@cd examples && terraform output --json > ../tests/sg/files/terraform.json

test: deploy output-file verify destroy
