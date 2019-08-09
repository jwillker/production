deploy:
	@cd examples && terraform init
	@cd examples && terraform apply -auto-approve

destroy:
	@cd examples && terraform destroy -auto-approve


LB_URL := $(shell terraform output kubernetes_api_lb)
API_IP := $(shell	dig $(LB_URL) | grep -A 2 "ANSWER SECTION" | awk '{print $$5}' | head -n2)
get/api-server/lb:
	sudo echo $(API_IP) kubernetes.k8s.devopxlabs.com >> /etc/hosts

# TODO if parameter is none, loop
get/api-server/kube-config:
	while [ "None" = "$$(aws ssm get-parameters --names 'kube-config' --query '[Parameters[0].Value]' --output text  --with-decryption)" ];do echo "waiting for init master"; sleep 5;done
	aws ssm get-parameters --name "kube-config" --query '[Parameters[0].Value]' --output text  --with-decryption > ./kube.config

test/api-server/connection: get/api-server/lb get/api-server/kube-config
	@echo "\n Show nodes if connected \n"
	kubectl --kubeconfig kube.config get nodes
