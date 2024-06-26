module "network" {
  source = "./modules/network"
  vpc_cidr_block = "10.0.0.0/16"
}