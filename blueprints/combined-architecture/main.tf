locals {
  vpcs = {
    "${module.vpc-a.vpc_details.name}"  : module.vpc-a.vpc_details,
    "${module.vpc-b.vpc_details.name}"  : module.vpc-b.vpc_details,
    "${module.security-vpc.vpc_details.name}"  : module.security-vpc.vpc_details
  }
}

module "vpc-a" {
    source           = "../../modules/vpc"
    vpc              = var.vpc-a
    ssh-key-name     = var.ssh-key-name
    prefix-name-tag  = var.prefix-name-tag
    subnets          = var.vpc-a-subnets
    route-tables     = var.vpc-a-route-tables
    security-groups  = var.vpc-a-sg
    ec2-instances    = var.vpc-a-instances
    global_tags      = var.global-tags
}

module "vpc-b" {
    source           = "../../modules/vpc"
    vpc              = var.vpc-b
    ssh-key-name     = var.ssh-key-name
    prefix-name-tag  = var.prefix-name-tag
    subnets          = var.vpc-b-subnets
    route-tables     = var.vpc-b-route-tables
    security-groups  = var.vpc-b-sg
    ec2-instances    = var.vpc-b-instances
    global_tags      = var.global-tags
}

module "security-vpc" {
    source           = "../../modules/vpc"
    vpc              = var.security-vpc
    ssh-key-name     = var.ssh-key-name
    prefix-name-tag  = var.prefix-name-tag
    subnets          = var.security-vpc-subnets
    route-tables     = var.security-vpc-route-tables
    security-groups  = var.security-vpc-sg
    global_tags      = var.global-tags
}

module "transit-gateway" {
  source          = "../../modules/transit-gateway"
  transit-gateway = var.transit-gateway
  prefix-name-tag = var.prefix-name-tag
  global_tags     = var.global-tags
  vpcs            = local.vpcs
  transit-gateway-associations = var.transit-gateway-associations
  transit-gateway-routes       = var.transit-gateway-routes

  depends_on = [
    module.security-vpc
  ]
}

module "vpc-routes" {
  source             = "../../modules/vpc_routes"
  vpc-routes         = merge(var.vpc-a-routes, var.vpc-b-routes)
  vpcs               = local.vpcs
  tgw-ids            = module.transit-gateway.tgw-ids
  prefix-name-tag    = var.prefix-name-tag
}

output "VPC-A-WEB-SERVER-ADDRESS" {
  value = module.vpc-a.instance_ips["web-server"]
}

output "VPC-B-WEB-SERVER-ADDRESS" {
  value = module.vpc-b.instance_ips["web-server"]
}