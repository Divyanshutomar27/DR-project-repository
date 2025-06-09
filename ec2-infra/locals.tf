locals{
    owners = var.business_division
    environment = var.environment
    ec2_name = "${var.business_division}-${var.environment}-ec2"
    sg_name = "${var.business_division}-${var.environment}-sg"

    ec2_tags =  {
        owners = local.owners
        environment = local.environment
        Name =  local.ec2_name
    }
    sg_tags =  {
        owners = local.owners
        environment = local.environment
        Name =  local.sg_name
    }
}