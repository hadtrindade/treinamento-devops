resource "aws_vpc" "this" {
  cidr_block         = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC lab k8s"
  }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "Terraform IGW"
  }
}

data "aws_availability_zone" "this" {
    state = "available"
}

resource "aws_subnet" "public" {
    count = 3

    cidr_block        = element(slice(cidrsubnets("10.0.0.0/16", 8,8,8,8,8,8), 0, 2), count.index)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    map_public_ip_on_launch = true

    vpc_id = aws_vpc.this.id

  tags = {
    Name = "public-${element(data.aws_availability_zones.available.names, count.index)}"
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

    count = 3

    subnet_id      = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public.id

}

resource "aws_subnet" "private" {

    count = 3

    cidr_block        = element(slice(cidrsubnets("10.0.0.0/16", 8,8,8,8,8,8), 0, 2), count.index)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)

    vpc_id = aws_vpc.this.id

    tags = {
      Name = "private-${element(data.aws_availability_zones.available.names, count.index)}"
    }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private" {

  count = 3

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "this" {
    domain = "vpc"

    tags = {
        Name = "nat-gw-instance"
    }
}

module "fck-nat" {
  source = "github.com/RaJiska/terraform-aws-fck-nat?ref=2b147f0f888136e4f6a24ce21facca5fa0457dd3"

  name                 = "nat-instance"
  use_spot_instances   = true
  vpc_id               = aws_vpc.this.id
  subnet_id            = aws_subnet.public.0.id
  ha_mode              = true
  eip_allocation_ids   = [aws_eip.this.id]
  update_route_table   = true
  route_table_id       = aws_route_table.private.id
  
}

resource "aws_security_group" "dev" {
    name = "dsg_dev"
    vpc_id = aws_vpc.this.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ var.vpc_cidr_block ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "sg-dev"
    }
}
