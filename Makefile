.ONESHELL:
.SHELL := /usr/bin/bash
.PHONY: apply destroy-backend destroy destroy-target plan-destroy plan plan-target prep

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


get/api-server/lb:
	$(eval LB_URL := $(shell cd infra/live/prod && terraform output kubernetes_api_lb))
	$(eval API_IP := $(shell	dig $(LB_URL) | grep -A 2 "ANSWER SECTION" | awk '{print $$5}' | head -n2))
	sudo echo $(API_IP) kubernetes.k8s.devopxlabs.com >> /etc/hosts

get/api-server/kube-config:
	while [ "None" = "$$(aws ssm get-parameters --names 'kube-config' --query '[Parameters[0].Value]' --output text  --with-decryption)" ];do echo "waiting for init master"; sleep 5;done
	aws ssm get-parameters --name "kube-config" --query '[Parameters[0].Value]' --output text  --with-decryption > ./infra/live/prod/kube.config

test/api-server/connection: get/api-server/lb get/api-server/kube-config
#test/api-server/connection: get/api-server/kube-config
	@echo "\n Show nodes if connected \n"
	kubectl --kubeconfig ./infra/live/prod/kube.config get nodes

api-server/delete/hosts:
	#TODO remove line in /etc/hosts

docker/registry/login:
	$$(aws ecr get-login --no-include-email)


# TODO remove Latest tag and use git revision
docker/build:
	$(eval DISCOUNTS := $(shell cd infra/live/prod && terraform output discounts_ecr))
	$(eval PRODUCTS := $(shell cd infra/live/prod && terraform output products_ecr))
	@echo "Building discounts and products apps.."
	docker build -t $(DISCOUNTS):latest -f ./apps/backend-hash/discounts/Dockerfile ./apps/backend-hash/discounts
	docker build -t $(PRODUCTS):latest -f ./apps/backend-hash/products/Dockerfile ./apps/backend-hash/
	docker push $(DISCOUNTS):latest
	docker push $(PRODUCTS):latest

docker/build/push: docker/registry/login docker/build

helm/init:
	helm init --service-account tiller --force-upgrade --kubeconfig infra/live/prod/kube.config

script/create/db:
	$(eval MYSQL := $(shell cd infra/live/prod && terraform output db_instance_address))
	mysql -u admin -padmin1234 -h $(MYSQL) < ./apps/backend-hash/database/init.sql

istio/enable/injection:
	kubectl --kubeconfig infra/live/prod/kube.config create namespace discounts
	kubectl --kubeconfig infra/live/prod/kube.config create namespace products
	kubectl --kubeconfig infra/live/prod/kube.config label namespace discounts istio-injection=enabled
	kubectl --kubeconfig infra/live/prod/kube.config label namespace products istio-injection=enabled
	kubectl --kubeconfig infra/live/prod/kube.config label namespace kube-logging istio-injection=enabled

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

helm/delete/products:
	helm delete --purge production-products --kubeconfig infra/live/prod/kube.config

helm/delete/istio-init:
	helm delete --purge istio-init --kubeconfig infra/live/prod/kube.config

helm/delete/istio:
	helm delete --purge istio --kubeconfig infra/live/prod/kube.config

deploy/all: infra/prod/apply test/api-server/connection docker/registry/login docker/build/push helm/init script/create/db istio/enable/injection helm/deploy/discounts helm/deploy/products
# TODO
# - Verify
# - init
# - apply
# - build/push
# - deploy/all
# - test


destroy/all: helm/delete/products helm/delete/discounts helm/delete/istio infra/prod/destroy
# TODO
# - Istio deploy, LBs and SGs with tag key: kubernetes.io/cluster/lab value:owned
# - remove /etc/hosts

