# VPC & subnets
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs (AZ1, AZ2)"
  value       = module.vpc.public_subnets
}

output "private_app_subnets" {
  description = "Private app subnet IDs (AZ1, AZ2)"
  value       = module.vpc.private_subnets
}

output "private_data_subnets" {
  description = "Private data (DB) subnet IDs (AZ1, AZ2)"
  value       = module.vpc.database_subnets
}

# Instances
output "bastion_public_ip" {
  description = "Bastion public IP"
  value       = aws_instance.bastion.public_ip
}

output "ansible_private_ip" {
  description = "Ansible server private IP (AZ1)"
  value       = aws_instance.ansible_server.private_ip
}

output "web_private_ips" {
  description = "Private IPs of web servers by AZ key"
  value       = { for k, inst in aws_instance.web : k => inst.private_ip }
}
