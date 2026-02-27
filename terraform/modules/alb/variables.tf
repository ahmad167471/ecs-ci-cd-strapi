variable "vpc_id" {
  type    = string
  default = "vpc-0778ad9a2069279fc"  # Replace with your VPC ID
}

variable "public_subnets" {
  type = list(string)
  default = [
    "subnet-03fee31eec3cf6f25", # Public 1 (use1-az5)
    "subnet-068a06b93690079f6"  # Public 2 (use1-az4)
  ]
}

variable "alb_sg_id" {
  type    = string
  default = "sg-0ea5d0e98f720d1a9"  # Replace with your ALB SG
}

variable "project_name" {
  type    = string
  default = "ahmad-bluegreen"
}