# Outputs for Advanced Security Group Example

output "security_group_ids" {
  description = "List of security group IDs"
  value       = module.security_groups.security_group_ids
}

output "security_group_names" {
  description = "List of security group names"
  value       = module.security_groups.security_group_names
}

output "security_groups" {
  description = "Map of security group objects"
  value       = module.security_groups.security_groups
}

output "security_group_rules" {
  description = "Map of security group rules"
  value       = module.security_groups.security_group_rules
}

# Specific security group outputs for easier reference
output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = module.security_groups.security_groups["alb-sg"].id
}

output "web_servers_security_group_id" {
  description = "Web servers security group ID"
  value       = module.security_groups.security_groups["web-servers-sg"].id
}

output "database_security_group_id" {
  description = "Database security group ID"
  value       = module.security_groups.security_groups["database-sg"].id
}

output "redis_security_group_id" {
  description = "Redis security group ID"
  value       = module.security_groups.security_groups["redis-sg"].id
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value       = module.security_groups.security_groups["bastion-sg"].id
} 