
variable "instance-launch-config"   { default = {} }
variable "load-balancer"            { default = {} }
variable "autoscale-group"          { default = {} }
variable "vpc"                      { default = {} }
variable "lb-security-group"        { default = "" }
variable "ec2-security-group"       { default = "" }
variable "ssh-key-name"             { default = "" }
variable "prefix-name-tag"          { default = "" }
variable "global-tags"              { default = {} }