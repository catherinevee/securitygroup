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
      for sg in var.security_groups : can(regex("^vpc-", sg.vpc_id))
    ])
    error_message = "VPC ID must be a valid VPC ID starting with 'vpc-'."
  }

  validation {
    condition = alltrue([
      for sg in var.security_groups : length(sg.name) <= 255
    ])
    error_message = "Security group name must be 255 characters or less."
  }

  validation {
    condition = alltrue([
      for sg in var.security_groups : can(regex("^[a-zA-Z0-9._-]+$", sg.name))
    ])
    error_message = "Security group name can only contain alphanumeric characters, dots, underscores, and hyphens."
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

# Removed unused variables - these were defined but never implemented in the module 