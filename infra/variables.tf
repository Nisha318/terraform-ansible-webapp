variable "project_name" {
  type = string
  default="terraform-ansible-webapp"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

# 2 public, 2 private app, 2 private data
variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"] # app tier
}

variable "database_subnets" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24"] # data tier
}

variable "enable_nat" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = false # two NATs (one per AZ)
}

variable "key_name" {
  type = string
  default="nisha-webapp"
}

variable "admin_cidr" {
  description = "Your admin IP or VPN CIDR allowed to SSH to bastion"
  type        = string
}

variable "web_instance_type" {
  description = "Instance type for web servers"
  type        = string
  default     = "t3.micro"
}

