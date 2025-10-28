# Bastion in public AZ-1
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  tags = { Name = "${var.project_name}-bastion" }
}

# Ansible server in private app subnet AZ-1 (no bootstrap)
resource "aws_instance" "ansible_server" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.ansible_instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.project_name}-ansible-server"
    Role = "AnsibleServer"
  }
}

# Map each web server to a private app subnet: AZ1 and AZ2
locals {
  web_subnets = {
    az1 = module.vpc.private_subnets[0]
    az2 = module.vpc.private_subnets[1]
  }
}

resource "aws_instance" "web" {
  for_each                    = local.web_subnets
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.web_instance_type
  key_name                    = var.key_name # uses your imported EC2 key pair
  subnet_id                   = each.value   # AZ-specific private app subnet
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "${var.project_name}-web-${each.key}"
    Role = "WebServer"
  }
}
