
terraform {
  required_version = "= 0.14.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.12.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "assignment-terraform-state"
    key    = "production/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

locals {
  // underscore is prefereble according to official terraform bestpractice, but alb only accepts hyphen based name.
  // Moreover, terraform AWS provider v3.12.0 (via Terraform 0.14) has issue #7987 related to "Provider produced inconsistent final plan". 
  // It means that S3 bucket has to be created before referencing it as an argument inside access_logs = { bucket = "bucket-name" }, so this won't work: access_logs = { bucket = module.s3.s3_bucket_id }.
  access_log_bucket_name = replace("${var.name}_logs", "_", "-")
  app_bucket_name        = replace("${var.name}_apps", "_", "-")
}

module "vpc" {
  source              = "../modules/vpc"
  name                = var.name
  cidr                = var.cidr
  azs                 = var.azs
  public_subnets      = var.public_subnets
  database_subnets    = var.database_subnets
  elasticache_subnets = var.elasticache_subnets
}

module "security_group" {
  source   = "../modules/security_group"
  name     = var.name
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.cidr
}

module "s3" {
  source                 = "../modules/s3"
  service                = var.service
  name                   = var.name
  app_bucket_name        = local.app_bucket_name
  access_log_bucket_name = local.access_log_bucket_name
}

module "ec2" {
  source          = "../modules/ec2"
  name            = var.name
  service         = var.service
  instance_count  = var.web_instance_count
  security_groups = [module.security_group.app_sg_id]
  subnets         = module.vpc.public_subnets
  ssh_key_name    = var.web_ssh_key_name
  instance_type   = var.web_instance_type
  instance_ami    = var.web_instance_ami
  ebs_volume_size = var.ebs_volume_size
}

module "alb" {
  source               = "../modules/alb"
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  security_groups      = [module.security_group.alb_sg_id]
  subnets              = module.vpc.public_subnets
  access_log_bucket_id = local.access_log_bucket_name
  ssl_cert_arn         = var.web_ssl_cert_arn
  instance_ids         = module.ec2.instance_ids
}

module "db" {
  source                     = "../modules/db"
  service                    = var.service
  env                        = var.env
  name                       = var.name
  database_name              = var.database_name
  user                       = var.database_user
  password                   = var.database_password
  subnets                    = module.vpc.database_subnets
  database_subnet_group_name = module.vpc.database_subnet_group_name
  security_groups            = [module.security_group.database_sg_id]
}

module "redis" {
  source          = "../modules/redis"
  name            = var.name
  service         = var.service
  env             = var.env
  azs             = var.azs
  subnet          = module.vpc.elasticache_subnet_group_name
  security_groups = [module.security_group.redis_sg_id]
}

module "datadog_integration" {
  source              = "../modules/datadog_integration"
  service             = var.service
  datadog_api_key     = var.datadog_api_key
  datadog_app_key     = var.datadog_app_key
  aws_account_id      = var.aws_account_id
}

module "datadog_monitor" {
  source          = "../modules/datadog_monitor"
  name            = var.name
  datadog_api_key = var.datadog_api_key
  datadog_app_key = var.datadog_app_key
  channel_name    = var.channel_name
}