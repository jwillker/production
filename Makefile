.ONESHELL:
.SHELL := /usr/bin/bash
.PHONY: apply destroy

#Verify local dependencies
verify:
	@bash ./scripts/verify.sh

infra/ami/build:
	packer build ../../modules/kubernetes/ami/packer.json
	packer build ../../modules/etcd/ami/packer.json

infra/backend/init:
	cd infra/live/remote-state && terraform init

infra/backend/apply:
	cd infra/live/remote-state && terraform apply -auto-approve

infra/backend/destroy:
	cd infra/live/remote-state && terraform destroy -auto-approve

infra/prod/init:
	cd infra/live/prod && terraform init

infra/prod/apply:
	cd infra/live/prod && terraform apply -auto-approve

infra/prod/destroy:
	cd infra/live/prod && terraform destroy -auto-approve


#This was only necessary because there was no domain registered
get/api-server/lb:
	$(eval LB_URL := $(shell cd infra/live/prod && terraform output kubernetes_api_lb))
	$(eval API_IP := $(shell	dig $(LB_URL) | grep -A 2 "ANSWER SECTION" | awk '{print $$5}' | head -n2))
	sudo echo $(API_IP) kubernetes.k8s.devopxlabs.com >> /etc/hosts

get/api-server/kube-config:
	while [ "None" = "$$(aws ssm get-parameters --names 'kube-config' --query '[Parameters[0].Value]' --output text  --with-decryption)" ];do echo "waiting for init master"; sleep 5;done
	aws ssm get-parameters --name "kube-config" --query '[Parameters[0].Value]' --output text  --with-decryption > ./infra/live/prod/kube.config

test/api-server/connection: get/api-server/lb get/api-server/kube-config
#test/api-server/connection: get/api-server/kube-config
	@echo "\n Wait some time ... \n"
	@sleep 60
	@echo "\n Show nodes if connected \n"
	kubectl --kubeconfig ./infra/live/prod/kube.config get nodes

api-server/delete/hosts:
	sudo sed -i -e '$ d'  /etc/hosts

docker/registry/login:
	$$(aws ecr get-login --no-include-email)

docker/build:
	$(eval DISCOUNTS := $(shell cd infra/live/prod && terraform output discounts_ecr))
	$(eval PRODUCTS := $(shell cd infra/live/prod && terraform output products_ecr))
	$(eval DATABASE := $(shell cd infra/live/prod && terraform output database_ecr))
	@echo "Building discounts and products apps.."
	docker build -t $(DISCOUNTS):latest -f ./apps/backend-hash/discounts/Dockerfile ./apps/backend-hash/discounts
	docker build -t $(PRODUCTS):latest -f ./apps/backend-hash/products/Dockerfile ./apps/backend-hash/
	docker build -t $(DATABASE):latest -f ./apps/backend-hash/database/Dockerfile ./apps/backend-hash/database
	docker push $(DISCOUNTS):latest
	docker push $(PRODUCTS):latest
	docker push $(DATABASE):latest

docker/build/push: docker/registry/login docker/build

helm/init:
	helm init --service-account tiller --force-upgrade --kubeconfig infra/live/prod/kube.config

script/create/db:
	kubectl --kubeconfig infra/live/prod/kube.config apply -f apps/backend-hash/database/init.yaml

istio/enable/injection:
	kubectl --kubeconfig infra/live/prod/kube.config create namespace discounts
	kubectl --kubeconfig infra/live/prod/kube.config create namespace products
	kubectl --kubeconfig infra/live/prod/kube.config label namespace discounts istio-injection=enabled
	kubectl --kubeconfig infra/live/prod/kube.config label namespace products istio-injection=enabled

logging/deploy:
	kubectl --kubeconfig infra/live/prod/kube.config apply -f apps/monitor/kube-logging.yaml
	kubectl --kubeconfig infra/live/prod/kube.config apply -f apps/monitor/
	kubectl --kubeconfig infra/live/prod/kube.config rollout status -n kube-logging -w "sts/es-cluster"
	kubectl --kubeconfig infra/live/prod/kube.config rollout status -n kube-logging -w "deployment/kibana"
	@sleep 30

logging/delete:
	kubectl --kubeconfig infra/live/prod/kube.config delete -f apps/monitor/

logging/create-pattern:
	$(eval POD := $(shell kubectl --kubeconfig infra/live/prod/kube.config get pod -n kube-logging -l 'app=kibana' --field-selector=status.phase=Running -o jsonpath="{.items[0].metadata.name}"))
	kubectl --kubeconfig infra/live/prod/kube.config exec -it $(POD) -n kube-logging -- /bin/curl --request POST http://localhost:5601/api/saved_objects/index-pattern/metricbeat -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -H 'x-vi-plant: male' -d '{"attributes": {"title": "metricbeat-*", "timeFieldName": "@timestamp"}}'
	kubectl --kubeconfig infra/live/prod/kube.config exec -it $(POD) -n kube-logging -- /bin/curl --request POST http://localhost:5601/api/saved_objects/index-pattern/logstash -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -H 'x-vi-plant: male' -d '{"attributes": {"title": "filebeat-*", "timeFieldName": "@timestamp"}}'

logging/create-dashboards:
	$(eval POD := $(shell kubectl --kubeconfig infra/live/prod/kube.config get pod -n kube-system -l 'k8s-app=metricbeat' --field-selector=status.phase=Running -o jsonpath="{.items[0].metadata.name}"))
	kubectl --kubeconfig infra/live/prod/kube.config exec -it $(POD) -n kube-system -- /usr/share/metricbeat/metricbeat setup --dashboards -c /etc/metricbeat.yml

logging/url:
	@$(eval INGRESS_HOST := $(shell kubectl --kubeconfig infra/live/prod/kube.config -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'))
	@echo "ACCESS KIBANA IN: ...."
	@echo " "
	@echo $(INGRESS_HOST)
	@echo " "

helm/deploy/discounts:
	$(eval DISCOUNTS := $(shell cd infra/live/prod && terraform output discounts_ecr))
	$(eval MYSQL := $(shell cd infra/live/prod && terraform output db_instance_address))
	helm --kubeconfig infra/live/prod/kube.config upgrade --install \
			--set image.repository=$(DISCOUNTS) \
			--set image.tag="latest" \
			--set image.pullPolicy=Always \
			--set application.track="stable" \
			--set releaseOverride="production-discounts" \
			--set ingress.enabled="false" \
			--set serviceweb.enabled="true" \
			--set service.internalPort="5001" \
			--set service.externalPort="5001" \
			--set service.type="ClusterIP" \
			--set replicaCount="3" \
			--set application.application_name="discounts-api" \
			--set app_env="production" \
			--set db.host=$(MYSQL) \
			--set db.database="api" \
			--set db.username="admin" \
			--set db.password="admin1234" \
			--set grpc.port="5001" \
			--set http.port="80" \
			--set discounts.port="5001" \
			--set log.level="INFO" \
			--set livenessprobe.typeProbe="tcpSocket" \
			--set livenessprobe.initialDelaySeconds="15" \
			--set readinessprobe.initialDelaySeconds="15" \
			--set resources.requests.memory="200Mi" \
			--set resources.requests.cpu="200m" \
			--set resources.limits.memory="500Mi" \
			--set resources.limits.cpu="1000m" \
			--namespace="discounts" \
			--version="1" \
			"production-discounts" \
			apps/backend-hash/deploy/

helm/delete/discounts:
	helm delete --purge production-discounts --kubeconfig infra/live/prod/kube.config

helm/deploy/products:
	$(eval PRODUCTS := $(shell cd infra/live/prod && terraform output products_ecr))
	$(eval MYSQL := $(shell cd infra/live/prod && terraform output db_instance_address))
	helm --kubeconfig infra/live/prod/kube.config upgrade --install \
			--set image.repository=$(PRODUCTS) \
			--set image.tag="latest" \
			--set image.pullPolicy=Always \
			--set application.track="stable" \
			--set releaseOverride="production-products" \
			--set ingress.enabled="true" \
			--set serviceweb.enabled="true" \
			--set service.internalPort="80" \
			--set service.externalPort="80" \
			--set service.probe.healthcheck="/products" \
			--set replicaCount="3" \
			--set application.application_name="products-api" \
			--set app_env="production" \
			--set db.host=$(MYSQL) \
			--set db.database="api" \
			--set db.username="admin" \
			--set db.password="admin1234" \
			--set grpc.port="5002" \
			--set discounts.port="5001" \
			--set http.port="80" \
			--set log.level="INFO" \
			--set livenessprobe.typeProbe="httpGet" \
			--set livenessprobe.initialDelaySeconds="15" \
			--set readinessprobe.initialDelaySeconds="15" \
			--set discounts.address="discounts-api" \
			--set resources.requests.memory="200Mi" \
			--set resources.requests.cpu="200m" \
			--set resources.limits.memory="500Mi" \
			--set resources.limits.cpu="1000m" \
			--namespace="products" \
			--version="1" \
			"production-products" \
			apps/backend-hash/deploy/

products/url:
	@$(eval INGRESS_HOST := $(shell kubectl --kubeconfig infra/live/prod/kube.config -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'))
	@echo "ACCESS PRODUCTS IN: ...."
	@echo $(INGRESS_HOST)'/products'
	@echo " "

helm/delete/products:
	helm delete --purge production-products --kubeconfig infra/live/prod/kube.config

helm/delete/istio-init:
	helm delete --purge istio-init --kubeconfig infra/live/prod/kube.config

helm/delete/istio:
	helm delete --purge istio --kubeconfig infra/live/prod/kube.config

#DELETE EBS PROVISIONED BY DYNAMIC PV
ebs/delete:
	aws ec2 describe-volumes \
    --filters Name=tag:kubernetes.io/created-for/pvc/namespace,Values=kube-logging* \
    --query "Volumes[*].{ID:VolumeId}" | jq -a '.[].ID' | xargs -I {} aws ec2 delete-volume --volume-id {}

#DELETE SG PROVISIONED BY Istio
sg/delete:
	aws ec2 describe-security-groups \
    --filters Name=tag:kubernetes.io/cluster/lab,Values=owned \
  --query "SecurityGroups[*].GroupId[]" | jq '.[]' | xargs -I {} aws ec2 delete-security-group --group-id {}

deploy/all: verify infra/ami/build infra/prod/apply test/api-server/connection docker/registry/login docker/build/push helm/init script/create/db istio/enable/injection logging/deploy logging/create-pattern logging/create-dashboards logging/url helm/deploy/discounts helm/deploy/products products/url

destroy/all: helm/delete/products helm/delete/discounts helm/delete/istio logging/delete ebs/delete infra/prod/destroy api-server/delete/hosts

