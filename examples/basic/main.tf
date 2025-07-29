# Basic Security Group Example
# This example demonstrates a simple security group configuration

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

# Basic security group module
module "security_groups" {
  source = "../../"

  security_groups = [
    {
      name        = "web-server-sg"
      description = "Security group for web servers"
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
        },
        {
          description = "SSH access from office"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["203.0.113.0/24"]  # Replace with your office IP range
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
        Environment = "development"
        Service     = "web"
        Owner       = "devops-team"
      }
    }
  ]

  tags = {
    Project     = "web-application"
    ManagedBy   = "terraform"
    Environment = "development"
  }
} 