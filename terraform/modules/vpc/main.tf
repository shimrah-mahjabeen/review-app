locals {
  // underscore is prefereble according to official terraform bestpractice, but elasticache_subnets only accepts hyphen based name.
  identifier = replace(var.name, "_", "-")
}

module "vpc" {
  source              = "terraform-aws-modules/vpc/aws"
  version             = "v2.77.0"
  name                = local.identifier
  cidr                = var.cidr
  azs                 = var.azs
  public_subnets      = var.public_subnets
  database_subnets    = var.database_subnets
  elasticache_subnets = var.elasticache_subnets
  enable_nat_gateway  = true
  single_nat_gateway  = true
  tags = {
    Terraform = "true"
  }
}
