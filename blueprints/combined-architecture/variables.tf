
variable "access-key"               { default = "" }
variable "secret-key"               { default = "" }
variable "region"                   { default = "" }
variable "ssh-key-name"             { default = "" }

variable "vpc-a"                    { default = {} }
variable "vpc-a-subnets"            { default = [] }
variable "vpc-a-route-tables"       { default = [] }
variable "vpc-a-sg"                 { default = [] }
variable "vpc-a-instances"          { default = [] }
variable "vpc-a-routes"             { default = [] }

variable "vpc-b"                    { default = {} }
variable "vpc-b-subnets"            { default = [] }
variable "vpc-b-route-tables"       { default = [] }
variable "vpc-b-instances"          { default = [] }
variable "vpc-b-sg"                 { default = [] }
variable "vpc-b-routes"             { default = [] }

variable "security-vpc"             { default = {} }
variable "security-vpc-subnets"     { default = [] }
variable "security-vpc-route-tables"{ default = [] }
variable "security-vpc-routes"      { default = [] }
variable "security-vpc-sg"          { default = [] }

variable transit-gateway            { default = {} }
variable transit-gateway-associations   { default = {} }
variable transit-gateway-routes     { default = {} }

variable "prefix-name-tag"          { default = "" }
variable global-tags                { default = {} }