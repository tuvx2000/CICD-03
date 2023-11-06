output "vpc_id" {
  description = "NonCDE Vpc ID."
  value       = module.vpc.vpc_id
}
output "vpc_cidr_block" {
  description = "NonCDE Vpc cidr_block."
  value       = module.vpc.vpc_cidr_block
}
output "database_subnets_id" {
  description = "NonCDE Database Subnet IDs."
  value       = module.vpc.database_subnets
}
output "private_subnets_id" {
  description = "NonCDE Private Subnet IDs."
  value       = module.vpc.private_subnets
}
output "public_subnets_id" {
  description = "NonCDE Public Subnet IDs."
  value       = module.vpc.public_subnets
}

output "public_route_table_ids" {
  description = "NonCDE Public Route Table IDs."
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "NonCDE Private Route Table IDs."
  value       = module.vpc.private_route_table_ids
}

# output "NonCDE-waf-arn" {
#   description = "NonCDE Private Route Table IDs."
#   value       = aws_wafv2_web_acl.NonCDE-WAF.arn
# }

# output "opensearch-username" {
#   description = "NonCDE username of Opensearch's master user ."
#   value       = aws_opensearch_domain.opensearch.advanced_security_options[0].master_user_options[0].master_user_name
# }

