output "network_ip_nat_gateway" {
  description = "IPs of instances workers"
  value       = module.network.ip_nat_instance
}

output "k8s_master_ips" {
  description = "IPs of instances masters"
  value       = module.k8s.master_ips
}

output "k8s_workers_ips" {
  description = "IPs of instances workers"
  value       = module.k8s.workers_ips
}