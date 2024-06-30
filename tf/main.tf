module "network" {
  source         = "./modules/network"
  vpc_cidr_block = "10.0.0.0/16"
  subnet_count   = 2
  nat_instance   = false
}

module "k8s" {
  source = "./modules/compute"

  vpc_id             = module.network.vpc_id
  master_count       = 0
  worker_count       = 0
  instance_type      = "t3a.small"
  sec_groups_ids     = [module.network.secgroup_default_id]
  subnet_ids         = module.network.subnets_public
  key_ssh_id_sra_pub = file(var.ssh_key_path)

  tags = {
    "Enviromment" = "dev"
  }

}
