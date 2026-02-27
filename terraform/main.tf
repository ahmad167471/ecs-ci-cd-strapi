terraform {
  backend "s3" {
    bucket  = "ahmad-terraform-state-2026"
    key     = "bluegreen/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

#########################
# VPC Module
#########################
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

#########################
# Security Groups Module
#########################
module "security_groups" {
  source       = "./modules/security_groups"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

#########################
# ALB Module
#########################
module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg_id      = module.security_groups.alb_sg_id
  project_name   = var.project_name
}

#########################
# ECR Module
#########################
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "ahmad-strapi-bluegreen"
}

#########################
# RDS Module
#########################
module "rds" {
  source = "./modules/rds"

  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  ecs_sg_id       = module.security_groups.ecs_sg_id

  db_name     = var.database_name
  db_username = var.database_username
  db_password = var.database_password
}

#########################
# ECS Module
#########################
module "ecs" {
  source = "./modules/ecs"

  aws_region      = var.aws_region
  project_name    = var.project_name
  private_subnets = module.vpc.private_subnets
  ecs_sg_id       = module.security_groups.ecs_sg_id
  blue_tg_arn     = module.alb.blue_tg_arn
  log_group_name  = "/ecs/${var.project_name}"

  # Database (from RDS + root vars)
  db_host           = module.rds.db_endpoint
  db_username       = var.database_username
  db_password       = var.database_password
  database_name     = var.database_name
  database_username = var.database_username
  database_password = var.database_password
  database_port     = var.database_port
  database_client   = var.database_client

  # Strapi Secrets
  app_keys            = var.app_keys
  api_token_salt      = var.api_token_salt
  admin_jwt_secret    = var.admin_jwt_secret
  transfer_token_salt = var.transfer_token_salt
  encryption_key      = var.encryption_key
  jwt_secret          = var.jwt_secret
}

#########################
# CodeDeploy Module
#########################
module "codedeploy" {
  source = "./modules/codedeploy"

  cluster_name  = module.ecs.cluster_name
  service_name  = module.ecs.service_name
  blue_tg_name  = module.alb.blue_tg_name
  green_tg_name = module.alb.green_tg_name
  listener_arn  = module.alb.listener_arn
}