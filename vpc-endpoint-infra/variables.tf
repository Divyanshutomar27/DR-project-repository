# input variables #

# Generic Variables #
# region name #
variable "aws_region"{
    description = "region where aws resources to be created"
    type  = string
}

# Environment Variable #
variable "environment"{
    description = "Environment Variable used as a prefix"
    type  = string
}

# Business Division #
variable "business_division" {
    description = "Organization business division"
    type = string
}

variable "ssm_endpoint_sg_name" {
    description = "name of ssm endpoint security group"
    type = string
}

variable "ssm_endpoint_port" {
  description = "Port number to allow in the SSM security group"
  type        = number
}