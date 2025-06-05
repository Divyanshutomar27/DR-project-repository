# Using Hasicorp VPC Module here #
module "vpc"{
    source = "terraform-aws-modules/vpc/aws"
    name  = local.name
    cidr = var.vpc_cidr_block
    azs = var.vpc_availability_zones
    private_subnets = var.vpc_private_subnets
    public_subnets = var.vpc_public_subnets
    database_subnets = var.database_subnet

    #private subnet names #
    private_subnet_names = local.private_subnet_names

    # public subnet names#
    public_subnet_names = local.public_subnet_names

    # database subnet name #
    database_subnet_names =  local.database_subnet_names

    # ✅ Enable auto-assign public IPs on public subnets
    public_subnet_tags = {
        "map_public_ip_on_launch" = "true"
    }

    tags = local.common_tags
    
}