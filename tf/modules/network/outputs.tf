output "vpc_id" {
  description = "ID of vpc"
  value       = aws_vpc.this.id
}

output "subnets_private" {
  description = "IDs of subnets privates"
  value       = aws_subnet.private[*].id
}

output "subnets_public" {
  description = "IDs of subnets privates"
  value       = aws_subnet.public[*].id
}

output "secgroup_default_id" {
  description = "ID of secgroup default"
  value       = aws_security_group.default.id
}

output "ip_nat_instance" {
  description = "IP of nat instance"
  value       = aws_eip.this.public_ip
}