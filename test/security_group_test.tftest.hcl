# Native Terraform test for AWS Security Group Module
# Tests basic functionality and validation

variables {
  security_groups = [
    {
      name        = "test-sg"
      description = "Test security group"
      vpc_id      = "vpc-test123"
      ingress_rules = [
        {
          description = "HTTP access"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
        }
      ]
      egress_rules = [
        {
          description = "All outbound"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      tags = {
        Test = "true"
      }
    }
  ]
  use_name_prefix = false
  tags = {
    Environment = "test"
  }
}

run "validate_module_structure" {
  command = plan

  assert {
    condition     = length(module.security_groups.security_group_ids) == 1
    error_message = "Expected exactly one security group to be created"
  }

  assert {
    condition     = length(module.security_groups.security_group_names) == 1
    error_message = "Expected exactly one security group name"
  }

  assert {
    condition     = module.security_groups.security_group_names[0] == "test-sg"
    error_message = "Expected security group name to be 'test-sg'"
  }
}

run "validate_rule_creation" {
  command = plan

  assert {
    condition     = length(module.security_groups.security_group_rules.ingress) > 0
    error_message = "Expected at least one ingress rule to be created"
  }

  assert {
    condition     = length(module.security_groups.security_group_rules.egress) > 0
    error_message = "Expected at least one egress rule to be created"
  }
} 