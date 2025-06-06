locals{
    owners = var.business_division
    environment = var.environment
    name = "${var.business_division}-${var.environment}"
    private_subnet_names = [
        for az in var.vpc_availability_zones : "${local.name}-private-${az}"
    ]

    public_subnet_names = [
        for az in var.vpc_availability_zones : "${local.name}-public-${az}"
    ]

     database_subnet_names = [
        for az in var.vpc_availability_zones : "database-${local.name}-${az}"
    ]

    common_tags =  {
        owners = local.owners
        environment = local.environment
    }
}