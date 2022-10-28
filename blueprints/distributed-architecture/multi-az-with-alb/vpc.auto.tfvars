############################################################
# Make sure to fill in the values for access-key, secret-key
# and region before running the terraform.
############################################################
access-key      = ""
secret-key      = ""
region          = ""
ssh-key-name    = ""

# Pre-defined tags. You can choose to modify these if you want to.
prefix-name-tag = "cloudngfw-"
global-tags         = {
  managedBy   = "Terraform"
  application = "Palo Alto Networks Cloud NGFW"
  owner       = "Palo Alto Networks - Software NGFW Products Team"
}

vpc = {
  name                 = "vpc"
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  internet_gateway     = true
}

vpc-route-tables = [
  { name = "rt-a", subnet = ["subnet-a"] },
  { name = "rt-b", subnet = ["subnet-b"] },
  { name = "lb-rt-a", subnet = ["lb-subnet-a"] },
  { name = "lb-rt-b", subnet = ["lb-subnet-b"] },
  { name = "fw-ingress-rt-a", subnet = ["fw-ingress-subnet-a"] },
  { name = "fw-ingress-rt-b", subnet = ["fw-ingress-subnet-b"] },
  { name = "fw-egress-rt-a", subnet = ["fw-egress-subnet-a"] },
  { name = "fw-egress-rt-b", subnet = ["fw-egress-subnet-b"] },
  { name = "natgw-rt-a", subnet = ["natgw-subnet-a"] },
  { name = "natgw-rt-b", subnet = ["natgw-subnet-b"] },
  { name = "igw-rt", edge = ["igw"] }
]

vpc-subnets = [
  { name = "subnet-a", cidr = "10.1.1.0/24", az = "a" },
  { name = "subnet-b", cidr = "10.1.2.0/24", az = "b" },
  { name = "lb-subnet-a", cidr = "10.1.3.0/24", az = "a" },
  { name = "lb-subnet-b", cidr = "10.1.4.0/24", az = "b" },
  { name = "fw-ingress-subnet-a", cidr = "10.1.5.0/24", az = "a" },
  { name = "fw-ingress-subnet-b", cidr = "10.1.6.0/24", az = "b" },
  { name = "fw-egress-subnet-a", cidr = "10.1.7.0/24", az = "a" },
  { name = "fw-egress-subnet-b", cidr = "10.1.8.0/24", az = "b" },
  { name = "natgw-subnet-a", cidr = "10.1.9.0/24", az = "a" },
  { name = "natgw-subnet-b", cidr = "10.1.10.0/24", az = "b" }
]

vpc-security-groups = [
  {
    name = "lb-sg"
    rules = [
      {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit Port 80 Public"
        type        = "ingress", from_port = "80", to_port = "80", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit Port 22 Public"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
  {
    name = "ec2-sg"
    rules = [
      {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit Port 80 Public"
        type        = "ingress", from_port = "80", to_port = "80", protocol = "tcp"
        cidr_blocks = ["10.1.0.0/16"]
      },
      {
        description = "Permit Port 22 Public"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["10.1.0.0/16"]
      }
    ]
  }
]

nat-gateways = {
  natgw-a = {
    name = "natgw-a", 
    subnet = "natgw-subnet-a"
  },
  natgw-b = {
    name = "natgw-b", 
    subnet = "natgw-subnet-b"
  }
}

vpc-routes = {
  app-natgw-a = {
    name          = "app-natgw-a"
    vpc_name      = "vpc"
    route_table   = "rt-a"
    prefix        = "0.0.0.0/0"
    next_hop_type = "nat_gateway"
    next_hop_name = "natgw-a"
  },
  app-natgw-b = {
    name          = "app-natgw-b"
    vpc_name      = "vpc"
    route_table   = "rt-b"
    prefix        = "0.0.0.0/0"
    next_hop_type = "nat_gateway"
    next_hop_name = "natgw-b"
  },
  natgw-a-igw = {
    name          = "natgw-a-igw"
    vpc_name      = "vpc"
    route_table   = "natgw-rt-a"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc"
  },
  natgw-b-igw = {
    name          = "natgw-b-igw"
    vpc_name      = "vpc"
    route_table   = "natgw-rt-b"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc"
  },
  lb-a-igw = {
    name          = "lb-a-igw"
    vpc_name      = "vpc"
    route_table   = "lb-rt-a"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc"
  },
  lb-b-igw = {
    name          = "lb-b-igw"
    vpc_name      = "vpc"
    route_table   = "lb-rt-b"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc"
  },
  fw-a-igw = {
    name          = "fw-a-igw"
    vpc_name      = "vpc"
    route_table   = "fw-ingress-rt-a"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc"
  },
  fw-b-igw = {
    name          = "fw-b-igw"
    vpc_name      = "vpc"
    route_table   = "fw-ingress-rt-b"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc"
  },
  fw-a-natgw = {
    name          = "fw-a-natgw"
    vpc_name      = "vpc"
    route_table   = "fw-egress-rt-a"
    prefix        = "0.0.0.0/0"
    next_hop_type = "nat_gateway"
    next_hop_name = "natgw-a"
  },
  fw-b-natgw = {
    name          = "fw-b-natgw"
    vpc_name      = "vpc"
    route_table   = "fw-egress-rt-b"
    prefix        = "0.0.0.0/0"
    next_hop_type = "nat_gateway"
    next_hop_name = "natgw-b"
  }
}

vpc-instances = [
  {
    name           = "jump-host"
    instance_type  = "t2.micro"
    subnet         = "fw-ingress-subnet-a"
    setup-file     = "ec2-startup-scripts/jump-host.sh"
    security_group = "lb-sg"
  }
]