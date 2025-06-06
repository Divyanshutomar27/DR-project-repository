#########################
# VPC Endpoint Infra #
#########################

# calling vpc id using data source block #
data "aws_vpc" "vpc_id"{
    filter{
        name = "tag:Name"
        values = ["Business-Division-1-dev"]
    }
}

# calling private subnet as data source #
data "aws_subnet"  "private_subnet1" {
  filter {
    name = "tag:Name"
    values = ["Business-Division-1-dev-private-ap-south-1a"]
  }
}

data "aws_subnet"  "private_subnet2" {
  filter {
    name = "tag:Name"
    values = ["Business-Division-1-dev-private-ap-south-1b"]
  }
}

# vpc endpoint security group #

resource "aws_security_group" "ssm_endpoints_sg" {
  name        = var.ssm_endpoint_sg_name
  description = "Allow EC2 instances to connect to SSM VPC interface endpoints"
  vpc_id      = data.aws_vpc.vpc_id.id

  # Allow HTTPS from private subnets
  dynamic "ingress" {
    for_each = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
    content {
      description = "Allow HTTPS from private subnet"
      from_port   = var.ssm_endpoint_port
      to_port     = var.ssm_endpoint_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.ssm_sg_tags
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.8.1"  # replace with latest if needed
  vpc_id = data.aws_vpc.vpc_id.id
  endpoints = {
    ssm = {
      service             = "ssm"
      service_type        = "Interface"
      # private_dns_enabled = true
      subnet_ids = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
      tags = local.ssm_endpoint_tags
    }

    ec2messages = {
      service             = "ec2messages"
      service_type        = "Interface"
      # private_dns_enabled = true
      subnet_ids = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
      tags = local.ec2messages_endpoint_tags
    }

    ssmmessages = {
      service             = "ssmmessages"
      service_type        = "Interface"
      # private_dns_enabled = true
      subnet_ids = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
      tags = local.ssmmessages_endpoint_tags
    }
  }

}