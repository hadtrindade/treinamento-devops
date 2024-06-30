locals {
  cidr_blocks_public  = slice(cidrsubnets("10.0.0.0/16", 8, 8, 8, 8, 8, 8), 0, var.subnet_count)
  cidr_blocks_private = slice(cidrsubnets("10.0.0.0/16", 8, 8, 8, 8, 8, 8), var.subnet_count, 6)
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC lab k8s"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "IGW lab k8s"
  }
}

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_subnet" "public" {
  count = var.subnet_count

  cidr_block              = element(local.cidr_blocks_public, count.index)
  availability_zone       = element(data.aws_availability_zones.this.names, count.index)
  map_public_ip_on_launch = true

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "public-${element(data.aws_availability_zones.this.names, count.index)}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "public"
  }
}


resource "aws_route_table_association" "public" {

  count = var.subnet_count

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id

}

resource "aws_subnet" "private" {

  count = var.subnet_count

  cidr_block        = element(local.cidr_blocks_private, count.index)
  availability_zone = element(data.aws_availability_zones.this.names, count.index)

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private-${element(data.aws_availability_zones.this.names, count.index)}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private" {

  count = var.subnet_count

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "this" {

  count = var.nat_instance ? 1 : 0

  domain = "vpc"

  tags = {
    Name = "nat-gw-instance"
  }
}

module "fck_nat" {
  source = "github.com/RaJiska/terraform-aws-fck-nat?ref=v1.2.0"

  count = var.nat_instance ? 1 : 0

  name               = "nat-instance"
  use_spot_instances = true
  vpc_id             = aws_vpc.this.id
  subnet_id          = aws_subnet.public[0].id
  ha_mode            = true
  eip_allocation_ids = [aws_eip.this[0].id]
  update_route_table = true
  route_table_id     = aws_route_table.private.id

}

resource "aws_security_group" "default" {
  name   = "secgroup_default"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-dev"
  }
}
