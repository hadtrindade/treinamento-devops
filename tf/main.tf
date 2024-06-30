module "network" {
  source         = "./modules/network"
  vpc_cidr_block = "10.0.0.0/16"
}

module "k8s" {
  source = "./modules/compute"

  vpc_id         = module.network.vpc_id
  master_count   = 1
  worker_count   = 2
  instance_type  = "t3a.small"
  sec_groups_ids = [module.network.secgroup_default_id]
  tags = {
    "Enviromment" = "dev"
  }

}