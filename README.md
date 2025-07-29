# AWS Security Group Terraform Module

This Terraform module creates AWS security groups with configurable ingress and egress rules. It follows AWS best practices and provides a flexible, reusable solution for managing security groups across different environments.

## Features

- **Multiple Security Groups**: Create multiple security groups in a single module call
- **Flexible Rule Configuration**: Support for ingress and egress rules with various source types
- **Comprehensive Validation**: Input validation to ensure proper configuration
- **Tagging Support**: Automatic tagging with custom tags
- **Name Prefix Support**: Option to use name prefixes for better resource management
- **Separate Rule Resources**: Security group rules as separate resources for better management

## Usage

### Basic Example

```hcl
module "security_groups" {
  source = "./securitygroup"

  security_groups = [
    {
      name        = "web-sg"
      description = "Security group for web servers"
      vpc_id      = "vpc-12345678"
      
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
        Environment = "production"
        Service     = "web"
      }
    }
  ]

  tags = {
    Project     = "my-project"
    ManagedBy   = "terraform"
  }
}
```

### Advanced Example with Multiple Security Groups

```hcl
module "security_groups" {
  source = "./securitygroup"

  use_name_prefix = true

  security_groups = [
    {
      name        = "web-sg"
      description = "Security group for web servers"
      vpc_id      = "vpc-12345678"
      
      ingress_rules = [
        {
          description = "HTTP from ALB"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          security_groups = ["sg-alb123456"]
        },
        {
          description = "SSH access"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
        }
      ]
      
      egress_rules = [
        {
          description = "Database access"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          security_groups = ["sg-db123456"]
        }
      ]
    },
    {
      name        = "database-sg"
      description = "Security group for database servers"
      vpc_id      = "vpc-12345678"
      
      ingress_rules = [
        {
          description = "MySQL from web servers"
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          security_groups = ["sg-web123456"]
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
    }
  ]

  tags = {
    Environment = "production"
    Project     = "my-application"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| security_groups | List of security group configurations | `list(object)` | n/a | yes |
| use_name_prefix | Whether to use name_prefix or fixed name | `bool` | `false` | no |
| tags | A map of tags to assign to all security groups | `map(string)` | `{}` | no |
| create_security_group | Whether to create security group | `bool` | `true` | no |
| create_security_group_rules | Whether to create security group rules as separate resources | `bool` | `true` | no |

### Security Group Configuration

Each security group in the `security_groups` list supports the following attributes:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the security group | `string` | n/a | yes |
| description | Description of the security group | `string` | n/a | yes |
| vpc_id | VPC ID where the security group will be created | `string` | n/a | yes |
| revoke_rules_on_delete | Whether to revoke all of the security group's attached ingress and egress rules before deleting the security group | `bool` | `false` | no |
| tags | A map of tags to assign to the security group | `map(string)` | `{}` | no |
| ingress_rules | List of ingress rules | `list(object)` | `[]` | no |
| egress_rules | List of egress rules | `list(object)` | `[]` | no |

### Rule Configuration

Each rule (ingress or egress) supports the following attributes:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | Description of the rule | `string` | n/a | yes |
| from_port | Start port (or ICMP type number if protocol is "icmp" or "icmpv6") | `number` | n/a | yes |
| to_port | End port (or ICMP code if protocol is "icmp" or "icmpv6") | `number` | n/a | yes |
| protocol | Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number | `string` | n/a | yes |
| cidr_blocks | List of CIDR blocks | `list(string)` | `null` | no |
| ipv6_cidr_blocks | List of IPv6 CIDR blocks | `list(string)` | `null` | no |
| prefix_list_ids | List of prefix list IDs | `list(string)` | `null` | no |
| security_groups | List of security group IDs | `list(string)` | `null` | no |
| self | Whether the security group itself will be added as a source | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_ids | List of security group IDs |
| security_group_arns | List of security group ARNs |
| security_group_names | List of security group names |
| security_groups | Map of security group objects |
| security_group_rules | Map of security group rules |

## Examples

See the `examples/` directory for complete working examples:

- `examples/basic/` - Basic security group configuration
- `examples/advanced/` - Advanced configuration with multiple security groups and complex rules

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Best Practices

1. **Principle of Least Privilege**: Only allow necessary ports and protocols
2. **Use Security Group References**: Reference other security groups instead of CIDR blocks when possible
3. **Descriptive Names**: Use clear, descriptive names for security groups and rules
4. **Tagging**: Always tag your security groups for better resource management
5. **Validation**: Use the built-in validation rules to catch configuration errors early

## Security Considerations

- Avoid using `0.0.0.0/0` for ingress rules unless absolutely necessary
- Use security group references instead of broad CIDR ranges when possible
- Regularly review and audit security group rules
- Consider using AWS Config rules to monitor security group compliance

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is licensed under the Apache License 2.0. See the LICENSE file for details.