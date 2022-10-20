locals {
  vpcs = {
    "${module.vpc.vpc_details.name}"  : module.vpc.vpc_details
  }
}

module "vpc" {
    source           = "../../../modules/vpc"
    vpc              = var.vpc
    ssh-key-name     = var.ssh-key-name
    prefix-name-tag  = var.prefix-name-tag
    subnets          = var.vpc-subnets
    route-tables     = var.vpc-route-tables
    security-groups  = var.vpc-security-groups
    ec2-instances    = var.vpc-instances
    global_tags      = var.global-tags
}

module "vpc-routes" {
  source             = "../../../modules/vpc_routes"
  vpc-routes         = var.vpc-routes
  vpcs               = local.vpcs
  tgw-ids            = []
  prefix-name-tag    = var.prefix-name-tag
}

output "WEB_APP_SERVER_IP_ADDRESS" {
  value = module.vpc.instance_ips["app-server"]
}