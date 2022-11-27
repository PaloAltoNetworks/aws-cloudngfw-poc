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

vpc-a = {
  name                 = "vpc-a"
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  internet_gateway     = true
}

vpc-a-route-tables = [
  { name = "rt", "subnet" = ["subnet"] },
  { name = "igw-rt", "edge" = ["igw"] },
  { name = "fw-rt", "subnet" = ["fw-subnet"] }
]

vpc-a-subnets = [
  { name = "subnet", cidr = "10.1.1.0/24", az = "a" },
  { name = "tgw-subnet", cidr = "10.1.2.0/24", az = "a" },
  { name = "fw-subnet", cidr = "10.1.3.0/24", az = "a" }
]

vpc-a-instances = [
  {
    name            = "web-server"
    instance_type   = "t2.micro"
    subnet          = "subnet"
    setup-file      = "ec2-startup-scripts/web-app-svr.sh"
    security_group  = "vpc-a-sg"
  }
]

vpc-a-routes = {
  vpc-a-igw = {
    name          = "vpc-a-igw"
    vpc_name      = "vpc-a"
    route_table   = "rt"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc-a"
  },
  vpc-a-fw-igw = {
    name          = "vpc-a-fw-igw"
    vpc_name      = "vpc-a"
    route_table   = "fw-rt"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc-a"
  },
  vpc-a-tgw = {
    name          = "vpc-a-tgw"
    vpc_name      = "vpc-a"
    route_table   = "rt"
    prefix        = "10.2.0.0/16"
    next_hop_type = "transit_gateway"
    next_hop_name = "tgw"
  }
}

vpc-b = {
  name                 = "vpc-b"
  cidr_block           = "10.2.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  internet_gateway     = true
}

vpc-b-route-tables = [
  { name = "rt", "subnet" = ["subnet"] },
  { name = "igw-rt", "edge" = ["igw"] },
  { name = "fw-rt", "subnet" = ["fw-subnet"] }
]

vpc-b-subnets = [
  { name = "subnet", cidr = "10.2.1.0/24", az = "a" },
  { name = "tgw-subnet", cidr = "10.2.2.0/24", az = "a" },
  { name = "fw-subnet", cidr = "10.2.3.0/24", az = "a" }
]

vpc-b-instances = [
  {
    name            = "web-server"
    instance_type   = "t2.micro"
    subnet          = "subnet"
    setup-file      = "ec2-startup-scripts/web-app-svr.sh"
    security_group  = "vpc-b-sg"
  }
]

vpc-b-routes = {
  vpc-b-igw = {
    name          = "vpc-b-igw"
    vpc_name      = "vpc-b"
    route_table   = "rt"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc-b"
  },
  vpc-b-fw-igw = {
    name          = "vpc-b-fw-igw"
    vpc_name      = "vpc-b"
    route_table   = "fw-rt"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "vpc-b"
  },
  vpc-b-tgw = {
    name          = "vpc-b-tgw"
    vpc_name      = "vpc-b"
    route_table   = "rt"
    prefix        = "10.1.0.0/16"
    next_hop_type = "transit_gateway"
    next_hop_name = "tgw"
  }
}

security-vpc = {
    name                 = "sec-vpc"
    cidr_block           = "10.3.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    internet_gateway     = true
}

security-vpc-route-tables = [
  { name = "fw-rt", "subnet" = ["fw-subnet"] },
  { name = "tgw-rt", "subnet" = ["tgw-subnet"] },
  { name = "natgw-rt", "subnet" = ["natgw-subnet"] }
]

security-vpc-routes = {
  sec-vpc-tgw-vpc-a = {
    name          = "sec-vpc-tgw-vpc-a"
    vpc_name      = "sec-vpc"
    route_table   = "fw-rt"
    prefix        = "10.1.0.0/16"
    next_hop_type = "transit_gateway"
    next_hop_name = "tgw"
  },
  sec-vpc-tgw-vpc-b = {
    name          = "sec-vpc-tgw-vpc-b"
    vpc_name      = "sec-vpc"
    route_table   = "fw-rt"
    prefix        = "10.2.0.0/16"
    next_hop_type = "transit_gateway"
    next_hop_name = "tgw"
  },
  sec-vpc-fw-natgw = {
    name          = "sec-vpc-fw-natgw"
    vpc_name      = "sec-vpc"
    route_table   = "fw-rt"
    prefix        = "0.0.0.0/0"
    next_hop_type = "nat_gateway"
    next_hop_name = "natgw"
  },
  sec-vpc-natgw-igw = {
    name          = "sec-vpc-natgw-igw"
    vpc_name      = "sec-vpc"
    route_table   = "natgw-rt"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "sec-vpc"
  }
}

security-vpc-subnets = [
  { name = "fw-subnet", cidr = "10.3.1.0/24", az = "a" },
  { name = "tgw-subnet", cidr = "10.3.2.0/24", az = "a" },
  { name = "natgw-subnet", cidr = "10.3.3.0/24", az = "a" }
]

transit-gateway = {
  name     = "tgw"
  asn      = "64512"
  route_tables = {
    security = { name = "from-sec-vpc" }
    spoke    = { name = "from-app-vpcs" }
  }
}

transit-gateway-associations = {
  "sec-vpc" = "from-sec-vpc",
  "vpc-a" = "from-app-vpcs",
  "vpc-b" = "from-app-vpcs"
}

transit-gateway-routes = {
  "sec-vpc-to-vpc-a-route" = {
    route_table = "from-sec-vpc"
    vpc_name    = "vpc-a"
    cidr_block  = "10.1.0.0/16"
  },
  "sec-vpc-to-vpc-b-route" = {
    route_table = "from-sec-vpc"
    vpc_name    = "vpc-b"
    cidr_block  = "10.2.0.0/16"
  },
  "app-vpcs-to-sec-vpc-route" = {
    route_table = "from-app-vpcs"
    vpc_name    = "sec-vpc"
    cidr_block  = "0.0.0.0/0"
  },
  "app-vpcs-to-vpc-a-route" = {
    route_table = "from-app-vpcs"
    vpc_name    = "vpc-a"
    cidr_block  = "10.1.0.0/16"
  },
  "app-vpcs-to-vpc-b-route" = {
    route_table = "from-app-vpcs"
    vpc_name    = "vpc-b"
    cidr_block  = "10.2.0.0/16"
  }
}

vpc-a-sg = [
  {
    name = "vpc-a-sg"
    rules = [
      {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit Port 80"
        type        = "ingress", from_port = "80", to_port = "80", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit Port 22 Public"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit all traffic from VPC B"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["10.2.0.0/16"]
      }
    ]
  }
]

vpc-b-sg = [
  {
    name = "vpc-b-sg"
    rules = [
      {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit Port 80"
        type        = "ingress", from_port = "80", to_port = "80", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit Port 22 Public"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit all traffic from VPC A"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["10.1.0.0/16"]
      }
    ]
  }
]

security-vpc-sg = [
  {
    name = "security-vpc-sg"
    rules = [
      {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Permit all traffic from spoke VPCs"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["10.1.0.0/16"]
      },
      {
        description = "Permit all traffic from spoke VPCs"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["10.2.0.0/16"]
      }
    ]
  }
]