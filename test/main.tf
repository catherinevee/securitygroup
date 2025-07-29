# Test configuration for Security Group Module
# This file is used to test the module functionality

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Data source to get default VPC
data "aws_vpc" "default" {
  default = true
}

# Test the security group module
module "test_security_groups" {
  source = "../"

  security_groups = [
    {
      name        = "test-web-sg"
      description = "Test security group for web servers"
      vpc_id      = data.aws_vpc.default.id
      
      ingress_rules = [
        {
          description = "HTTP access"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "HTTPS access"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      
      egress_rules = [
        {
          description = "All outbound traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      
      tags = {
        Environment = "test"
        Service     = "web"
        Test        = "true"
      }
    },
    {
      name        = "test-db-sg"
      description = "Test security group for database"
      vpc_id      = data.aws_vpc.default.id
      
      ingress_rules = [
        {
          description = "Database access from web servers"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          security_groups = ["sg-test-web"]
        }
      ]
      
      egress_rules = [
        {
          description = "Limited outbound"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      
      tags = {
        Environment = "test"
        Service     = "database"
        Test        = "true"
      }
    }
  ]

  tags = {
    Project     = "test-project"
    ManagedBy   = "terraform"
    Environment = "test"
  }
} 