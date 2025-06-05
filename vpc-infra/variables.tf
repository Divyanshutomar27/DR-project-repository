## Input Variables #

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

# VPC  Variables #
# vpc name #
variable "vpc_name"{
    description = "vpc name used"
    type = string
}

# vpc cidr block #
variable "vpc_cidr_block"{
    description = "cidr block of vpc"
    type = string
}

# VPC Availability Zones #
variable "vpc_availability_zones"{
    description = "VPC availability zones"
    type = list(string)
}

# VPC private subnets #
variable "vpc_private_subnets"{
    description  = "vpc private subnets"
    type = list(string)
}

# VPC public subnets #
variable "vpc_public_subnets"{
    description  = "vpc public subnets"
    type = list(string)
}

# RDS Subnets #
variable "database_subnet"{
    description  = "database subnet"
    type = list(string)
}