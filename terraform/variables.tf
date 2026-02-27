variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "ahmad-bluegreen"
}

# RDS credentials
variable "db_username" {
  description = "RDS PostgreSQL username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "RDS PostgreSQL password"
  type        = string
  sensitive   = true
}

# Strapi DB config
variable "database_name" {
  description = "Database name for Strapi"
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
  description = "Database port for Strapi"
  type        = number
  default     = 5432
}

variable "database_client" {
  description = "Database client for Strapi (postgres/mysql/sqlite)"
  type        = string
  default     = "postgres"
}

# Strapi secrets
variable "app_keys" {
  description = "Strapi app keys"
  type        = string
}

variable "api_token_salt" {
  description = "Strapi API token salt"
  type        = string
}

variable "admin_jwt_secret" {
  description = "Strapi admin JWT secret"
  type        = string
}

variable "transfer_token_salt" {
  description = "Strapi transfer token salt"
  type        = string
}

variable "encryption_key" {
  description = "Strapi encryption key"
  type        = string
}

variable "jwt_secret" {
  description = "Strapi JWT secret"
  type        = string
  sensitive   = true
}