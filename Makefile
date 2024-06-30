.PHONY: start stop k8s ansible-req

include .env

start:
	@vagrant up

stop:
	@vagrant halt

k8s: start
	@ansible-playbook ansible/playbooks/install-k8s.yml -l k8s

ansible-req:
	@ansible-galaxy collection install -r requirements.yaml --force

tf-init:
	terraform -chdir="./tf" init

plan:
	terraform -chdir="./tf" plan -out tfplan

apply:
	terraform -chdir="./tf" apply tfplan
