variable "security_groups" {
  description = "Map of security group configurations"
  type = list(object({
    name                   = string
    description            = string
    vpc_id                 = string
    revoke_rules_on_delete = optional(bool, false)
    tags                   = optional(map(string), {})
    ingress_rules = list(object({
      description      = string
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = optional(list(string))
      ipv6_cidr_blocks = optional(list(string))
      prefix_list_ids  = optional(list(string))
      security_groups  = optional(list(string))
      self             = optional(bool)
    }))
    egress_rules = list(object({
      description      = string
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = optional(list(string))
      ipv6_cidr_blocks = optional(list(string))
      prefix_list_ids  = optional(list(string))
      security_groups  = optional(list(string))
      self             = optional(bool)
    }))
  }))

  validation {
    condition = alltrue([
      for sg in var.security_groups : length(sg.name) > 0
    ])
    error_message = "Security group name cannot be empty."
  }

  validation {
    condition = alltrue([
      for sg in var.security_groups : length(sg.description) > 0
    ])
    error_message = "Security group description cannot be empty."
  }

  validation {
    condition = alltrue([
      for sg in var.security_groups : can(regex("^sg-", sg.vpc_id)) || can(regex("^vpc-", sg.vpc_id))
    ])
    error_message = "VPC ID must be a valid VPC ID or security group ID."
  }
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix or fixed name. Valid values: true for name_prefix, false for fixed name"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to all security groups"
  type        = map(string)
  default     = {}
}

variable "create_security_group" {
  description = "Whether to create security group"
  type        = bool
  default     = true
}

variable "create_security_group_rules" {
  description = "Whether to create security group rules as separate resources"
  type        = bool
  default     = true
} 