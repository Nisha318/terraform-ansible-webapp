module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1"

  name               = "${var.project_name}-vpc"
  cidr               = var.vpc_cidr
  azs                = var.azs
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  database_subnets   = var.database_subnets
  enable_nat_gateway = var.enable_nat
  single_nat_gateway = var.single_nat_gateway

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags             = { Project = var.project_name }
  nat_gateway_tags = { Purpose = "egress" }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"]
  filter { name = "name" values = ["al2023-ami-*-x86_64"] }
}

# Bastion (public AZ1)
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  tags = { Name = "${var.project_name}-bastion" }
}

# Ansible server (private app AZ1)
resource "aws_instance" "ansible_server" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.ansible_instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = false
  tags = { Name = "${var.project_name}-ansible-server", Role = "AnsibleServer" }
}

# Two web servers, one per private app subnet
locals {
  web_subnets = {
    az1 = module.vpc.private_subnets[0]
    az2 = module.vpc.private_subnets[1]
  }
}

resource "aws_instance" "web" {
  for_each                     = local.web_subnets
  ami                          = data.aws_ami.al2023.id
  instance_type                = var.web_instance_type
  key_name                     = var.key_name
  subnet_id                    = each.value
  vpc_security_group_ids       = [aws_security_group.web_sg.id]
  associate_public_ip_address  = false
  tags = { Name = "${var.project_name}-web-${each.key}", Role = "WebServer" }
}
