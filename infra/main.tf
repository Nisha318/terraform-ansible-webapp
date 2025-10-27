module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1"

  name               = "${var.project_name}-vpc"
  cidr               = var.vpc_cidr
  azs                = var.azs
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets      # app tier
  database_subnets   = var.database_subnets     # data tier

  enable_nat_gateway                 = var.enable_nat
  single_nat_gateway                 = var.single_nat_gateway  # false = one NAT per AZ
  create_database_nat_gateway_route  = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Project = var.project_name }
  nat_gateway_tags = { Purpose = "egress" }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"]
  filter { name = "name" values = ["al2023-ami-*-x86_64"] }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = var.key_name
  tags = { Name = "${var.project_name}-bastion" }
}
