packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {

  profile = var.profile
  assume_role {
    role_arn     = "arn:aws:iam::${var.account}:role/${var.role_arn}"
    session_name = "packer"
  }

  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = var.ami_filter_name
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = [var.ami_owner]
  }
  ssh_username = "ubuntu"
}

build {
  name = "k8s"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell-local" {

    inline = [
      "pip install -r ${path.cwd}/requirements.txt",
      "ansible-galaxy collection install -r ${path.cwd}/requirements.yaml --force",
    ]
  }

  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/playbooks/install-k8s.yaml"
    extra_arguments = [
      "-vvvv"
    ]
    #ansible_env_vars = []

  }
}
