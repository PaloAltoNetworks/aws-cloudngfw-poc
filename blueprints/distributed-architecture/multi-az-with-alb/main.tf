
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
  nat-gateways     = var.nat-gateways
  global_tags      = var.global-tags
}

module "vpc-routes" {
  source          = "../../../modules/vpc_routes"
  vpc-routes      = var.vpc-routes
  vpcs            = local.vpcs
  tgw-ids         = []
  natgw_ids       = module.vpc.natgw_ids
  prefix-name-tag = var.prefix-name-tag
}

module "alb" {
  source                  = "../../../modules/alb"
  vpc                     = module.vpc.vpc_details
  ssh-key-name            = var.ssh-key-name
  load-balancer           = var.load-balancer
  autoscale-group         = var.autoscale-group
  lb-security-group       = module.vpc.security_groups["${var.prefix-name-tag}${var.load-balancer.security_group}"]
  ec2-security-group      = module.vpc.security_groups["${var.prefix-name-tag}${var.instance-launch-config.security_group}"]
  instance-launch-config  = var.instance-launch-config
  prefix-name-tag         = var.prefix-name-tag
  global-tags             = var.global-tags

  depends_on = [
    module.vpc-routes
  ]
}
