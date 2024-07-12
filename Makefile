.PHONY: start stop k8s k8s-init ansible-req tf-init plan apply packer-init

include .env

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

plan:
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
