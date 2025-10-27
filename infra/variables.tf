variable "project_name"        { type = string }
variable "region"              { type = string  default = "us-east-1" }
variable "vpc_cidr"            { type = string  default = "10.0.0.0/16" }
variable "azs"                 { type = list(string) default = ["us-east-1a","us-east-1b"] }

# Two public, two private app, two private data
variable "public_subnets"      { type = list(string) default = ["10.0.0.0/24","10.0.1.0/24"] }
variable "private_subnets"     { type = list(string) default = ["10.0.2.0/24","10.0.3.0/24"] }   # app
variable "database_subnets"    { type = list(string) default = ["10.0.4.0/24","10.0.5.0/24"] }   # data

variable "enable_nat"          { type = bool default = true }
variable "single_nat_gateway"  { type = bool default = false }   # ← two NATs (one per AZ)

variable "key_name"            { type = string }                 # EC2 key pair name
