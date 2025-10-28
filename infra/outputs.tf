output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnets" { value = module.vpc.public_subnets }
output "private_app_subnets" { value = module.vpc.private_subnets }
output "private_data_subnets" { value = module.vpc.database_subnets }
output "bastion_public_ip" { value = aws_instance.bastion.public_ip }
output "ansible_private_ip" {
  description = "Private IP address of the Ansible server"
  value       = aws_instance.ansible_server.private_ip
}

output "web_private_ips" {
  description = "Private IPs of the web servers by AZ key"
  value       = { for k, inst in aws_instance.web : k => inst.private_ip }
}

output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Bastion public IP"
}
