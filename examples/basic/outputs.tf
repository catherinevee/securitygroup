# Outputs for Basic Security Group Example

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