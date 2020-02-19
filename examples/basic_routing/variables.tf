# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables.
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region in which all resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "dev_ttl" {
  description = "The TTL ( Time to Live ) for the dev. A record."
  type        = number
  default     = 1800
}

variable "dev_targets" {
  description = "The records for the dev. A record."
  type        = any
  default = [
    "172.217.16.111",
  ]
}

variable "primary_ttl" {
  description = "The TTL ( Time to Live ) for the primary A record."
  type        = number
  default     = 1800
}

variable "primary_targets" {
  description = "The records for the primary A record."
  type        = any
  default = [
    "172.217.16.206",
    "172.217.18.163"
  ]
}

variable "zone_name" {
  description = "The name of the hosted zone."
  type        = string
  default     = "mineiros.io"
}
