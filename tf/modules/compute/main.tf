resource "aws_key_pair" "k8s" {
  key_name   = "k8s"
  public_key = var.key_ssh_id_sra_pub
}

resource "aws_security_group" "k8s" {
  vpc_id = var.vpc_id
  name   = "secgroup_k8s"

  egress {
    description = "All traffic output"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Default port of API SERVER"
    to_port     = 6443
    from_port   = 6443
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Ports of kubelet"
    to_port     = 10250
    from_port   = 10250
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Ports of kubelet"
    to_port     = 10255
    from_port   = 10255
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Ports of etcd"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    self        = true
  }

  dynamic "ingress" {
    for_each = ["tcp", "udp"]

    content {
      description = "Ports for using NodePort"
      from_port   = 30000
      to_port     = 32676
      protocol    = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  owners = ["136693071363"]
}

resource "aws_launch_template" "k8s" {
  name = "template_k8s"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
    }
  }

  image_id = data.aws_ami.debian.image_id

  instance_market_options {
    market_type = "spot"
  }

  instance_type = var.instance_type

  key_name = aws_key_pair.k8s.key_name

}

resource "aws_instance" "master" {
  count = var.master_count >= 1 ? var.master_count : 0

  launch_template {
    id      = aws_launch_template.k8s.id
    version = aws_launch_template.k8s.latest_version
  }

  vpc_security_group_ids      = concat([aws_security_group.k8s.id], var.sec_groups_ids)
  associate_public_ip_address = true
  subnet_id                   = element(var.subnet_ids, count.index)

  tags = merge(var.tags, {
    Name = "Master-${count.index}"
    }
  )

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_instance" "worker" {
  count = var.worker_count >= 1 ? var.worker_count : 0

  launch_template {
    id      = aws_launch_template.k8s.id
    version = aws_launch_template.k8s.latest_version
  }

  associate_public_ip_address = true
  subnet_id                   = element(var.subnet_ids, count.index)

  tags = merge(var.tags, {
    Name = "Worker-${count.index}"
    }
  )
  lifecycle {
    ignore_changes = [tags]
  }
}
