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
  { name = "rt", "subnet" = ["subnet"] },
  { name = "igw-rt", "edge" = ["igw"] },
  { name = "fw-rt", "subnet" = ["fw-subnet"] }
]

vpc-subnets = [
  { name = "subnet", cidr = "10.1.1.0/24", az = "a" },
  { name = "fw-subnet", cidr = "10.1.2.0/24", az = "a" }
]

vpc-security-groups = [
  {
    name = "sg"
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
      },
      {
        description = "Permit ICMP Public"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
]

vpc-instances = [
  {
    name           = "app-server"
    instance_type  = "t2.micro"
    subnet         = "subnet"
    setup-file     = "ec2-startup-scripts/web-app-svr.sh"
    security_group = "sg"
  }
]

vpc-routes = {
  app-igw = {
    name          = "vpc-igw"
    vpc_name      = "vpc"
    route_table   = "rt"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc"
  }
}