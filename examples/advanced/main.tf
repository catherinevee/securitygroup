# Advanced Security Group Example
# This example demonstrates complex security group configurations with multiple groups

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

# Advanced security group module with multiple groups
module "security_groups" {
  source = "../../"

  use_name_prefix = true

  security_groups = [
    {
      name        = "alb-sg"
      description = "Security group for Application Load Balancer"
      vpc_id      = data.aws_vpc.default.id
      
      ingress_rules = [
        {
          description = "HTTP from internet"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "HTTPS from internet"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      
      egress_rules = [
        {
          description = "HTTP to web servers"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          security_groups = ["sg-web-servers"]
        }
      ]
      
      tags = {
        Environment = "production"
        Service     = "alb"
        Tier        = "public"
      }
    },
    {
      name        = "web-servers-sg"
      description = "Security group for web application servers"
      vpc_id      = data.aws_vpc.default.id
      
      ingress_rules = [
        {
          description = "HTTP from ALB"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          security_groups = ["sg-alb"]
        },
        {
          description = "SSH from bastion host"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          security_groups = ["sg-bastion"]
        },
        {
          description = "Health check from ALB"
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          security_groups = ["sg-alb"]
        }
      ]
      
      egress_rules = [
        {
          description = "Database access"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          security_groups = ["sg-database"]
        },
        {
          description = "Redis access"
          from_port   = 6379
          to_port     = 6379
          protocol    = "tcp"
          security_groups = ["sg-redis"]
        },
        {
          description = "HTTPS to internet"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      
      tags = {
        Environment = "production"
        Service     = "web"
        Tier        = "application"
      }
    },
    {
      name        = "database-sg"
      description = "Security group for database servers"
      vpc_id      = data.aws_vpc.default.id
      
      ingress_rules = [
        {
          description = "MySQL from web servers"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          security_groups = ["sg-web-servers"]
        },
        {
          description = "SSH from bastion host"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          security_groups = ["sg-bastion"]
        }
      ]
      
      egress_rules = [
        {
          description = "Limited outbound for updates"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      
      tags = {
        Environment = "production"
        Service     = "database"
        Tier        = "data"
      }
    },
    {
      name        = "redis-sg"
      description = "Security group for Redis cache"
      vpc_id      = data.aws_vpc.default.id
      
      ingress_rules = [
        {
          description = "Redis from web servers"
          from_port   = 6379
          to_port     = 6379
          protocol    = "tcp"
          security_groups = ["sg-web-servers"]
        }
      ]
      
      egress_rules = [
        {
          description = "No outbound traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = []
        }
      ]
      
      tags = {
        Environment = "production"
        Service     = "cache"
        Tier        = "data"
      }
    },
    {
      name        = "bastion-sg"
      description = "Security group for bastion host"
      vpc_id      = data.aws_vpc.default.id
      
      ingress_rules = [
        {
          description = "SSH from office"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["203.0.113.0/24"]  # Replace with your office IP range
        }
      ]
      
      egress_rules = [
        {
          description = "SSH to internal servers"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          security_groups = ["sg-web-servers", "sg-database"]
        }
      ]
      
      tags = {
        Environment = "production"
        Service     = "bastion"
        Tier        = "management"
      }
    }
  ]

  tags = {
    Project     = "production-application"
    ManagedBy   = "terraform"
    Environment = "production"
    Owner       = "platform-team"
  }
} 