# Security Group Module
# This module creates AWS security groups with configurable rules

locals {
  # Create a map of security groups with their rules
  security_groups = {
    for sg in var.security_groups : sg.name => {
      name                   = sg.name
      description            = sg.description
      vpc_id                 = sg.vpc_id
      revoke_rules_on_delete = sg.revoke_rules_on_delete
      tags                   = merge(var.tags, sg.tags, { Name = sg.name })
    }
  }

  # Flatten all ingress rules for easier processing
  ingress_rules = flatten([
    for sg_name, sg in var.security_groups : [
      for rule in sg.ingress_rules : merge(rule, {
        security_group_name = sg_name
        rule_type          = "ingress"
      })
    ]
  ])

  # Flatten all egress rules for easier processing
  egress_rules = flatten([
    for sg_name, sg in var.security_groups : [
      for rule in sg.egress_rules : merge(rule, {
        security_group_name = sg_name
        rule_type          = "egress"
      })
    ]
  ])
}

# Create security groups
resource "aws_security_group" "this" {
  for_each = local.security_groups

  name_prefix = var.use_name_prefix ? "${each.value.name}-" : null
  name        = var.use_name_prefix ? null : each.value.name

  description            = each.value.description
  vpc_id                 = each.value.vpc_id
  revoke_rules_on_delete = each.value.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = [
      for rule in local.ingress_rules : rule
      if rule.security_group_name == each.key
    ]

    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      self             = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = [
      for rule in local.egress_rules : rule
      if rule.security_group_name == each.key
    ]

    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      self             = lookup(egress.value, "self", null)
    }
  }

  tags = each.value.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Create security group rules as separate resources for better management
resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in local.ingress_rules : "${rule.security_group_name}-ingress-${rule.description}-${rule.from_port}-${rule.to_port}-${rule.protocol}" => rule
  }

  security_group_id = aws_security_group.this[each.value.security_group_name].id
  type              = "ingress"

  description      = each.value.description
  from_port        = each.value.from_port
  to_port          = each.value.to_port
  protocol         = each.value.protocol
  cidr_blocks      = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids  = lookup(each.value, "prefix_list_ids", null)
  source_security_group_id = length(lookup(each.value, "security_groups", [])) > 0 ? each.value.security_groups[0] : null
  self             = lookup(each.value, "self", null)

  depends_on = [aws_security_group.this]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for rule in local.egress_rules : "${rule.security_group_name}-egress-${rule.description}-${rule.from_port}-${rule.to_port}-${rule.protocol}" => rule
  }

  security_group_id = aws_security_group.this[each.value.security_group_name].id
  type              = "egress"

  description      = each.value.description
  from_port        = each.value.from_port
  to_port          = each.value.to_port
  protocol         = each.value.protocol
  cidr_blocks      = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids  = lookup(each.value, "prefix_list_ids", null)
  source_security_group_id = length(lookup(each.value, "security_groups", [])) > 0 ? each.value.security_groups[0] : null
  self             = lookup(each.value, "self", null)

  depends_on = [aws_security_group.this]

  lifecycle {
    create_before_destroy = true
  }
} 