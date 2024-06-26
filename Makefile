.PHONY: start stop k8s ansible-collections

start:
	@vagrant up

stop:
	@vagrant halt

k8s: start
	@ansible-playbook ansible/playbooks/install-k8s.yml -l k8s

ansible-collections:
	@ansible-galaxy collection install -r requirements.yaml --force