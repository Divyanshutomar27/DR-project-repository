locals{
    owners = var.business_division
    environment = var.environment
    nlb_Name = "application-nlb"
    sg_Name = "application-nlb-sg"
    tg_Name  =  "application-nlb-tg"

    nlb_tags =  {
        owners = local.owners
        environment = local.environment
        Name =  local.nlb_Name
    }

    sg_tags =  {
        owners = local.owners
        environment = local.environment
        Name =  local.sg_Name
    }

    tg_tags = {
        owners = local.owners
        environment = local.environment
        Name =  local.tg_Name
    }
}