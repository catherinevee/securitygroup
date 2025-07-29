output "security_group_ids" {
  description = "List of security group IDs"
  value       = [for sg in aws_security_group.this : sg.id]
}

output "security_group_arns" {
  description = "List of security group ARNs"
  value       = [for sg in aws_security_group.this : sg.arn]
}

output "security_group_names" {
  description = "List of security group names"
  value       = [for sg in aws_security_group.this : sg.name]
}

output "security_groups" {
  description = "Map of security group objects"
  value = {
    for name, sg in aws_security_group.this : name => {
      id          = sg.id
      arn         = sg.arn
      name        = sg.name
      description = sg.description
      vpc_id      = sg.vpc_id
      tags        = sg.tags
    }
  }
}

output "security_group_rules" {
  description = "Map of security group rules"
  value = {
    ingress = {
      for rule in aws_security_group_rule.ingress : rule.id => {
        security_group_id = rule.security_group_id
        type              = rule.type
        description       = rule.description
        from_port         = rule.from_port
        to_port           = rule.to_port
        protocol          = rule.protocol
        cidr_blocks       = rule.cidr_blocks
        ipv6_cidr_blocks  = rule.ipv6_cidr_blocks
        prefix_list_ids   = rule.prefix_list_ids
        self              = rule.self
      }
    }
    egress = {
      for rule in aws_security_group_rule.egress : rule.id => {
        security_group_id = rule.security_group_id
        type              = rule.type
        description       = rule.description
        from_port         = rule.from_port
        to_port           = rule.to_port
        protocol          = rule.protocol
        cidr_blocks       = rule.cidr_blocks
        ipv6_cidr_blocks  = rule.ipv6_cidr_blocks
        prefix_list_ids   = rule.prefix_list_ids
        self              = rule.self
      }
    }
  }
} 