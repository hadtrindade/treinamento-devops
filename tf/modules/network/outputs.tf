output "vpc_id" {
    description = "ID of vpc"
    value = aws_vpc.this.id
}

output "subnets_private" {
  description = "IDs of subnets privates"
  value = aws_subnet.private[*].id
}

output "subnets_public" {
  description = "IDs of subnets privates"
  value = aws_subnet.public[*].id
}

output "sg_dev_id" {
    description = "ID of secgroup dev"
    value = aws_security_group.dev.id
}

