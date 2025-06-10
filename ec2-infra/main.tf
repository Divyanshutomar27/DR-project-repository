# calling vpc id using data source block #
data "aws_vpc" "vpc_id"{
    filter{
        name = "tag:Name"
        values = ["Business-Division-dev"]
    }
}

# calling private subnet as data source #
data "aws_subnet"  "private_subnet1" {
  filter {
    name = "tag:Name"
    values = ["Business-Division-dev-private-ap-south-1a"]
  }
}

# calling public subnet as data source #
data "aws_subnet"  "public_subnet1" {
  filter {
    name = "tag:Name"
    values = ["Business-Division-dev-public-ap-south-1a"]
  }
}

data "aws_subnet"  "private_subnet2" {
  filter {
    name = "tag:Name"
    values = ["Business-Division-dev-private-ap-south-1b"]
  }
}

# vpc endpoint security group #

resource "aws_security_group" "ec2_sg" {
  name        = var.ec2_ssm_sg_name
  description = "Allow EC2 instances to connect to SSM"
  vpc_id      = data.aws_vpc.vpc_id.id

  ingress {
    description = "Allow connectivity from public"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.sg_tags
}


resource "aws_instance" "web" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  # user_data =  file("./ssm-user.sh")
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id = data.aws_subnet.public_subnet1.id
  associate_public_ip_address = true
  tags = local.ec2_tags
}

## iam role ##
resource "aws_iam_role" "ssm_ec2_role" {
  name = "ssm-session-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_managed_policy" {
  name        = "AmazonSSMManagedInstanceCore-Custom"
  description = "Allow SSM access for EC2 via Session Manager"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ds:CreateComputer",
                "ds:DescribeDirectories",
                "ec2:DescribeInstanceStatus",
                "logs:*",
                "ssm:*",
                "ec2messages:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "ssm.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:DeleteServiceLinkedRole",
                "iam:GetServiceLinkedRoleDeletionStatus"
            ],
            "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        }
    ]
})
}


resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_ec2_role.name
  policy_arn = aws_iam_policy.ssm_managed_policy.arn
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_ec2_role.name
}
