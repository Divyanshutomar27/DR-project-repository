# Input Variables #
# ec2 security group name #
variable "ec2_ssm_sg_name"{
    description = "name of ec2 security group"
    type = string
}

# ec2 ami id #
variable "ec2_ami_id"{
    description = "ami used for building ec2"
    type = string
}

# ec2 instance type #
variable "ec2_instance_type"{
    description = "instance type for ec2"
    type = string
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