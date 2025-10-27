output "vpc_id"            { value = module.vpc.vpc_id }
output "public_subnets"    { value = module.vpc.public_subnets }
output "private_app_subnets" { value = module.vpc.private_subnets }
output "private_data_subnets" { value = module.vpc.database_subnets }
output "bastion_public_ip" { value = aws_instance.bastion.public_ip }
