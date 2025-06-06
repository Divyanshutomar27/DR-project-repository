locals{
    owners = var.business_division
    environment = var.environment
    sg_name = "ssm-vpc-endpoints-sg"
    ssm_name = "ssm-service-vpc-endpoint"
    ec2messages_name = "ec2messages-service-vpc-endpoint"
    ssmmessages_name = "ssmmessages-service-vpc-endpoint"


    ssm_sg_tags =  {
        owners = local.owners
        environment = local.environment
        Name = local.sg_name
        }

    ssm_endpoint_tags =  {
        owners = local.owners
        environment = local.environment
        Name = local.ssm_name
    }

    ec2messages_endpoint_tags =  {
        owners = local.owners
        environment = local.environment
        Name = local.ec2messages_name
    }

    ssmmessages_endpoint_tags =  {
        owners = local.owners
        environment = local.environment
        Name = ssmmessages_name
    }
}