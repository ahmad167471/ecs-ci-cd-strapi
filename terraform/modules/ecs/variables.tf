#########################
# AWS & Project Settings
#########################

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

#########################
# Database Settings
#########################

variable "db_host" {
  description = "Database host"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "database_username" {
  description = "Database username for Strapi"
  type        = string
}

variable "database_password" {
  description = "Database password for Strapi"
  type        = string
  sensitive   = true
}

variable "database_port" {
  description = "Database port"
  type        = number
}

variable "database_client" {
  description = "Database client (postgres/mysql)"
  type        = string
}

#########################
# ECS Networking
#########################

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "ECS security group ID"
  type        = string
}

variable "blue_tg_arn" {
  description = "Blue target group ARN"
  type        = string
}

#########################
# Strapi Secrets
#########################

variable "app_keys" {
  type      = string
  sensitive = true
}

variable "api_token_salt" {
  type      = string
  sensitive = true
}

variable "admin_jwt_secret" {
  type      = string
  sensitive = true
}

variable "transfer_token_salt" {
  type      = string
  sensitive = true
}

variable "encryption_key" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}