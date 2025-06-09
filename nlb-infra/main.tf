# calling application ec2 as data source block #
data "aws_instance" "application_ec2"{
    filter{
        name = "tag:Name"
        values = ["Business-Division-1-dev-ec2"]
    }
}

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

data "aws_subnet"  "public_subnet1" {
  filter {
    name = "tag:Name"
    values = ["Business-Division-1-dev-public-ap-south-1a"]
  }
}

data "aws_subnet"  "private_subnet2" {
  filter {
    name = "tag:Name"
    values = ["Business-Division-1-dev-private-ap-south-1b"]
  }
}

# application nlb security sg #
resource "aws_security_group" "application-nlb-sg" {
  name        = "application-nlb-sg"
  description = "application-nlb-sg"
  vpc_id     = data.aws_vpc.vpc_id.id # Replace with your VPC ID

  # Add your desired ingress and egress rules here
  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for your needs
  }
  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust for your needs
  }

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1" # Any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.sg_tags
}

resource "aws_lb" "ec2-nlb" {
  name               = local.nlb_Name
  internal           = false
  load_balancer_type = "network"
  security_groups = [aws_security_group.application-nlb-sg.id]
  subnets            = [data.aws_subnet.public_subnet1.id]

  tags = local.nlb_tags
}

resource "aws_lb_listener" "ec2-nlb-listner" {
  load_balancer_arn = aws_lb.ec2-nlb.arn
  port              = "80"
  protocol          = "TCP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-tg.arn
  }
}

resource "aws_lb_target_group" "ec2-tg" {
  name        = local.tg_Name
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.vpc_id.id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    port     = "traffic-port"
  }

  tags = local.tg_tags
}

resource "aws_lb_target_group_attachment" "ec2_ip_target" {
  target_group_arn = aws_lb_target_group.ec2-tg.arn
  target_id        = data.aws_instance.application_ec2.private_ip
  port             = 80
}
