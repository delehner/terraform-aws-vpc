output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "cidr_block" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "private_subnet_ids" {
  description = "IDs of the private subnets (one per AZ)."
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets (one per AZ)."
  value       = aws_subnet.public[*].id
}

output "app_security_group_id" {
  description = "ID of the shared app security group (null when create_app_security_group is false)."
  value       = var.create_app_security_group ? aws_security_group.app[0].id : null
}
