# NLB Input Variables #

variable "nlb_1_name"{
    description = "name of nlb 1"
    type  = string
}

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
    description = "Organisation business division"
    type = string
}