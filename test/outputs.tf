# Test Outputs

output "test_security_group_ids" {
  description = "Test security group IDs"
  value       = module.test_security_groups.security_group_ids
}

output "test_security_group_names" {
  description = "Test security group names"
  value       = module.test_security_groups.security_group_names
}

output "test_security_groups" {
  description = "Test security group objects"
  value       = module.test_security_groups.security_groups
} 