output "vpc_id" {
  description = "prd-xuantu Vpc ID."
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "prd-xuantu Vpc cidr_block."
  value       = module.vpc.vpc_cidr_block
}

output "database_subnets_id" {
  description = "prd-xuantu Database Subnet IDs."
  value       = module.vpc.database_subnets
}

output "private_subnets_id" {
  description = "prd-xuantu Private Subnet IDs."
  value       = module.vpc.private_subnets
}

output "public_subnets_id" {
  description = "prd-xuantu Public Subnet IDs."
  value       = module.vpc.public_subnets
}

output "public_route_table_ids" {
  description = "prd-xuantu Public Route Table IDs."
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "prd-xuantu Private Route Table IDs."
  value       = module.vpc.private_route_table_ids
}

