output "key_name" {
  description = "key_name using in instances"
  value       = aws_key_pair.k8s.key_name
}

output "sec_groups_id" {
  description = "security group using in instances"
  value       = aws_security_group.k8s.id
}

output "master_ids" {
  description = "IDs of instances Masters"
  value       = aws_instance.master[*].id
}

output "worker_ids" {
  description = "IDs of instances workers"
  value       = aws_instance.worker[*].id
}

output "master_ips" {
  description = "IPs of instances Masters"
  value       = aws_instance.master[*].public_ip
}

output "workers_ips" {
  description = "IPs of instances Workers"
  value       = aws_instance.worker[*].public_ip
}
