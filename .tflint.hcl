# TFLint configuration for AWS Security Group Module

plugin "aws" {
  enabled = true
  version = "0.27.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
  module = true
  force  = false
}

# AWS provider configuration
rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_instance_invalid_ami" {
  enabled = true
}

# Security group specific rules
rule "aws_security_group_rule_invalid_type" {
  enabled = true
}

rule "aws_security_group_rule_invalid_protocol" {
  enabled = true
}

# General Terraform rules
rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
} 