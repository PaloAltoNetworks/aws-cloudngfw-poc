variable "access-key"           { default = "" }
variable "secret-key"           { default = "" }
variable "region"               { default = "" }
variable "ssh-key-name"         { default = "" }
variable "vpc"                  { default = {} }
variable "vpc-subnets"          { default = [] }
variable "vpc-route-tables"     { default = [] }
variable "vpc-security-groups"  { default = [] }
variable "vpc-instances"        { default = [] }
variable "vpc-routes"           { default = [] }
variable "prefix-name-tag"      { default = "" }
variable "global-tags"          { default = {} }