.PHONY: init start stop k8s k8s-init ansible-req tf-init plan apply packer-init packer-build helm-dry-run helm-install
include .env

init: start ansible-req k8s k8s-init
	echo pronto!

start:
	@vagrant up

stop:
	@vagrant halt

k8s:
	@ansible-playbook ansible/playbooks/install-k8s.yaml -l k8s

k8s-init:
	@ansible-playbook ansible/playbooks/configure-k8s.yaml -l k8s

ansible-req:
	@ansible-galaxy collection install -r requirements.yaml --force

tf-init:
	terraform -chdir="./tf" init

tf-fmt:
	terraform -chdir="./tf" fmt

tf-lint:
	terraform -chdir="./tf" validate

plan: tf-fmt tf-lint
	terraform -chdir="./tf" plan -out tfplan

apply:
	terraform -chdir="./tf" apply tfplan

packer-fmt:
	packer fmt packer

packer-validate:
	packer validate -var-file=packer/variables.pkrvars.hcl packer/

packer-init:
	packer init packer/aws-ubuntu.pkr.hcl

packer-build: packer-fmt packer-validate
	packer build -var-file=packer/variables.pkrvars.hcl packer/

helm-dry-run:
	helm install controle-contas ./chart --dry-run --debug

helm-install:
	helm install controle-contas ./chart --create-namespace --namespace cc
