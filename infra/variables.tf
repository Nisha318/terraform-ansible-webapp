variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}

variable "enable_nat" {
  type = bool
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "key_name" {
  type = string
}

variable "admin_cidr" {
  description = "Your admin IP or VPN in CIDR format"
  type        = string
  # example: "136.244.42.75/32"
}

variable "ansible_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "web_instance_type" {
  type    = string
  default = "t3.micro"
}
